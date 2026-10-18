// keyMouse: turn Left Alt + H/J/K/L/U/D/Enter/Backspace into mouse actions.
//
// Design: ALL keyboards are grabbed and multiplexed through one epoll loop.
// Mouse-mode state (alt/slow) is global, not per-device, so it works with any
// number of keyboards, including Alt on one and H/J/K/L on another.
//
// Build: gcc -O2 -Wall -o keymouse keymouse.c
// Usage: keymouse                 # auto-detect and grab every keyboard
//        keymouse /dev/input/eventX [/dev/input/eventY ...]   # only these

#define _GNU_SOURCE

#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <linux/input.h>
#include <linux/uinput.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/epoll.h>
#include <sys/inotify.h>
#include <sys/ioctl.h>
#include <sys/time.h>
#include <unistd.h>

enum {
  FAST_STEP = 30,
  SLOW_STEP = 12,
  MAX_KBD = 16,
};

#define BITS_PER_LONG (sizeof(unsigned long) * 8)
#define NBITS(x) ((((x) - 1) / BITS_PER_LONG) + 1)
#define test_bit(bit, array)                                                   \
  ((array[(bit) / BITS_PER_LONG] >> ((bit) % BITS_PER_LONG)) & 1)

/* ------------------------------------------------------------------------ */
/* uinput output side                                                        */
/* ------------------------------------------------------------------------ */

static int ui_fd = -1;
static bool vdown[KEY_MAX + 1]; // keys currently down on the virtual device

static int emit_event(unsigned short type, unsigned short code, int value) {
  struct input_event ev;
  memset(&ev, 0, sizeof(ev));
  gettimeofday(&ev.time, NULL);
  ev.type = type;
  ev.code = code;
  ev.value = value;
  return write(ui_fd, &ev, sizeof(ev)) == (ssize_t)sizeof(ev) ? 0 : -1;
}

static int emit_syn(void) { return emit_event(EV_SYN, SYN_REPORT, 0); }

static int emit_key(int code, int value) {
  if (emit_event(EV_KEY, code, value) < 0)
    return -1;
  return emit_syn();
}

// Forward a key to the virtual device, never emitting orphan releases/repeats.
static int fwd(int code, int value) {
  if (code < 0 || code > KEY_MAX)
    return 0;
  if (value != 1 && !vdown[code])
    return 0;
  vdown[code] = (value != 0);
  return emit_key(code, value);
}

static void release_all(void) {
  for (int c = 1; c <= KEY_MAX; c++)
    if (vdown[c])
      fwd(c, 0);
}

static int emit_move(int dx, int dy) {
  if (dx != 0 && emit_event(EV_REL, REL_X, dx) < 0)
    return -1;
  if (dy != 0 && emit_event(EV_REL, REL_Y, dy) < 0)
    return -1;
  return emit_syn();
}

static int emit_scroll(int clicks) {
  if (clicks != 0 && emit_event(EV_REL, REL_WHEEL, clicks) < 0)
    return -1;
  return emit_syn();
}

static int emit_click(int button_code) {
  if (emit_event(EV_KEY, button_code, 1) < 0 || emit_syn() < 0)
    return -1;
  usleep(25000); // 25ms hold time
  if (emit_event(EV_KEY, button_code, 0) < 0 || emit_syn() < 0)
    return -1;
  return 0;
}

static int setup_uinput_device(void) {
  int fd = open("/dev/uinput", O_WRONLY | O_NONBLOCK | O_CLOEXEC);
  if (fd < 0)
    return -1;

  ioctl(fd, UI_SET_EVBIT, EV_SYN);
  ioctl(fd, UI_SET_EVBIT, EV_REL);
  ioctl(fd, UI_SET_RELBIT, REL_X);
  ioctl(fd, UI_SET_RELBIT, REL_Y);
  ioctl(fd, UI_SET_RELBIT, REL_WHEEL);

  ioctl(fd, UI_SET_EVBIT, EV_KEY);
  ioctl(fd, UI_SET_KEYBIT, BTN_LEFT);
  ioctl(fd, UI_SET_KEYBIT, BTN_RIGHT);

  for (int key = 1; key < KEY_MAX; key++)
    ioctl(fd, UI_SET_KEYBIT, key);

  struct uinput_setup usetup;
  memset(&usetup, 0, sizeof(usetup));
  snprintf(usetup.name, UINPUT_MAX_NAME_SIZE, "keyMouse controller");
  usetup.id.bustype = BUS_USB;
  usetup.id.vendor = 0x1;
  usetup.id.product = 0x1;
  usetup.id.version = 1;

  if (ioctl(fd, UI_DEV_SETUP, &usetup) < 0 || ioctl(fd, UI_DEV_CREATE) < 0) {
    close(fd);
    return -1;
  }
  return fd;
}

/* ------------------------------------------------------------------------ */
/* Global mouse-mode logic (shared by every keyboard)                        */
/* ------------------------------------------------------------------------ */

static struct {
  bool alt_down;  // Physical Left Alt is held (on any keyboard)
  bool alt_sent;  // Deferred Left Alt has been emitted to uinput
  bool slow_held; // F is held (precision mode)
} st;

static bool is_modifier(int c) {
  return c == KEY_LEFTCTRL || c == KEY_RIGHTCTRL || c == KEY_LEFTSHIFT ||
         c == KEY_RIGHTSHIFT || c == KEY_LEFTMETA || c == KEY_RIGHTMETA;
}

// Derived from the virtual device, so it is correct across all keyboards.
static bool other_modifier_active(void) {
  for (int c = 1; c <= KEY_MAX; c++)
    if (vdown[c] && is_modifier(c))
      return true;
  return false;
}

// One logical key event, already de-duplicated across devices.
static void handle_key(int code, int value) {
  // 1. Other modifiers: flush a pending Left Alt first.
  if (is_modifier(code)) {
    if (value == 1 && st.alt_down && !st.alt_sent) {
      fwd(KEY_LEFTALT, 1);
      st.alt_sent = true;
    }
    fwd(code, value);
    return;
  }

  // 2. Left Alt management (deferred until we know it isn't mouse mode)
  if (code == KEY_LEFTALT) {
    if (value == 1) {
      st.alt_down = true;
      if (!st.alt_sent && other_modifier_active()) {
        fwd(KEY_LEFTALT, 1);
        st.alt_sent = true;
      }
    } else if (value == 0) {
      if (st.alt_sent)
        fwd(KEY_LEFTALT, 0);
      st.alt_down = st.alt_sent = st.slow_held = false;
    } else if (st.alt_sent) {
      fwd(KEY_LEFTALT, 2);
    }
    return;
  }

  // 3. Releases: always forward (fwd drops orphans for keys we swallowed)
  if (value == 0) {
    if (code == KEY_F)
      st.slow_held = false;
    fwd(code, 0);
    return;
  }

  // 4. Mouse mode
  if (st.alt_down && !st.alt_sent) {
    int step = st.slow_held ? SLOW_STEP : FAST_STEP;
    int rc = 0;
    bool handled = true;

    switch (code) {
    case KEY_F:
      st.slow_held = true;
      break;
    case KEY_H:
      rc = emit_move(-step, 0);
      break;
    case KEY_J:
      rc = emit_move(0, step);
      break;
    case KEY_K:
      rc = emit_move(0, -step);
      break;
    case KEY_L:
      rc = emit_move(step, 0);
      break;
    case KEY_U:
      rc = emit_scroll(1);
      break;
    case KEY_D:
      rc = emit_scroll(-1);
      break;
    case KEY_ENTER:
    case KEY_KPENTER:
      if (value == 1)
        rc = emit_click(BTN_LEFT);
      break;
    case KEY_BACKSPACE:
      if (value == 1)
        rc = emit_click(BTN_RIGHT);
      break;
    default:
      handled = false;
      break;
    }

    if (rc < 0)
      fprintf(stderr, "Failed to emit mouse action: %s\n", strerror(errno));
    if (handled)
      return;

    // Unhandled key during Alt hold: flush pending Alt, act as normal Alt+key
    fwd(KEY_LEFTALT, 1);
    st.alt_sent = true;
  }

  // 5. Normal passthrough
  fwd(code, value);
}

/* ------------------------------------------------------------------------ */
/* Per-device bookkeeping (only what is truly per-device)                    */
/* ------------------------------------------------------------------------ */

struct kbd {
  int fd; // -1 = free slot
  char path[256];
  bool held[KEY_MAX + 1]; // keys this physical device currently holds down
};

static struct kbd kbds[MAX_KBD];
static int epfd = -1;
static int inotify_fd = -1;
static bool retry_needed = false;
static volatile sig_atomic_t running = 1;

static const char **explicit_paths = NULL;
static int n_explicit = 0;

static bool held_elsewhere(int code, const struct kbd *self) {
  for (int i = 0; i < MAX_KBD; i++)
    if (&kbds[i] != self && kbds[i].fd >= 0 && kbds[i].held[code])
      return true;
  return false;
}

// Release everything this device was holding (disconnect / SYN_DROPPED).
static void drop_device_keys(struct kbd *d) {
  for (int c = 1; c <= KEY_MAX; c++) {
    if (!d->held[c])
      continue;
    d->held[c] = false;
    if (!held_elsewhere(c, d))
      handle_key(c, 0);
  }
}

static void disconnect_device(struct kbd *d) {
  printf("Keyboard released: %s\n", d->path);
  drop_device_keys(d);
  epoll_ctl(epfd, EPOLL_CTL_DEL, d->fd, NULL);
  ioctl(d->fd, EVIOCGRAB, 0);
  close(d->fd);
  d->fd = -1;
  d->path[0] = '\0';
}

static void process_event(struct kbd *d, const struct input_event *ev) {
  if (ev->type == EV_SYN && ev->code == SYN_DROPPED) {
    drop_device_keys(d);
    return;
  }
  if (ev->type != EV_KEY || ev->code > KEY_MAX)
    return;

  int code = ev->code;
  int value = ev->value;

  if (value == 1) {
    d->held[code] = true;
  } else if (value == 0) {
    d->held[code] = false;
    // Another keyboard still holds this key: not a real release yet.
    if (held_elsewhere(code, d))
      return;
  }
  handle_key(code, value);
}

static void service_device(struct kbd *d) {
  struct input_event buf[64];
  ssize_t n = read(d->fd, buf, sizeof(buf));
  if (n < 0) {
    if (errno == EAGAIN || errno == EINTR)
      return;
    fprintf(stderr, "Read error on %s: %s\n", d->path, strerror(errno));
    disconnect_device(d);
    return;
  }
  if (n == 0) {
    disconnect_device(d);
    return;
  }
  size_t count = (size_t)n / sizeof(struct input_event);
  for (size_t i = 0; i < count; i++) {
    process_event(d, &buf[i]);
    if (d->fd < 0)
      return;
  }
}

/* ------------------------------------------------------------------------ */
/* Device discovery                                                          */
/* ------------------------------------------------------------------------ */

static bool is_target_keyboard(int fd) {
  unsigned long ev_bits[NBITS(EV_MAX)] = {0};
  unsigned long key_bits[NBITS(KEY_MAX)] = {0};

  if (ioctl(fd, EVIOCGBIT(0, sizeof(ev_bits)), ev_bits) < 0 ||
      ioctl(fd, EVIOCGBIT(EV_KEY, sizeof(key_bits)), key_bits) < 0)
    return false;

  if (!(test_bit(EV_KEY, ev_bits) && test_bit(KEY_A, key_bits) &&
        test_bit(KEY_ENTER, key_bits) && test_bit(KEY_SPACE, key_bits)))
    return false;

  char name[256] = "Unknown";
  ioctl(fd, EVIOCGNAME(sizeof(name)), name);
  return strstr(name, "keyMouse") == NULL; // never grab our own device
}

// Wait until Enter is released (e.g. the key used to launch us in a terminal).
static void drain_and_wait_key_release(int fd) {
  unsigned long key_states[NBITS(KEY_MAX)] = {0};

  if (ioctl(fd, EVIOCGKEY(sizeof(key_states)), key_states) >= 0) {
    while (test_bit(KEY_ENTER, key_states) ||
           test_bit(KEY_KPENTER, key_states)) {
      usleep(20000);
      if (ioctl(fd, EVIOCGKEY(sizeof(key_states)), key_states) < 0)
        break;
    }
  }
  usleep(50000);
}

static bool already_open(const char *path) {
  for (int i = 0; i < MAX_KBD; i++)
    if (kbds[i].fd >= 0 && strcmp(kbds[i].path, path) == 0)
      return true;
  return false;
}

static struct kbd *free_slot(void) {
  for (int i = 0; i < MAX_KBD; i++)
    if (kbds[i].fd < 0)
      return &kbds[i];
  return NULL;
}

static void try_add_device(const char *path, bool initial, bool forced) {
  if (already_open(path))
    return;

  struct kbd *d = free_slot();
  if (!d) {
    fprintf(stderr, "Too many keyboards (max %d)\n", MAX_KBD);
    return;
  }

  int fd = open(path, O_RDONLY | O_NONBLOCK | O_CLOEXEC);
  if (fd < 0) {
    if (forced)
      retry_needed = true; // maybe not there yet / udev perms pending
    return;
  }

  if (!forced && !is_target_keyboard(fd)) {
    close(fd);
    return;
  }

  // Only block on key release at startup; never stall running keyboards.
  if (initial)
    drain_and_wait_key_release(fd);

  if (ioctl(fd, EVIOCGRAB, 1) < 0) {
    fprintf(stderr, "Failed to grab %s: %s. Will retry...\n", path,
            strerror(errno));
    close(fd);
    retry_needed = true;
    return;
  }

  struct epoll_event e = {.events = EPOLLIN, .data.ptr = d};
  if (epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &e) < 0) {
    fprintf(stderr, "epoll_ctl failed for %s: %s\n", path, strerror(errno));
    ioctl(fd, EVIOCGRAB, 0);
    close(fd);
    return;
  }

  char name[256] = "Unknown";
  ioctl(fd, EVIOCGNAME(sizeof(name)), name);

  memset(d->held, 0, sizeof(d->held));
  snprintf(d->path, sizeof(d->path), "%s", path);
  d->fd = fd;
  printf("Keyboard grabbed: %s (%s)\n", name, path);
}

static void scan_devices(bool initial) {
  if (n_explicit > 0) {
    for (int i = 0; i < n_explicit; i++)
      try_add_device(explicit_paths[i], initial, true);
    return;
  }

  DIR *dir = opendir("/dev/input");
  if (!dir)
    return;

  struct dirent *ent;
  while ((ent = readdir(dir)) != NULL) {
    if (strncmp(ent->d_name, "event", 5) != 0)
      continue;
    char path[512];
    snprintf(path, sizeof(path), "/dev/input/%s", ent->d_name);
    try_add_device(path, initial, false);
  }
  closedir(dir);
}

/* ------------------------------------------------------------------------ */
/* main                                                                      */
/* ------------------------------------------------------------------------ */

static void on_signal(int sig) {
  (void)sig;
  running = 0;
}

static void print_usage(const char *prog) {
  printf("Usage: %s [/dev/input/eventN ...]\n"
         "  No arguments: grab every keyboard (hotplug supported).\n"
         "  With paths  : grab only those devices.\n",
         prog);
}

int main(int argc, char **argv) {
  if (argc >= 2 && strcmp(argv[1], "--help") == 0) {
    print_usage(argv[0]);
    return 0;
  }
  if (argc >= 2) {
    explicit_paths = (const char **)(argv + 1);
    n_explicit = argc - 1;
  }

  for (int i = 0; i < MAX_KBD; i++)
    kbds[i].fd = -1;

  struct sigaction sa;
  memset(&sa, 0, sizeof(sa));
  sa.sa_handler = on_signal;
  sigaction(SIGINT, &sa, NULL);
  sigaction(SIGTERM, &sa, NULL);

  ui_fd = setup_uinput_device();
  if (ui_fd < 0) {
    fprintf(stderr, "Failed to create uinput device: %s\n", strerror(errno));
    return 1;
  }

  epfd = epoll_create1(EPOLL_CLOEXEC);
  if (epfd < 0) {
    fprintf(stderr, "epoll_create1 failed: %s\n", strerror(errno));
    return 1;
  }

  inotify_fd = inotify_init1(IN_NONBLOCK | IN_CLOEXEC);
  if (inotify_fd >= 0) {
    if (inotify_add_watch(inotify_fd, "/dev/input", IN_CREATE | IN_ATTRIB) <
        0) {
      close(inotify_fd);
      inotify_fd = -1;
    } else {
      struct epoll_event e = {.events = EPOLLIN, .data.ptr = NULL};
      epoll_ctl(epfd, EPOLL_CTL_ADD, inotify_fd, &e);
    }
  }

  printf("\n--- Mode Ready ---\n");
  printf("• Hold LEFT ALT: Mouse mode\n");
  printf("  - H/J/K/L    : Move cursor\n");
  printf("  - U / D      : Scroll Up / Down\n");
  printf("  - Enter      : Left Click\n");
  printf("  - Backspace  : Right Click\n");
  printf("  - F          : Slow precision speed\n");
  printf("• RIGHT ALT: Regular Alt\n");
  printf("• Works across all connected keyboards.\n\n");

  scan_devices(true);

  while (running) {
    struct epoll_event evs[16];
    int timeout = (retry_needed || inotify_fd < 0) ? 1000 : -1;
    int n = epoll_wait(epfd, evs, 16, timeout);

    if (n < 0) {
      if (errno == EINTR)
        continue;
      fprintf(stderr, "epoll_wait failed: %s\n", strerror(errno));
      break;
    }

    if (n == 0) { // timeout: retry failed opens/grabs
      retry_needed = false;
      scan_devices(false);
      continue;
    }

    for (int i = 0; i < n; i++) {
      if (evs[i].data.ptr == NULL) { // /dev/input changed: rescan
        char junk[4096];
        while (read(inotify_fd, junk, sizeof(junk)) > 0)
          ;
        retry_needed = false;
        scan_devices(false);
      } else {
        struct kbd *d = evs[i].data.ptr;
        if (d->fd < 0)
          continue;
        if (evs[i].events & (EPOLLERR | EPOLLHUP)) {
          // Drain anything left; read() will report the real error/EOF.
        }
        service_device(d);
      }
    }
  }

  // Cleanup: closing the fds drops the grabs.
  for (int i = 0; i < MAX_KBD; i++)
    if (kbds[i].fd >= 0)
      disconnect_device(&kbds[i]);
  release_all();
  ioctl(ui_fd, UI_DEV_DESTROY);
  close(ui_fd);
  return 0;
}
