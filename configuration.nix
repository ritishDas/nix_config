{config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    devices = [ "nodev" ];
    efiSupport = true;
    useOSProber = true;
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "wpa_supplicant";
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 5000 6000 ];
    allowedUDPPorts = [ 6000 ];
  };
  




  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  security.sudo.enable = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    xfce.xfce4-panel
    xfce.xfce4-settings
    xfce.xfce4-terminal
    xfce.thunar
    xfce.xfce4-power-manager
    xfce.xfce4-netload-plugin
    xclip

    networkmanagerapplet
    networkmanager
    ngrok
    firefox
    live-server
    localsend
    chromium
    openssl

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav

    neofetch
    htop
    intel-gpu-tools
    redshift
    emote
    pcsx2
    steam-run
    spotify

    python314
    neovim
    git
    android-tools
    android-studio
    watchman
    #jdk17
    jdk24
    gradle_8
    gcc
    gnumake
    raylib

    typescript-language-server
    tailwindcss-language-server
    ccls
    nil
    kotlin-language-server

    vimPlugins.vim-prisma

    unzip
    libreoffice-qt6-fresh
    postman
    obs-studio
    godot_4

    postgresql
    nodejs_24
    docker_28
    prisma-engines

    qemu_kvm
    libpulseaudio  # For emulator audio
    zlib  # Required for emulator
    libGL  # For emulator graphics
    ] ++ (with pkgs.pkgsi686Linux; [
            libpulseaudio  # 32-bit audio support
            zlib  # 32-bit zlib for emulator
    ]);

  environment.variables = {
  PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
  PRISMA_QUERY_ENGINE_BINARY  = "${pkgs.prisma-engines}/bin/query-engine";
  PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
  PRISMA_INTROSPECTION_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/introspection-engine";
  PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";
  ANDROID_HOME = "/home/ritish/.androidStudio/sdk";
  JAVA_HOME="${pkgs.jdk24}/lib/openjdk";
  XDG_CONFIG_DIRS = "/etc/xdg";
  PATH = [ "$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools" ];
};

environment.shellAliases = {
    nvim = "nvim -u /etc/xdg/nvim/init.lua";
    rb = "cd /etc/nixos && sudo nixos-rebuild switch --flake .#nixos";
    ed = "sudo nvim -u /etc/xdg/nvim/init.lua /etc/nixos/configuration.nix";
  };

environment.etc."xdg/nvim".source = ./nvim;

  services.openssh.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;
  };

  services.libinput.enable = true;

  services.xserver = {
    enable = true;
    desktopManager.xfce.enable = true;
    displayManager.lightdm.enable = true;
    videoDrivers = [ "modesetting" ];
  };


hardware.graphics = {
  enable = true;
  extraPackages = with pkgs; [
    intel-media-driver
    vaapiVdpau
    libvdpau-va-gl
  ];
  extraPackages32 = with pkgs.pkgsi686Linux; [
    libvdpau-va-gl
  ];
};

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
  };

  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_28;
  };

virtualisation.libvirtd = {
    enable = true;
    qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;  # Allow non-root users to run QEMU
    };
};

  #
  system.stateVersion = "25.05";
}


