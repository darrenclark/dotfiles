vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- lazy.nvim initialization

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local lazy_config = {
  ui = {
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
}

-- Load plugins from ./plugins/*.lua files
require("lazy").setup("plugins", lazy_config)

require("config/autocmds")
require("config/commands")
require("config/options")
require("config/filetype")
require("config/keys")
require("config/indent")
require("config/lang-go")
require("config/lang-rust")
require("config/lang-cpp")
