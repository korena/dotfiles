vim.g.maplocalleader = " "
vim.g.mapleader = ","
require('plugins') -- first, so things after can use the plugins
require('statusline')
require('lsp')
require('configs')
require('autocmds')
require('usrcmds')
require('keymaps')
