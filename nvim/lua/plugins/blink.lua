local blink = require("blink.cmp")

blink.setup({
  keymap = {
    preset = "super-tab",

  },

  appearance = {
    nerd_font_variant = "mono",
  },

  signature = {
    enabled = true,
  },

  completion = {
    list = {
      selection = {
        preselect = true,
        auto_insert = true,
      },
    },
  },

  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },

  fuzzy = {
    implementation = "prefer_rust_with_warning",
  },
})

vim.lsp.config("*", {
  capabilities = blink.get_lsp_capabilities(),
})
