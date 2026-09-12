vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable netrw before Neo-tree is loaded.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("options")
require("keymaps")

require('plugins.colorschema')
require("plugins.bufferline")
require("plugins.lualine")
require("plugins.bufremove")
require("plugins.neo-tree")
require("plugins.telescope")
require("plugins.gitsigns")
require("plugins.toggleterm")
require("plugins.which-key")
require("plugins.pairs")

require("lsp")
require("highlight")
