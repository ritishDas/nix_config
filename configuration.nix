{ config, pkgs, lib, inputs, ... }:

{
        imports = [ ./hardware-configuration.nix ];
        boot.loader = import ./core/bootloader.nix {};
        networking = import ./core/networking.nix {};
        nix.settings.experimental-features = [ "nix-command" "flakes" ];

        time.timeZone = "Asia/Kolkata";
        i18n.defaultLocale = "en_US.UTF-8";
        nixpkgs.config.allowUnfree = true;
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



        programs.nvf = {
                enable = true;
                settings = {
                        vim = {
                                theme = {
                                        enable = true;
                                        name = "dracula";
                                        style = "dark";
                                };
                                lsp.enable = true;
                                terminal.toggleterm.enable = true;
                                options.termguicolors = true;
                                globals.mapleader = " ";
                                clipboard.enable = true;
                                clipboard.providers.wl-copy.enable = true;
                                clipboard.registers = "unnamedplus";
                                clipboard.providers.wl-copy.package = pkgs.wl-clipboard;

                                keymaps = [
                                        {
                                                key = "<Esc>";
                                                mode = "t";
                                                silent = true;
                                                action = "<C-\\><C-n>";

                                        }
                                        {
                                                key = "<leader>s";
                                                mode = "n";
                                                silent = true;
                                                action = ":w<CR>";
                                        }
                                        {
                                                key = "<leader>e";
                                                mode = "n";
                                                silent = true;
                                                action = ":q<CR>";
                                        }
                                ];
                                statusline.lualine.enable = true;
                                telescope.enable = true;
                                autocomplete.blink-cmp.enable = true;
                                autocomplete.blink-cmp.friendly-snippets.enable = true;
                                filetree.nvimTree = {
                                        enable = true;
                                        mappings.toggle = "<leader>f";
                                        openOnSetup = false;
                                };
                                languages = {
                                        enableTreesitter = true;
                                        nix.enable = true;
                                        clang.enable = true;
                                        kotlin.enable = true;
                                        ts.enable = true;
                                };

                        };
                };
        };

        xdg = import ./core/xdg.nix{inherit pkgs;};

        system.stateVersion = "25.05";
}

