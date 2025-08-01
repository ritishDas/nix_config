{
  description = "My Nix Config Flake.nix file";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/hyprland?ref=v0.36.0";
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
                                webscrapper = { url = "path:/home/ritish/projects/webscrapper";  };
  };

  outputs = { nvf, self, nixpkgs, home-manager, webscrapper,... } @inputs:
  {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {inherit inputs;};
          modules = [
              nvf.nixosModules.default
              ./configuration.nix
                  home-manager.nixosModules.home-manager
                  {
                      home-manager.useGlobalPkgs = true;
                      home-manager.useUserPackages = true;
                      users.users.ritish = {
                          isNormalUser = true;
                          extraGroups = [ "wheel" "networkmanager" "kvm" "libvirt" "docker" "input"];            
                      };
                      home-manager.users.ritish = import ./home.nix;
                  }
          ];
      };
  };

}

