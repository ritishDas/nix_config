return {
  {
    "yetone/avante.nvim",
    build = vim.fn.has("win32") ~= 0
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
    event = "InsertEnter", -- load only when editing
    version = false,
    opts = {
      provider = "openai",
      auto_suggestions_provider = "openai",
      providers = {
        openai = {
          endpoint = "http://127.0.0.1:8080/",
          model = "local-llama",
          disable_tools = true,
          extra_request_body = {
            temperature = 0.2,
            max_tokens = 64,
          },
        },
      },
      behaviour = {
        auto_suggestions = true,
        auto_set_keymaps = true,
        minimize_diff = true,
        enable_token_counting = false,
        auto_add_current_file = false,
        auto_approve_tool_permissions = true,
        acp_follow_agent_locations = false,
      },
      suggestion = {
        debounce = 300,
        throttle = 300,
      },
      prompt_logger = { enabled = false },
      dual_boost = { enabled = false },
      selection = { enabled = false },
      diff = { autojump = false, list_opener = "copen", override_timeoutlen = -1 },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {},
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
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
  -- nvim-cmp
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
      luasnip.filetype_extend("typescriptreact", { "html", "javascriptreact" })

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
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
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
    "norcalli/nvim-colorizer.lua",
    config = function()
      require 'colorizer'.setup()
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "c", "html", "css", "javascript", "typescript" },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
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
        prismals = {},
        tailwindcss = {},
        cssls = {},
      }
      local on_attach = function(client, bufnr)
        local bufmap = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Hover documentation
        bufmap("n", "K", vim.lsp.buf.hover, "Show hover info")

        -- Go to definition
        bufmap("n", "gd", vim.lsp.buf.definition, "Go to definition")

        -- Format buffer (LSP)
        bufmap("n", "<C-f>", function()
          vim.lsp.buf.format { async = true }
        end, "Format buffer")

        -- Optional: Rename symbol
        bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
      end
      local default_opts = { capabilities = capabilities, on_attach = on_attach, }
      for name, opts in pairs(servers) do
        vim.lsp.config(name, vim.tbl_deep_extend("force", default_opts, opts))
        vim.lsp.enable(name)
      end
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
        }
      })
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "auto", section_separators = "", component_separators = "" },
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

