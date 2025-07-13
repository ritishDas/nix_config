local lazy={}

function lazy.download()

if not vim.loop.fs_stat(lazy.path) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazy.path
  })
end
vim.opt.rtp:prepend(lazy.path)
end



function lazy.setup(plugins)

if vim.g.plugins_ready then
return
end
-- You can "comment out" the line below after lazy.nvim is installed
require('lazy').setup(plugins, lazy.opts)
vim.g.plugins_ready = true
end

return lazy
