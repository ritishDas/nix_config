vim.opt.clipboard = "unnamedplus"
vim.opt.hlsearch = true
vim.opt.expandtab = true     
vim.opt.tabstop = 4         
vim.opt.softtabstop = 4    
vim.opt.shiftwidth = 4    
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.mouse = ""
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.termguicolors = true

vim.g.mapleader = ' '

vim.cmd("colorscheme evening")
vim.cmd [[
  highlight LineNr guifg=#FFD700 guibg=NONE
  highlight CursorLineNr guifg=#00FFFF gui=bold
]]

vim.keymap.set('n', '<leader>f', ':NvimTreeToggle<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<leader>e', ':q<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<leader>s', ':w<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<leader>m', ':MarkdownPreview<CR>', { silent = true, noremap = true })

vim.keymap.set('t','<Esc>',[[<C-\><C-n>]],{ noremap = true,silent = true })

local lazy = require('./Lazy')
lazy.path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

lazy.download()

local plugins = require('plugins')

lazy.setup(plugins.plugs)

plugins.start()

