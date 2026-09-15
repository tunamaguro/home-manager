require("lualine").setup({
	options = {
		theme = "auto",
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = {
			"branch",
			"diff",
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
				sections = { "error", "warn", "info", "hint" },
				symbols = {
					error = "E:",
					warn = "W:",
					info = "I:",
					hint = "H:",
				},
			},
		},
		lualine_c = { "filename" },
		lualine_x = { vim.ui.progress_status, "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	extensions = { "neo-tree" },
})
