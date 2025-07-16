{
  description = "My Nix Config Flake.nix file";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, ... }:
  {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
              ./configuration.nix
                  home-manager.nixosModules.home-manager
                  {
                      home-manager.useGlobalPkgs = true;
                      home-manager.useUserPackages = true;
                      users.users.ritish = {
                          isNormalUser = true;
                          extraGroups = [ "wheel" "networkmanager" "kvm" "libvirt" "docker" ];            
                      };
                      home-manager.users.ritish = import ./home.nix;
                  }
          ];
      };
  };

}

