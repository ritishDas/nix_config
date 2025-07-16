{ config, pkgs, ... }:

{
  home.username = "ritish";
  home.homeDirectory = "/home/ritish";
  home.stateVersion = "25.05"; # Match your NixOS version

  # No programs, packages, or dotfiles for now
}

