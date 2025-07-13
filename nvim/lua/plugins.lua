local plugins = {
	plugs = {
		{ 'nvim-tree/nvim-web-devicons' },
        { "prisma/vim-prisma", ft = "prisma" },
		{ 'nvim-tree/nvim-tree.lua' },
		{ 'andymass/vim-matchup' },
		{ 'akinsho/toggleterm.nvim', version = "*", config = true },

		-- LSP & Autocompletion
		{ 'neovim/nvim-lspconfig' },
		{ 'hrsh7th/nvim-cmp' },
		{ 'hrsh7th/cmp-nvim-lsp' },
		{ "L3MON4D3/LuaSnip", dependencies = { "rafamadriz/friendly-snippets" } },
		{ 'saadparwaiz1/cmp_luasnip' },

		-- Markdown Support
		{ 'preservim/vim-markdown', ft = 'markdown' },
		{ 'godlygeek/tabular', ft = 'markdown' },
		{
			'iamcco/markdown-preview.nvim',
			ft = { 'markdown' },
			build = 'cd app && npm install',
			config = function()
				vim.g.mkdp_auto_start = 0
			end
		},
        --treesitter
		{
			'nvim-treesitter/nvim-treesitter',
			build = ':TSUpdate',
			config = function()
				require('nvim-treesitter.configs').setup {
					ensure_installed = { 'markdown', 'markdown_inline' },
					highlight = { enable = true },
				}
			end
		},
	},

start = function()

	-- Setup Plugins
	require("nvim-tree").setup({
		on_attach = function(bufnr)
			local api = require("nvim-tree.api")

			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			api.config.mappings.default_on_attach(bufnr)
			vim.keymap.set("n", "s", api.node.open.vertical, opts("Open: Vertical Split"))
		end
	})

	require("toggleterm").setup({
		direction = "horizontal",
		size = 15,
		open_mapping = [[<C-t>]],
	})

	require("luasnip.loaders.from_vscode").lazy_load()


	-- LSP keymaps
	local on_attach = function(_, bufnr)
		local opts = { noremap = true, silent = true, buffer = bufnr }
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
	end

	local lspconfig = require("lspconfig")
	lspconfig.ts_ls.setup({ on_attach = on_attach })
	lspconfig.ccls.setup({ on_attach = on_attach })
	lspconfig.tailwindcss.setup({ on_attach = on_attach })
    lspconfig.kotlin_language_server.setup({  on_attach = on_attach })
    lspconfig.nil_ls.setup({
        settings = {
            ['nil'] = {
                formatting = {
                    command = { "nixpkgs-fmt" }  -- or "alejandra" if you prefer
                }
            }
        }
})


	-- nvim-cmp setup
	local cmp = require("cmp")
	local luasnip = require("luasnip")

	cmp.setup({
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			['<Tab>'] = cmp.mapping.select_next_item(),
			['<S-Tab>'] = cmp.mapping.select_prev_item(),
			['<CR>'] = cmp.mapping.confirm({ select = true }),
			['<C-Space>'] = cmp.mapping.complete(),
		}),
		sources = {
			{ name = 'nvim_lsp' },
			{ name = 'luasnip' },
		}
	})

	-- Tree-sitter config extension
    require('nvim-treesitter.configs').setup {
        ensure_installed = {
            'c', 'kotlin', 'lua', 'typescript', 'javascript',
            'html', 'css', 'json', 'markdown', 'markdown_inline'
        },
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                node_decremental = "grm",
            },
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                    ["ap"] = "@parameter.outer",
                    ["ip"] = "@parameter.inner",
                },
            },
        },
    }
end

}

return plugins
