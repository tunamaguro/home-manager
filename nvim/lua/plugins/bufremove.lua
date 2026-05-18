require('mini.bufremove').setup()
vim.keymap.set('n', '<leader>bd', function() require('mini.bufremove').delete(0, false) end, { desc = 'Delete buffer' })