{ pkgs }:

  with pkgs; [
  wireguard-tools
    swayimg
    fastfetch
    zip
    jre
    webcamoid
    wget
    redis
    htop
    unzip
    mpv
    mpvpaper
    ffmpegthumbnailer
    gdk-pixbuf
    emote
    libreoffice
    librsvg
    poppler
    thunar
    thunar-archive-plugin
    gsettings-desktop-schemas
    thunar-volman
    yaak
   ]  ++ [ 
   (pkgs.writeShellScriptBin "stopwatch" ''
STATE="$HOME/.cache/stopwatch.state"

mkdir -p "$HOME/.cache"

init() {
    [ -f "$STATE" ] || echo "stopped 0 0" > "$STATE"
}

read_state() {
    read -r STATUS START ELAPSED < "$STATE"
}

save_state() {
    echo "$STATUS $START $ELAPSED" > "$STATE"
}

elapsed_now() {
    read_state

    if [ "$STATUS" = "running" ]; then
        echo $((ELAPSED + $(date +%s) - START))
    else
        echo "$ELAPSED"
    fi
}

case "$1" in
    toggle)
        init
        read_state

        if [ "$STATUS" = "running" ]; then
            ELAPSED=$(elapsed_now)
            STATUS="paused"
            START=0
        else
            STATUS="running"
            START=$(date +%s)
        fi

        save_state
        ;;

    reset)
        STATUS="stopped"
        START=0
        ELAPSED=0
        save_state
        ;;

    status)
        SEC=$(elapsed_now)

        H=$((SEC / 3600))
        M=$(((SEC % 3600) / 60))
        S=$((SEC % 60))

        printf "⏱ %02d:%02d:%02d\n" "$H" "$M" "$S"
        ;;

    *)
        echo "Usage: $0 {toggle|reset|status}"
        ;;
esac
    '')
 
(pkgs.writeShellScriptBin "timeElapsed" ''
  # Set your reference start date here (YYYY-MM-DD HH:MM:SS)
  START_DATE="2005-02-10 00:00:00"

  START_SEC=$(date -d "$START_DATE" +%s)
  NOW_SEC=$(date +%s)
  DIFF=$(( NOW_SEC - START_SEC ))

  if [ ''$DIFF -lt 0 ]; then
    echo "Date is in the future"
    exit 0
  fi

  # Time constants
  SEC_PER_HOUR=3600
  SEC_PER_DAY=86400
  SEC_PER_YEAR=31557600   # 365.25 days
  SEC_PER_MONTH=2592000   # 30 days

  # Calculate breakdown
  YEARS=$(( DIFF / SEC_PER_YEAR ))
  REMAINDER=$(( DIFF % SEC_PER_YEAR ))

  MONTHS=$(( REMAINDER / SEC_PER_MONTH ))
  REMAINDER=$(( REMAINDER % SEC_PER_MONTH ))

  DAYS=$(( REMAINDER / SEC_PER_DAY ))
  REMAINDER=$(( REMAINDER % SEC_PER_DAY ))

  HOURS=$(( REMAINDER / SEC_PER_HOUR ))

  echo "''${YEARS}y ''${MONTHS}m ''${DAYS}d ''${HOURS}h"
'')
]


    # postman
# requestly
# nautilus
# obs-studio
#kdePackages.qt6ct
#shotcut
# steam-run
# godot_4
# gnome.gvfs 
# libmtp
# jmtpfs
# pciutils
# openapi-generator-cli
