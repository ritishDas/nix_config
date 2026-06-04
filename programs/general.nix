{ pkgs }:

let
  yaak = pkgs.callPackage ./yaak.package.nix {};
in
  with pkgs; [
    swayimg
    # sublime
    zip
    jre
    webcamoid
    wget
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
   ]  ++ [ 
  yaak
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
