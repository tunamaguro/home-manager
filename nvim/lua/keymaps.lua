vim.keymap.set("i", "jk", "<Esc>", {
  desc = "Exit insert mode",
  silent = true,
})

vim.keymap.set("n", "<leader>w", "<cmd>update<cr>", {
  desc = "Save file",
})

vim.keymap.set("n", "<leader>q", "<cmd>quit<cr>", {
  desc = "Quit window",
})

vim.keymap.set("n", "<leader>Q", "<cmd>qall<cr>", {
  desc = "Quit Neovim",
})
