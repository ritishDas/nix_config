{ pkgs }:

import ./compositor.nix { inherit pkgs; } ++
import ./development1.nix { inherit pkgs; } ++
import ./development2.nix { inherit pkgs; } ++
import ./general.nix { inherit pkgs; } ++
import ./network.nix { inherit pkgs; } ++
import ./virtual.nix { inherit pkgs; }

