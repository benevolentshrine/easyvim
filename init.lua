-- EasyVim: init.lua
-- The entry point that bootstraps everything.

-- Leader key setup
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Fix: Ensure we load modules from THIS directory, not ~/.config/nvim
-- This handles the case where the user is editing a copy in Documents
local config_path = vim.fn.fnamemodify(vim.fn.resolve(vim.fn.expand('<sfile>')), ':h')
vim.opt.rtp:prepend(config_path)

-- Lazy.nvim bootstrap
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

-- Load core modules
require("core.options")
require("core.keymaps")
require("core.terminal")

-- Setup plugins
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

-- FIXME: This rtp prepend might cause issues with other configs
-- TODO: Add fallback for when lazy.nvim fails to install
-- NOTE: Bootstrap process could be simplified maybe?
