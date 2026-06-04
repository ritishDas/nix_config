{pkgs,inputs}: with pkgs; [
  
  # gpu-screen-recorder
 scrcpy
  intel-gpu-tools
  hyprpicker
  upower
  slurp
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
  # inputs.llama-cpp.packages.${system}.vulkan
]
