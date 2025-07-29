{ config, pkgs, lib, inputs, ... }:

{
        imports = [ ./hardware-configuration.nix ];
        boot.loader = import ./core/bootloader.nix {};
        networking = import ./core/networking.nix {};
        nix.settings.experimental-features = [ "nix-command" "flakes" ];

        time.timeZone = "Asia/Kolkata";
        i18n.defaultLocale = "en_US.UTF-8";
        nixpkgs.config.allowUnfree = true;
        nixpkgs.config.android_sdk.accept_license = true;
        security.sudo.enable = true;

        environment = import ./core/env.nix {inherit pkgs;inherit inputs;};
        services = import ./services {inherit pkgs;inherit lib;};
        hardware = import ./core/graphics.nix {inherit pkgs;};
        virtualisation= import ./core/virtualenv.nix {inherit pkgs;};

        programs.hyprland = {
                enable = true;
                xwayland.enable = true;
                withUWSM = true;
        };



        programs.nvf = import ./configs/neovim {inherit pkgs;};

        xdg = import ./core/xdg.nix{inherit pkgs;};

        system.stateVersion = "25.05";
}

