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

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  system.stateVersion = "25.05";
}

