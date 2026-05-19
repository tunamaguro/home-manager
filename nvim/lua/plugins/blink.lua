local blink = require("blink.cmp")

blink.setup({
  keymap = {
    preset = "default",
    ["<Tab>"] = {
      function(cmp)
        if cmp.is_menu_visible() then
          return cmp.select_next({ auto_insert = false })
        end

        if cmp.is_ghost_text_visible() then
          return cmp.accept()
        end

        return false
      end,
      "snippet_forward",
      "fallback",
    },
    ["<S-Tab>"] = {
      function(cmp)
        if cmp.is_menu_visible() then
          return cmp.select_prev({ auto_insert = false })
        end

        return false
      end,
      "snippet_backward",
      "fallback",
    },
    ["<Space>"] = {
      function(cmp)
        if cmp.is_menu_visible() and cmp.get_selected_item_idx() ~= nil then
          return cmp.accept()
        end

        return false
      end,
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
    ghost_text = {
      enabled = true,
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
