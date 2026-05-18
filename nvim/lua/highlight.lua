vim.api.nvim_create_autocmd("FileType", {
  pattern = { "rust", "toml", "nix", "lua", "vim", "vimdoc" },
  callback = function()
    vim.treesitter.start()
  end,
})