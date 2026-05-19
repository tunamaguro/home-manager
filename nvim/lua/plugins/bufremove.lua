local bufremove = require("mini.bufremove")

bufremove.setup()

vim.keymap.set("n", "<leader>bd", function()
  bufremove.delete(0, false)
end, {
  desc = "Delete buffer",
  silent = true,
})
