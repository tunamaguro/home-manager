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

    map("n", "<leader>gS", gitsigns.stage_hunk, "Stage git hunk")

    map("v", "<leader>gS", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "Stage selected git hunk lines")

    map("n", "<leader>gR", gitsigns.reset_hunk, "Reset git hunk")

    map("v", "<leader>gR", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "Reset selected git hunk lines")

    map("n", "<leader>gu", gitsigns.undo_stage_hunk, "Undo stage git hunk")

    map("n", "<leader>gA", gitsigns.stage_buffer, "Stage git buffer")

    map("n", "<leader>gX", gitsigns.reset_buffer, "Reset git buffer")

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
