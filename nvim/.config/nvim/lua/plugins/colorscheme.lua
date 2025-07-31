return {
	{
		"folke/tokyonight.nvim",
		enabled = false, -- Disabled to use terminal colors
		lazy = false,
		priority = 1000,
		init = function()
			vim.cmd("colorscheme tokyonight-storm")
		end,
	},
}
