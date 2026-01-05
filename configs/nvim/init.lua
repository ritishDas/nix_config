-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.filetype.add({
  extension = {
    ejs = "html",
  },
})

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"
-- Highlights
vim.api.nvim_set_hl(0, "Normal", { bg = "#1a3c1b" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#e6fc3f" })

local aug = vim.api.nvim_create_augroup("user_config", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  group = aug,
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
vim.opt.mouse = ''

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

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "compile_commands.json", "Makefile" },
  callback = function()
    vim.cmd("LspRestart")
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
vim.keymap.set("n", "<leader>fr", "<cmd>FlutterRestart<CR>", { desc = "Flutter Hot Restart" })
map("t", "<Esc>", "<C-\\><C-n>")
map("n", "<leader>h", "<C-^>")
map("n", "<leader>vh", "<cmd>vsplit #<cr>")
map("n", "<leader>s", function()
  vim.lsp.buf.format()
  vim.cmd("wa")
end, { desc = "Format and save" })
map("n", "<leader>f", ":Neotree toggle<CR>")
map("n", "<leader>tf", ":Telescope find_files<CR>")
map("n", "<leader>tg", ":Telescope live_grep<CR>")
map("n", "<leader>tr", ":Telescope resume<CR>")
map("x", "p", '"_dP')
map("n", "<leader>x", ":q<CR>")
map("n", "<leader>e", ":bdelete<CR>")
for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function()
    require("bufferline").go_to(i, true)
  end)
end
map("n", "<leader>n", ":BufferLineCycleNext<CR>")
map("n", "<leader>p", ":BufferLineCyclePrev<CR>")
map("n", "<leader>b", ":buffers<CR>")
map("n", "<leader>c", ":CccPick<CR>")
map("v", "<leader>r", [[:s/<C-r><C-w>/<Left>]])
-- DAP core actions
--map("n", "<F5>", function() require("dap").continue() end, { desc = "DAP Continue" })
--map("n", "<F10>", function() require("dap").step_over() end, { desc = "DAP Step Over" })
--map("n", "<F11>", function() require("dap").step_into() end, { desc = "DAP Step Into" })
--map("n", "<F12>", function() require("dap").step_out() end, { desc = "DAP Step Out" })
--
---- Breakpoints
--map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
--map("n", "<leader>dB", function()
--  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
--end, { desc = "Conditional Breakpoint" })
--
---- DAP UI
--map("n", "<leader>du", function() require("dapui").toggle() end, { desc = "DAP UI Toggle" })
--map("n", "<leader>de", function() require("dapui").eval() end, { desc = "DAP Evaluate" })
--
---- REPL
--map("n", "<leader>dr", function() require("dap").repl.open() end, { desc = "DAP REPL" })
--
---- Run last debug session
--map("n", "<leader>dl", function() require("dap").run_last() end, { desc = "DAP Run Last" })


require("config.lazy");
