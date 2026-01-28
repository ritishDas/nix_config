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
 
  # mime.defaultApplications = {
  #   "x-scheme-handler/http"  = "chromium-browser.desktop";
  #   "x-scheme-handler/https" = "chromium-browser.desktop";
  #   "text/html"              = "chromium-browser.desktop";
  # };
  }
