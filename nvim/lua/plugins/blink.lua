local blink = require("blink.cmp")

blink.setup({
  keymap = {
    preset = "enter",
  },

  appearance = {
    nerd_font_variant = "mono",
  },

  signature = {
    enabled = true,
  },

  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
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
