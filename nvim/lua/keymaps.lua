vim.keymap.set("i", "jk", "<Esc>", {
  desc = "Exit insert mode",
  silent = true,
})

vim.keymap.set("i", "<Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-n>"
  end
  return "<Tab>"
end, {
  expr = true,
  desc = "Select next completion item",
})

vim.keymap.set("i", "<S-Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-p>"
  end
  return "<S-Tab>"
end, {
  expr = true,
  desc = "Select previous completion item",
})

vim.keymap.set("i", "<CR>", function()
  local completion = vim.fn.complete_info({ "selected" })
  if vim.fn.pumvisible() == 1 and completion.selected >= 0 then
    return "<C-y>"
  end
  return "<CR>"
end, {
  expr = true,
  desc = "Accept completion item",
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
