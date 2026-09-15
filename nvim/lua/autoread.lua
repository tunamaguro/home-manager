vim.opt.autoread = true

-- Neovim 0.13 provides this behavior natively.
if vim.fn.has("nvim-0.13") == 1 then
	return
end

local watch = require("vim._watch")
local group = vim.api.nvim_create_augroup("user-autoread", { clear = true })
local watchers = {}
local timers = {}
local debounce_ms = 100

local function buffer_autoread(bufnr)
	local value = vim.bo[bufnr].autoread
	if value ~= nil then
		return value
	end
	return vim.go.autoread
end

local function should_watch(bufnr)
	if not vim.api.nvim_buf_is_loaded(bufnr) or vim.bo[bufnr].buftype ~= "" then
		return false
	end

	local path = vim.api.nvim_buf_get_name(bufnr)
	return path ~= "" and vim.uv.fs_stat(path) ~= nil and buffer_autoread(bufnr)
end

local function stop_watcher(bufnr)
	local cancel = watchers[bufnr]
	if cancel then
		pcall(cancel)
		watchers[bufnr] = nil
	end

	local timer = timers[bufnr]
	if timer then
		timer:stop()
		if not timer:is_closing() then
			timer:close()
		end
		timers[bufnr] = nil
	end
end

local ensure_watcher
ensure_watcher = function(bufnr)
	stop_watcher(bufnr)
	if not should_watch(bufnr) then
		return
	end

	local path = vim.api.nvim_buf_get_name(bufnr)
	local timer = vim.uv.new_timer()
	if timer == nil then
		return
	end
	timers[bufnr] = timer

	local ok, cancel = pcall(watch.watch, path, {}, function(_, change_type)
		timer:stop()
		timer:start(debounce_ms, 0, function()
			vim.schedule(function()
				if not vim.api.nvim_buf_is_loaded(bufnr) or not buffer_autoread(bufnr) then
					stop_watcher(bufnr)
					return
				end

				local check_ok, err = pcall(vim.cmd.checktime, bufnr)
				local file_missing = not check_ok and tostring(err):find("E211:", 1, true) ~= nil

				-- Atomic writes replace the watched inode. Deleted files also need the
				-- watcher reconsidered if they reappear later.
				if change_type ~= watch.FileChangeType.Changed or file_missing then
					ensure_watcher(bufnr)
				end

				if not check_ok and not file_missing then
					vim.notify(("autoread: checktime failed for buffer %d: %s"):format(bufnr, err), vim.log.levels.ERROR)
				end
			end)
		end)
	end)

	if not ok then
		timer:close()
		timers[bufnr] = nil
		vim.notify_once("autoread: failed to start file watcher: " .. tostring(cancel), vim.log.levels.WARN)
		return
	end

	watchers[bufnr] = cancel
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "BufFilePost" }, {
	group = group,
	callback = function(event)
		ensure_watcher(event.buf)
	end,
})

vim.api.nvim_create_autocmd({ "BufUnload", "BufWipeout" }, {
	group = group,
	callback = function(event)
		stop_watcher(event.buf)
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
	group = group,
	callback = function(event)
		local bufnr = event.buf or vim.api.nvim_get_current_buf()
		if watchers[bufnr] == nil then
			ensure_watcher(bufnr)
		end
	end,
})

vim.api.nvim_create_autocmd("OptionSet", {
	group = group,
	pattern = "autoread",
	callback = function()
		if vim.v.option_type == "global" then
			for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
				ensure_watcher(bufnr)
			end
		else
			ensure_watcher(vim.api.nvim_get_current_buf())
		end
	end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = group,
	callback = function()
		for bufnr in pairs(watchers) do
			stop_watcher(bufnr)
		end
	end,
})

for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
	ensure_watcher(bufnr)
end
