function ApplyTheme(color)
	color = color or "catppuccin-mocha"
	vim.cmd.colorscheme(color)

	-- 0 to apply it globally.
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end 

ApplyTheme()

