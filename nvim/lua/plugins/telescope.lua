local telescope = require("telescope")
local builtin = require("telescope.builtin")

local rg_hidden_no_git = function()
  return {
    "--hidden",
    "--glob",
    "!**/.git/**",
  }
end

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
      find_command = {
        "fd",
        "--type",
        "f",
        "--hidden",
        "--exclude",
        ".git",
        "--color",
        "never",
      },
    },

    live_grep = {
      additional_args = rg_hidden_no_git,
    },

    grep_string = {
      additional_args = rg_hidden_no_git,
    },
  },
})

pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "file_browser")

vim.keymap.set("n", "<leader>ff", builtin.find_files, {
  desc = "Find files",
})

vim.keymap.set("n", "<leader>fg", builtin.live_grep, {
  desc = "Live grep",
})

vim.keymap.set("n", "<leader>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", {
  desc = "Open file brouwser",
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
