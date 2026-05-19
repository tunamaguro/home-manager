local wk = require("which-key")

wk.setup({
  preset = "classic",
})

wk.add({
  {
    "<leader>?",
    function()
      wk.show({ keys = "<leader>", mode = "n" })
    end,
    desc = "Show leader keymaps",
  },
  {
    "<leader>b?",
    function()
      wk.show({ global = false })
    end,
    desc = "Show buffer-local keymaps",
  },
  { "<leader>b", group = "buffer" },
  { "<leader>f", group = "find" },
  { "<leader>g", group = "git" },
  { "<leader>l", group = "lsp" },
})
