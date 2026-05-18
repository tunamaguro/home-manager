local api = require("nvim-tree.api")

local git_filetypes = {
  git = true,
  gitcommit = true,
  gitrebase = true,
  gitconfig = true,
  diff = true,

  -- Future-proofing if fugitive or diffview is added later.
  fugitive = true,
  fugitiveblame = true,
  DiffviewFiles = true,
  DiffviewFileHistory = true,
}

local ignored_buftypes = {
  terminal = true,
  quickfix = true,
  prompt = true,
  nofile = true,
}

local function is_git_context()
  return git_filetypes[vim.bo.filetype] == true
end

local function should_open_tree()
  if vim.bo.filetype == "NvimTree" then
    return false
  end

  if is_git_context() then
    return false
  end

  if ignored_buftypes[vim.bo.buftype] then
    return false
  end

  return true
end

local function sync_tree_visibility()
  if is_git_context() then
    if api.tree.is_visible() then
      api.tree.close()
    end
    return
  end

  if should_open_tree() and not api.tree.is_visible() then
    api.tree.open({ focus = false })
  end
end

require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },

  view = {
    width = 30,
  },

  renderer = {
    group_empty = true,
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },

  filters = {
    dotfiles = false,
  },

  git = {
    enable = true,
  },

  diagnostics = {
    enable = true,
  },

  update_focused_file = {
    enable = true,
  },
})

vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter", "TabEnter" }, {
  group = vim.api.nvim_create_augroup("user-nvim-tree-auto-open", { clear = true }),
  callback = function()
    vim.schedule(sync_tree_visibility)
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("user-nvim-tree-quit", { clear = true }),
  callback = function()
    if vim.bo.filetype == "NvimTree" and #vim.api.nvim_list_wins() == 1 then
      vim.cmd("quit")
    end
  end,
})

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", {
  desc = "Focus file explorer",
  silent = true,
})

vim.keymap.set("n", "<leader>E", "<cmd>NvimTreeFindFile<CR>", {
  desc = "Reveal current file in explorer",
  silent = true,
})
