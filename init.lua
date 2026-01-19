-- EasyVim: init.lua
-- The entry point that bootstraps everything.

-- 1. Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Fix: Ensure we load modules from THIS directory, not ~/.config/nvim
-- This handles the case where the user is editing a copy in Documents
local config_path = vim.fn.fnamemodify(vim.fn.resolve(vim.fn.expand('<sfile>')), ':h')
vim.opt.rtp:prepend(config_path)

-- 2. Bootstrap lazy.nvim (Plugin Manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

-- 3. Load Core Modules
require("core.options")
require("core.keymaps")
require("core.terminal")

-- 4. Setup Lazy.nvim and load plugins
require("lazy").setup({
  { import = "plugins" },
}, {
  ui = {
    border = "rounded",
    title = "EasyVim Plugin Manager",
  },
  checker = { 
    enabled = true, 
    notify = false 
  },
  change_detection = {
    notify = false,
  },
})
