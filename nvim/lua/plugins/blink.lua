local blink = require("blink.cmp")

blink.setup({
  keymap = {
    preset = "default",

    ["<Tab>"] = {
      function(cmp)
        if cmp.snippet_active() then
          return cmp.accept()
        end

        return cmp.select_and_accept()
      end,
      "snippet_forward",
      "fallback",
    },

    ["<S-Tab>"] = {
      "snippet_backward",
      "fallback",
    },

    ["<CR>"] = {
      "accept",
      "fallback",
    },
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
        preselect = false,
        auto_insert = false,
      },
    },

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
