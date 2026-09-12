local Terminal = require("toggleterm.terminal").Terminal

require("toggleterm").setup({
  direction = "float",
  start_in_insert = true,
  persist_mode = true,
  close_on_exit = true
})

vim.keymap.set("t", "jk", [[<C-\><C-n>]], {
  desc = "Exit terminal mode",
  silent = true,
})

local function toggle_persistent_terminal(id)
  vim.cmd(("%dToggleTerm direction=float name=terminal-%d"):format(id, id))
end

for id = 1, 9 do
  vim.keymap.set({ "n", "t" }, "<leader>t" .. id, function()
    toggle_persistent_terminal(id)
  end, {
    desc = ("Toggle persistent terminal %d"):format(id),
    silent = true,
  })
end

local temporary_terminal

local function toggle_temporary_terminal()
  if temporary_terminal and temporary_terminal:is_open() then
    temporary_terminal:close()
    return
  end

  temporary_terminal = Terminal:new({
    id = 99,
    direction = "float",
    display_name = "temporary-terminal",
    hidden = true,
    close_on_exit = true,
    on_close = function(term)
      -- on_close runs before ToggleTerm closes the window, so defer shutdown
      -- until the window has actually been removed.
      vim.schedule(function()
        term:shutdown()
        if temporary_terminal == term then
          temporary_terminal = nil
        end
      end)
    end,
  })

  temporary_terminal:open()
end

vim.keymap.set({ "n", "t" }, "<leader>tt", toggle_temporary_terminal, {
  desc = "Toggle temporary terminal",
  silent = true,
})
