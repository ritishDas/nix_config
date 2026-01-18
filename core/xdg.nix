{pkgs}:{
      portal = {
          enable = true;
          extraPortals = [
              pkgs.xdg-desktop-portal-hyprland
                  pkgs.xdg-desktop-portal-gtk
                  pkgs.xdg-desktop-portal-wlr
          ];
      };
      terminal-exec = {
          enable=true;
          package= pkgs.alacritty;
          };
  }
