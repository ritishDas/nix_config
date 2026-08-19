{pkgs,inputs}: with pkgs; [
  eww
  espeak-ng
  speechd
  # mongodb
  google-chrome
  blueman
  apacheKafka
  qalculate-gtk
  tree-sitter
  intel-gpu-tools
  hyprpicker
  upower
  hyprpolkitagent
  papirus-icon-theme
  xdg-utils
  xdg-terminal-exec
  nwg-look
  waybar
  killall
  dunst
  tofi
  wl-clipboard
  awww
  hyprlock
  wlogout
  grimblast
  hypridle
  pamixer
  pwvucontrol
  playerctl
  brightnessctl
  tuigreet
  pulseaudio-ctl
  wf-recorder
]++[
  inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
  inputs.astm.packages.${stdenv.hostPlatform.system}.default
  inputs.hyprspace.packages.${stdenv.hostPlatform.system}.default
  # inputs.hyprexpo-fork.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
  # inputs.llama-cpp.packages.${system}.vulkan
  # gpu-screen-recorder
  # blender
  # hyprpicker
  # google-chrome
  # obs-studio
  # appflowy
  # ppsspp
]

