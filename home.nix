{ config, pkgs, ... }:

{
  home.username = "ritish";
  home.homeDirectory = "/home/ritish";
  home.stateVersion = "25.05"; # Match your NixOS version

      home.sessionVariables = {
          EDITOR = "nvim";
          NIXPKGS_ALLOW_UNFREE = "1";
      };

home.file.".config/nvim".source = ./nvim;
home.file.".config/dunst".source = ./dunst;
home.file.".config/gammastep".source = ./gammastep;
home.file.".config/tofi".source = ./tofi;
home.file.".config/waybar".source = ./waybar;
home.file.".config/wlogout".source = ./wlogout;
home.file.".config/hypr".source = ./hypr;


#wayland.windowManager.hyprland = {
#    enable = true;
#    settings = {
#        
#        };
#    };
  # No programs, packages, or dotfiles for now
}

