require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "-" },
    changedelete = { text = "~" },
    untracked = { text = "?" },
  },

  signs_staged_enable = true,
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  current_line_blame = false,

  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, {
        buffer = bufnr,
        silent = true,
        desc = desc,
      })
    end

    map("n", "]h", function()
      gitsigns.nav_hunk("next")
    end, "Next git hunk")

    map("n", "[h", function()
      gitsigns.nav_hunk("prev")
    end, "Previous git hunk")

    map("n", "<leader>gp", gitsigns.preview_hunk, "Preview git hunk")

    map("n", "<leader>gi", gitsigns.preview_hunk_inline, "Preview git hunk inline")

    map("n", "<leader>gb", function()
      gitsigns.blame_line({ full = true })
    end, "Git blame line")

    map("n", "<leader>gB", gitsigns.toggle_current_line_blame, "Toggle git blame line")

    map("n", "<leader>gd", gitsigns.diffthis, "Git diff current file")

    map("n", "<leader>gq", function()
      gitsigns.setqflist("all")
    end, "Send git hunks to quickfix")
  end,
})
