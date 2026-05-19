require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },

  view = {
    width = 30,
  },

  renderer = {
    group_empty = true,
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },

  filters = {
    dotfiles = false,
  },

  git = {
    enable = true,
  },

  diagnostics = {
    enable = true,
  },

  update_focused_file = {
    enable = true,
  },
})

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", {
  desc = "Toggle file explorer",
  silent = true,
})

vim.keymap.set("n", "<leader>E", "<cmd>NvimTreeFindFile<CR>", {
  desc = "Reveal current file in explorer",
  silent = true,
})
