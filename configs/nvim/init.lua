-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Highlights
vim.api.nvim_set_hl(0, "Normal", { bg = "#1a3c1b" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#e6fc3f" })
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "checktime",
})
vim.o.autoread = true

-- Options
vim.opt.termguicolors = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.swapfile = false

vim.o.updatetime = 200

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", max_width = 80 },
})

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false, border = "rounded" })
  end,
})

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Keymaps helper
local function map(mode, lhs, rhs, opts)
  local options = { silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Keymaps
map("t", "<Esc>", "<C-\\><C-n>")
map("n", "<leader>h", "<C-^>")
map("n", "<leader>s", ":w<CR>")
map("n", "<leader>f", ":Neotree toggle<CR>")
map("n", "<leader>tf", ":Telescope fd<CR>")
map("n", "<leader>tg", ":Telescope live_grep<CR>")
map("n", "<leader>tr", ":Telescope resume<CR>")
map("x", "p", '"_dP')
map("n", "<leader>e", ":q<CR>")
map("n", "<leader>n", ":bn<CR>")
map("n", "<leader>p", ":bp<CR>")
map("n", "<leader>b", ":buffers<CR>")

require("config.lazy");

