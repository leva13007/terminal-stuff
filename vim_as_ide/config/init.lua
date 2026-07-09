-- ~/.config/nvim/init.lua
-- Minimal starter config for JS/TS coding. No plugins yet besides the
-- manager itself — this is the base to build on in later videos.

vim.g.mapleader = " "

local opt = vim.opt

-- indentation: 2 spaces, JS/TS convention
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

-- editing
opt.number = true
opt.relativenumber = true
opt.wrap = false
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.undofile = true

-- search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- ui / behavior
opt.termguicolors = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.splitright = true
opt.splitbelow = true
opt.updatetime = 250

-- ---------------------------------------------------------------------
-- lazy.nvim bootstrap (plugin manager)
-- ---------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- plugins go here in future videos
})
