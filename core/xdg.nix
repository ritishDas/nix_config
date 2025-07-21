{pkgs}:{
      portal = {
          enable = true;
          extraPortals = [
              pkgs.xdg-desktop-portal-hyprland
                  pkgs.xdg-desktop-portal-gtk
          ];
      };
      terminal-exec = {
          enable=true;
          package= pkgs.alacritty;
          };
      mime = {
          enable = true;

          defaultApplications = {
              "application/pdf" = "chromium.desktop";
              "text/html" = "firefox.desktop";
              "application/vnd.oasis.opendocument.text" = "libreoffice.desktop"; # correct MIME type for .odt
                  "x-scheme-handler/http" = "firefox.desktop";
              "x-scheme-handler/https" = "firefox.desktop";
          };

          addedAssociations = {
              "application/pdf" = [ "zathura.desktop" "evince.desktop" ];
              "image/png" = [ "imv.desktop" "eog.desktop" ];
          };

          removedAssociations = {
              "audio/mp3" = [ "mpv.desktop" "vlc.desktop" ];
              "inode/directory" = [ "codium.desktop" ]; # must be a list
          };
      };
  }
