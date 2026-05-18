vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("options")
require("keymaps")

require("plugins.blink")
require('plugins.bufferline')
require("plugins.nvim-tree")
require("plugins.telescope")
require("plugins.gitsigns")

require("lsp")
require("highlight")
