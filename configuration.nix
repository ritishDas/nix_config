{ config, pkgs, lib, ... }:

{
  imports = [ ./hardware-configuration.nix ];
  boot.loader = import ./core/bootloader.nix {};
  networking = import ./core/networking.nix {};
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";
  nixpkgs.config.allowUnfree = true;
  security.sudo.enable = true;

  environment = import ./core/env.nix {inherit pkgs;};
  services = import ./services {inherit pkgs;inherit lib;};
  hardware = import ./core/graphics.nix {inherit pkgs;};
  virtualisation= import ./core/virtualenv.nix {inherit pkgs;};

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  xdg = {
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
  };





  system.stateVersion = "25.05";
}

