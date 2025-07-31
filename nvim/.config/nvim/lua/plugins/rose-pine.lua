return {
	{
		"rose-pine/neovim",
		enabled = false, -- Disabled to use terminal colors
		priority = 1000,
		init = function()
			vim.cmd("colorscheme rose-pine")
		end,
	},
}
