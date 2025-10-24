{
  description = "My Nix Config Flake.nix file";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/hyprland?ref=v0.36.0";
    astm.url = "github:ritishDas/astm";
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };

  };


  outputs = { self, nixpkgs, home-manager, astm, ... } @ inputs:
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix

        home-manager.nixosModules.home-manager

        {
          # ✅ System users (best kept outside the home-manager block)
          users.users = {
            ritish = {
              isNormalUser = true;
              extraGroups = [ "wheel" "networkmanager" "kvm" "libvirt" "docker" "input" ];
            };
            dummy = {
              isNormalUser = true;
              extraGroups = [ "wheel" "networkmanager" "kvm" "libvirt" "docker" "input" ];
            };
          };

          # ✅ Home Manager settings
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            users = {
              ritish = import ./home.nix;
              dummy = import ./dummyhome.nix;
            };
          };
        }
      ];
    };
  };

}

