{ pkgs, ... }:

{

bluetooth.enable = true;
  graphics = {
    enable = true;

    extraPackages = with pkgs; [
      mesa
      intel-media-driver
      libva
    ];
  };
}

