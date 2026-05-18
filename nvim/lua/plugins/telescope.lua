local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
      },
    },
  },

  pickers = {
    find_files = {
      hidden = true,
    },
  },
})

pcall(telescope.load_extension, "fzf")

vim.keymap.set("n", "<leader>ff", builtin.find_files, {
  desc = "Find files",
})

vim.keymap.set("n", "<leader>fg", builtin.live_grep, {
  desc = "Live grep",
})

vim.keymap.set("n", "<leader>fb", builtin.buffers, {
  desc = "Find buffers",
})

vim.keymap.set("n", "<leader>fr", builtin.oldfiles, {
  desc = "Recent files",
})

vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, {
  desc = "Document symbols",
})

vim.keymap.set("n", "<leader>fS", builtin.lsp_dynamic_workspace_symbols, {
  desc = "Workspace symbols",
})

vim.keymap.set("n", "<leader>fq", builtin.quickfix, {
  desc = "Find quickfix items",
})

vim.keymap.set("n", "<leader>gs", builtin.git_status, {
  desc = "Git changed files",
})
