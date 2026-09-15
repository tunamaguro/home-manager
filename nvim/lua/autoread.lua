vim.opt.autoread = true
vim.opt.updatetime = 300

local group = vim.api.nvim_create_augroup("user-autoread", { clear = true })

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermLeave" }, {
	group = group,
	callback = function()
		if vim.fn.mode() == "c" then
			return
		end

		pcall(vim.cmd.checktime)
	end,
})
