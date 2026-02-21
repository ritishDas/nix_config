{ pkgs }:

let
  yaak = pkgs.callPackage ./yaak.package.nix {};
in
with pkgs; [
  swayimg
  zip
  jre
  webcamoid
  wget
  htop
  neofetch
  unzip
  mpv
  mpvpaper
  ffmpegthumbnailer
  gdk-pixbuf
  postman
  emote
  libreoffice
  librsvg
  poppler
  xfce.thunar
  xfce.thunar-archive-plugin
  gsettings-desktop-schemas
  xfce.thunar-volman
] ++ [ yaak ]


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

