{pkgs,inputs}: with pkgs; [
  
  # gpu-screen-recorder
 scrcpy
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
  gammastep
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
  # blender
  # hyprpicker
  # google-chrome
  # obs-studio
  # appflowy
  # ppsspp
]++[
  inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
  inputs.astm.packages.${stdenv.hostPlatform.system}.default
  inputs.hyprspace.packages.${stdenv.hostPlatform.system}.default
  # inputs.hyprexpo-fork.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
  # inputs.llama-cpp.packages.${system}.vulkan
]

