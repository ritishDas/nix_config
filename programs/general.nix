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
   ]  ++ [ yaak ]


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
