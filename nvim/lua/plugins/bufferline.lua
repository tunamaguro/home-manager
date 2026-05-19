require("bufferline").setup({
  options = {
    mode = "buffers",
    numbers = "ordinal",

    diagnostics = "nvim_lsp",

    separator_style = "thin",

    show_buffer_close_icons = false,
    show_close_icon = false,

    offsets = {
      {
        filetype = "NvimTree",
        text = "Explorer",
        text_align = "left",
        separator = true,
      },
    },
  },
})

vim.keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<CR>", {
  desc = "Previous buffer",
  silent = true,
})

vim.keymap.set("n", "]b", "<cmd>BufferLineCycleNext<CR>", {
  desc = "Next buffer",
  silent = true,
})
