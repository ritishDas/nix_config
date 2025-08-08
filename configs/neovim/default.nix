{ pkgs }:{
  enable = true;
  settings = {
    vim = {
      highlight = {
        Normal.bg = "#054705";
        LineNr.fg = "#e6fc3f";
      };
      options = {
        termguicolors = true;
        tabstop = 2;
        shiftwidth = 2;
        softtabstop = 2;
        expandtab = true;
      };
      clipboard = {
        enable = true;
        providers.wl-copy = {
          enable = true;
          package = pkgs.wl-clipboard;
        };
        registers = "unnamedplus";
      };
      autocomplete.blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;
      };
      filetree.neo-tree = {
        enable = true;
      };
      languages = {
        enableTreesitter = true;
        enableExtraDiagnostics = true;
        nix.enable = true;
        clang.enable = true;
        kotlin.enable = true;
        ts.enable = true;
        tailwind.enable = true;
      };
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
          key = "p";
          mode = "x";
          silent = true;
          action = "\"_dP";
        }
        {
          key = "<leader>e";
          mode = "n";
          silent = true;
          action = ":q<CR>";
        }
        {
          key = "<leader>n";
          mode = "n";
          silent = true;
          action = ":bn<CR>";
        }
        {
          key = "<leader>p";
          mode = "n";
          silent = true;
          action = ":bp<CR>";
        }
        {
          key = "<leader>b";
          mode = "n";
          silent = true;
          action = ":buffers<CR>";
        }
      ];
      statusline.lualine.enable = true;
      telescope.enable = true;
      lsp.enable = true;
      diagnostics.config.virtual_lines = true;
      diagnostics.config.virtual_text = true;
      terminal.toggleterm.enable = true;
      globals.mapleader = " ";
    };
  };
}
