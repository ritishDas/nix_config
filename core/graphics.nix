{ pkgs, ... }:

{
  graphics = {
    enable = true;

    extraPackages = with pkgs; [
      mesa
      intel-media-driver
      libva
    ];
  };
}

