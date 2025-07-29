{ pkgs }:{
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
                        options.tabstop = 4;
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
                                        key = "<leader>f";
                                        mode = "n";
                                        silent = true;
                                        action = ":Neotree toggle<CR>";
                                }
                                {
                                        key = "<leader>tf";
                                        mode = "n";
                                        silent = true;
                                        action = ":Telescope fd<CR>";
                                }
                                {
                                        key = "<leader>tg";
                                        mode = "n";
                                        silent = true;
                                        action = ":Telescope live_grep<CR>";
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
                        filetree.neo-tree = {
                                enable = true;
                        };
                        languages = {
                                enableTreesitter = true;
                                nix.enable = true;
                                clang.enable = true;
                                kotlin={
                                        enable = true;
                                        lsp.enable = true;
                                };
                                java.enable = true;
                                ts.enable = true;
                        };

                };
        };
}
