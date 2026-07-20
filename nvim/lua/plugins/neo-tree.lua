require("neo-tree").setup({
  enable_git_status = true,
  enable_diagnostics = true,
  sort_case_insensitive = false,

  window = {
    position = "left",
    width = 30,
  },

  filesystem = {
    follow_current_file = {
      enabled = true,
      leave_dirs_open = false,
    },

    group_empty_dirs = true,
    use_libuv_file_watcher = true,

    filtered_items = {
      visible = false,
      hide_dotfiles = false,
      hide_gitignored = true,
      hide_hidden = true,
    },
  },
})

vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle filesystem left<CR>", {
  desc = "Toggle file explorer",
  silent = true,
})

vim.keymap.set("n", "<leader>E", "<cmd>Neotree reveal filesystem left<CR>", {
  desc = "Reveal current file in explorer",
  silent = true,
})
