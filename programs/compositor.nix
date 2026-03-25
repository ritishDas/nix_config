{pkgs,inputs}: with pkgs; [
 scrcpy
  # blender
  upower
  slurp
  hyprpolkitagent
  papirus-icon-theme
  xdg-utils
  xdg-terminal-exec
  nwg-look
  wf-recorder
  waybar
  killall
  gammastep
  dunst
  tofi
  wl-clipboard
  swww
  hyprlock
  wlogout
  grimblast
  hypridle
  pamixer
  pwvucontrol
  playerctl
  brightnessctl
  tuigreet
  #hyprpicker
  #  google-chrome
   # obs-studio
  # appflowy
  #ppsspp
]++[
  inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
  inputs.astm.packages.${system}.default
  # inputs.llama-cpp.packages.${system}.vulkan
]
