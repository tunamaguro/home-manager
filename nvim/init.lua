vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("options")
require("keymaps")

require("plugins.blink")
require("plugins.nvim-tree")
require("plugins.telescope")

require("lsp")
require("highlight")