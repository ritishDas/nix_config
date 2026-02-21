{ pkgs, lib, inputs, stdenv ,... }:

{
  imports = [ ./hardware-configuration.nix ];
  boot.loader = import ./core/bootloader.nix {};
  networking = import ./core/networking.nix {};
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";
  nixpkgs.config.allowUnfree = true;

  environment = import ./core/env.nix {inherit pkgs;inherit inputs;inherit lib;};
  services=import ./services {inherit pkgs;inherit lib;};
  hardware = import ./core/graphics.nix {inherit pkgs;};
  virtualisation= import ./core/virtualenv.nix {inherit pkgs;};

  security.sudo = {
	  enable = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  programs.chromium.enable = true;
  programs.nix-ld = {
    enable = true;
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;


  programs.neovim.enable = true;
  programs.dconf.enable = true;

  xdg = import ./core/xdg.nix{inherit pkgs;};
  system.stateVersion="26.05";
}

