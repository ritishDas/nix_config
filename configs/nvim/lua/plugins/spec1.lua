return {

  -- {
  --   "github/copilot.vim"
  -- },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require("tokyonight").setup({
        style = "moon",

        on_highlights = function(hl, c)
          hl.LineNr = {
            fg = "#7affff"
          }

          hl.LineNrAbove = { fg = "#7aa2f7" }
          hl.LineNrBelow = { fg = "#7aa2f7" }
        end,
      })
    end
  },
  {
    'rmagatti/auto-session',
    lazy = false,
    opts = {
      auto_restore_enabled = true,
      auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
    },

    config = function()
      require("auto-session").setup({
        suppressed_dirs = { "~/", "~/Downloads", "/" },
        bypass_save_filetypes = { "neo-tree" },
      })
    end
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.filetype_extend("typescriptreact", { "html", "javascriptreact", "ejs" })

      cmp.setup({
        formatting = {
          format = require("tailwindcss-colorizer-cmp").formatter
        },

        --experimental = { ghost_text = true },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          -- ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()
      local servers = {
        lua_ls = {},
        ts_ls = {},
        ccls = {},
        yamlls = {},
        pyright = {},
        dartls = {},
        nixd = {},
        kotlin_language_server = {},
        prismals = {},
        tailwindcss = {
          settings = {
            tailwindCSS = {
              includeLanguages = {
                ejs = "html",
              },
            },
          },
        }

      }
      local default_opts = { capabilities = capabilities }
      for name, opts in pairs(servers) do
        vim.lsp.config(name, vim.tbl_deep_extend("force", default_opts, opts))
        vim.lsp.enable(name)
      end
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
    },
  },
  {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for better UI
    },
    config = function()
      require("flutter-tools").setup({
        -- hot_reload_on_save is true by default
        flutter_path = "/nix/store/62x0dy2s34a92gs1n76lvl43fg9cp5zf-flutter-wrapped-3.38.5-sdk-links/bin/flutter",
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup {
        options = {
          numbers = "ordinal", -- 1 2 3 4 …
        },
      }
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  },
  {
    "uga-rosa/ccc.nvim",
    cmd = "CccPick", -- Loads the plugin when the command is called
    config = function()
      local ccc = require("ccc")
      local mapping = ccc.mapping

      ccc.setup({
        highlighter = {
          auto_enable = true,
          lsp = true,
        },
      })
    end,
  },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    -- optionally, override the default options:
    config = function()
      require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2,
      })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "c", "python", "html", "css", "javascript", "typescript", "tsx", "dart", "kotlin", "lua", "nix", "java" },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      vim.api.nvim_create_autocmd("BufReadPost", {
        callback = function()
          vim.opt_local.foldmethod = "expr"
          vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end,
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    config = function()
      require("neo-tree").setup({
        filesystem = {
          follow_current_file = { enabled = true, leave_dirs_open = true },
          use_libuv_file_watcher = true,
        },
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function()
              vim.opt_local.number = true
              vim.opt_local.relativenumber = true
            end,
          },
        }
      })
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "tokyonight", section_separators = "", component_separators = "" },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = {
            {
              function()
                local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
                if next(buf_clients) == nil then return "No LSP" end
                local names = {}
                for _, client in pairs(buf_clients) do table.insert(names, client.name) end
                return " " .. table.concat(names, ",")
              end,
              color = { gui = "bold" },
            },
            "filename",
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<C-t>]],
        direction = "float",
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        persist_size = true,
        close_on_exit = true,
      })
    end,
  },


}
-- {
--   "mfussenegger/nvim-dap",
--   dependencies = {
--     "rcarriga/nvim-dap-ui",
--     "theHamsta/nvim-dap-virtual-text",
--     "nvim-neotest/nvim-nio"
--   },
--   config = function()
--     local dap = require("dap")
--     local dapui = require("dapui")
--
--     dap.adapters.cppdbg = {
--       type = 'executable',
--       command = '/run/current-system/sw/bin/gdb',
--       name = "gdb"
--     }
--
--     dap.configurations.cpp = {
--       {
--         name = "Launch file",
--         type = "cppdbg",
--         request = "launch",
--         program = function()
--           return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--         end,
--         cwd = '${workspaceFolder}',
--         stopOnEntry = false,
--         args = {}, -- command-line args
--       },
--     }
--
--     -- For C files too
--     dap.configurations.c = dap.configurations.cpp
--
--     -- Setup UI and virtual text
--     dapui.setup()
--     require("nvim-dap-virtual-text").setup()
--
--     -- Auto-open & auto-close dap-ui
--     dap.listeners.before.attach.dapui_config = function()
--       dapui.open()
--     end
--     dap.listeners.before.launch.dapui_config = function()
--       dapui.open()
--     end
--     dap.listeners.before.event_terminated.dapui_config = function()
--       dapui.close()
--     end
--     dap.listeners.before.event_exited.dapui_config = function()
--       dapui.close()
--     end
--   end,
-- },
-- nvim-cmp

-- {
--   "NvChad/nvim-colorizer.lua",
--   config = function()
--     require("colorizer").setup({
--       filetypes = { "css", "scss", "html", "javascript", "typescript", "lua", "vim" },
--       user_default_options = {
--         names = true,
--         rgb_fn = true,
--         hsl_fn = true,
--         tailwind = true,
--         css = true,
--         css_fn = true,
--       }
--     })
--   end
-- },
--
-- {
--   "kawre/leetcode.nvim",
--   build = ":TSUpdate html",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     "MunifTanjim/nui.nvim",
--   },
--   opts = {},
-- },
-- {
--   "ggml-org/llama.vim"
-- },
-- {
--   "CopilotC-Nvim/CopilotChat.nvim",
--   dependencies = {
--     { "nvim-lua/plenary.nvim", branch = "master" },
--   },
--   build = "make tiktoken",
--   opts = {
--     -- See Configuration section for options
--   },
--
--   keys = {
--     { "<leader>zc", "<cmd>CopilotChat<CR>",       mode = 'n', desc = "Open Copilot Chat" },
--     { "<leader>zr", "<cmd>CopilotChatReview<CR>", mode = 'v', desc = "Open Copilot Review" },
--     { "<leader>zf", "<cmd>CopilotChatFix<CR>",    mode = 'v', desc = "Open Copilot Fix" },
--   },
--   config = function()
--     require("CopilotChat").setup({
--       context = "buffers",
--     })
--   end
-- },
--
-- {
--   "stevearc/conform.nvim",
--   opts = {},
--   config = function()
--     require("conform").setup({
--       formatters_by_ft = {
--         javascript = { "prettier", "lsp_fallback" },
--         typescript = { "prettier", "lsp_fallback" },
--         javascriptreact = { "prettier", "lsp_fallback" },
--         typescriptreact = { "prettier", "lsp_fallback" },
--         css = { "prettier", "lsp_fallback" },
--         html = { "prettier", "lsp_fallback" },
--       },
--     })
--   end
-- },
