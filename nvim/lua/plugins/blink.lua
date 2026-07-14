local blink = require("blink.cmp")

blink.setup({
  keymap = {
    preset = "super-tab",
  },

  appearance = {
    nerd_font_variant = "mono",
  },

  completion = {
    menu = {
      auto_show = true,
      auto_show_delay_ms = 0,
      border = "rounded",
      draw = {
        columns = {
          { "kind_icon" },
          { "label", "label_description", gap = 1 },
          { "source_name" },
        },
      },
    },

    list = {
      selection = {
        preselect = true,
        auto_insert = false,
      },
    },

    documentation = {
      auto_show = true,
      auto_show_delay_ms = 300,
      update_delay_ms = 50,
      treesitter_highlighting = true,
      window = {
        border = "rounded",
        max_width = 80,
        max_height = 20,
      },
    },

    ghost_text = {
      enabled = true,
      show_with_selection = true,
      show_without_selection = false,
      show_with_menu = true,
    },
  },

  signature = {
    enabled = true,
    window = {
      border = "rounded",
      show_documentation = true,
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
