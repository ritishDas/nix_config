return {

  {
    'rmagatti/auto-session',
    lazy = false,
    opts = {
      auto_restore = true,
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
    "windwp/nvim-ts-autotag",
    config = function()
      require('nvim-ts-autotag').setup({
        opts = {
          enable_close = true,           -- Auto close tags
          enable_rename = true,          -- Auto rename pairs directly!
          enable_close_on_slash = false, -- Auto close on trailing </
        },
      })
    end
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "windwp/nvim-autopairs",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      local kotlin_snippets = require("snippets.kotlin")
      luasnip.add_snippets("kotlin", kotlin_snippets)

      luasnip.filetype_extend("typescriptreact", { "html_tags", "html", "javascriptreact", "ejs" })

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
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
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


      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/nvim-cmp" },

    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Custom Kotlin LSP configuration
      vim.lsp.config("kotlin_lsp", {
        cmd = { "kotlin-lsp", "--stdio" },

        filetypes = { "kotlin", "java" },

        root_dir = function(bufnr, on_dir)
          local root = vim.fs.root(bufnr, {
            "settings.gradle",
            "settings.gradle.kts",
            "build.gradle",
            "build.gradle.kts",
            ".git",
          })

          if root then
            on_dir(root)
          end
        end,

        single_file_support = true,

        init_options = {
          automaticWorkspaceInit = true,
        },

        capabilities = capabilities,
      })

      local servers = {
        lua_ls = {},
        ts_ls = {},
        clangd = {},
        yamlls = {},
        nixd = {},
        bashls = {},
        dartls = {},
        prismals = {},

        -- Official JetBrains Kotlin LSP
        kotlin_lsp = {},

        tailwindcss = {
          settings = {
            tailwindCSS = {
              includeLanguages = {
                ejs = "html",
              },
            },
          },
        },
      }

      for name, opts in pairs(servers) do
        vim.lsp.config(name, opts)
        vim.lsp.enable(name)
      end
    end,
  }, {
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
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function harpoon_component()
        local ok, harpoon = pcall(require, "harpoon")
        if not ok then return "" end

        local entries = harpoon:list()
        local total = entries:length()

        if total == 0 then
          return ""
        end

        local current_file = vim.api.nvim_buf_get_name(0)
        local cwd = vim.uv.cwd() or ""

        local relative_path =
            current_file:gsub("^" .. vim.pesc(cwd) .. "/", "")

        local output = {}

        for idx = 1, total do
          local item = entries:get(idx)

          if item and item.value ~= "" then
            local filename = vim.fs.basename(item.value)

            local active =
                item.value == relative_path
                or item.value == current_file

            if active then
              table.insert(output, string.format("[%d:%s*]", idx, filename))
            else
              table.insert(output, string.format("%d:%s", idx, filename))
            end
          end
        end

        return "󰛢  " .. table.concat(output, "  ")
      end

      require("lualine").setup({
        options = {
          section_separators = "",
          component_separators = "",
        },

        -- Normal statusline
        sections = {
          lualine_a = { "mode" },

          lualine_b = {
            "branch",
            "diff",
            "diagnostics",
          },

          lualine_c = {
            {
              function()
                local clients = vim.lsp.get_clients({ bufnr = 0 })

                if next(clients) == nil then
                  return "No LSP"
                end

                local names = {}

                for _, client in pairs(clients) do
                  table.insert(names, client.name)
                end

                return " " .. table.concat(names, ",")
              end,

              color = {
                gui = "bold"
              },
            },

            "filename",
          },

          lualine_x = {
            "encoding",
            "fileformat",
            "filetype",
          },

          lualine_y = {
            "progress",
          },

          lualine_z = {
            "location",
          },
        },

        -- Separate bar above the window
        winbar = {
          lualine_a = {
            {
              harpoon_component,
              color = {
                fg = "#aaaaaa",
                bg = "#000000",
                gui = "bold",
              },
            },
          },
        },
      })
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")

      harpoon:setup({
        settings = {
          save_on_toggle = true,
          save_on_change = true,
        },
      })

      -- List management
      vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon add file" })
      vim.keymap.set("n", "<leader>hr", function() harpoon:list():remove() end, { desc = "Harpoon remove file" })
      vim.keymap.set("n", "<leader>hd", function() harpoon:list():clear() end, { desc = "Harpoon clear all" })
      vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
        { desc = "Harpoon menu" })

      -- Direct jumps (1–4)
      vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

      -- Instant slot overwrites (replace slot 1-4 without opening menu)
      vim.keymap.set("n", "<leader><C-1>", function() harpoon:list():replace_at(1) end, { desc = "Replace slot 1" })
      vim.keymap.set("n", "<leader><C-2>", function() harpoon:list():replace_at(2) end, { desc = "Replace slot 2" })
      vim.keymap.set("n", "<leader><C-3>", function() harpoon:list():replace_at(3) end, { desc = "Replace slot 3" })
      vim.keymap.set("n", "<leader><C-4>", function() harpoon:list():replace_at(4) end, { desc = "Replace slot 4" })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          numbers = "ordinal",
        },
      })
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
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup {
        install_dir = vim.fn.stdpath('data') .. '/site',
      }

      require('nvim-treesitter').install { 'java', "kotlin", 'html', 'javascript', 'typescript', 'tsx' }
    end
  }, {
  "roobert/tailwindcss-colorizer-cmp.nvim",
  -- optionally, override the default options:
  config = function()
    require("tailwindcss-colorizer-cmp").setup({
      color_square_width = 2,
    })
  end
},
  {
    "andymass/vim-matchup",
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    -- branch = "v3.x",
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
          -- Bind the 'd' key to our new trash command
          window = {
            mappings = {
              ["d"] = "trash",
            },
          },
          commands = {
            trash = function(state)
              local node = state.tree:get_node()
              if node.type == "message" then return end

              local inputs = require("neo-tree.ui.inputs")
              inputs.confirm("Trash " .. node.name .. "?", function(confirmed)
                if confirmed then
                  -- This uses the external 'trash' command
                  vim.fn.system({ "trash", node.path })
                  require("neo-tree.sources.manager").refresh(state.name)
                end
              end)
            end,
          },
        },
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function()
              vim.opt_local.number = true
              vim.opt_local.relativenumber = true
            end,
          },
        },
      })
    end
  },
  {
    "nvim-telescope/telescope.nvim",
    -- tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function()
      require("telescope").setup({})
      require("telescope").load_extension("fzf")
    end
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

        -- Callback executed when the terminal opens
        on_open = function(term)
          vim.opt_local.number = true         -- Enables absolute line numbers
          vim.opt_local.relativenumber = true -- Enables relative line numbers (optional)
        end,
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
--
-- {
--   "github/copilot.vim"
-- },
-- {
--   "folke/tokyonight.nvim",
--   lazy = false,
--   priority = 1000,
--   opts = {},
--   config = function()
--     require("tokyonight").setup({
--       style = "moon",
--
--       on_highlights = function(hl, c)
--         hl.LineNr = {
--           fg = "#7affff"
--         }
--
--         hl.LineNrAbove = { fg = "#7aa2f7" }
--         hl.LineNrBelow = { fg = "#7aa2f7" }
--       end,
--     })
--   end
-- },
