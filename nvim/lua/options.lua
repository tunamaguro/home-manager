-- クリップボードをOSと共有
vim.opt.clipboard:append('unnamedplus,unnamed')

-- 24bit color
vim.opt.termguicolors = true

-- 検索関連
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'split'

-- window関連
vim.opt.scrolloff = 4
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.signcolumn = 'yes:1'
vim.opt.wrap = false
vim.opt.list = true

-- use 2-spaces indent
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
