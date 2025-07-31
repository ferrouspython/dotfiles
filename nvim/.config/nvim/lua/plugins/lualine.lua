-- Set lualine as statusline
return {
	"nvim-lualine/lualine.nvim",
	config = function()
		-- Terminal-friendly theme using ANSI colors
		local terminal_theme = {
			normal = {
				a = { fg = 0, bg = 4, gui = "bold" }, -- black on blue
				b = { fg = 7, bg = 8 }, -- white on bright black
				c = { fg = 7, bg = 0 }, -- white on black
			},
			insert = {
				a = { fg = 0, bg = 2, gui = "bold" }, -- black on green
				b = { fg = 7, bg = 8 },
				c = { fg = 7, bg = 0 },
			},
			visual = {
				a = { fg = 0, bg = 5, gui = "bold" }, -- black on magenta
				b = { fg = 7, bg = 8 },
				c = { fg = 7, bg = 0 },
			},
			replace = {
				a = { fg = 0, bg = 1, gui = "bold" }, -- black on red
				b = { fg = 7, bg = 8 },
				c = { fg = 7, bg = 0 },
			},
			command = {
				a = { fg = 0, bg = 3, gui = "bold" }, -- black on yellow
				b = { fg = 7, bg = 8 },
				c = { fg = 7, bg = 0 },
			},
			inactive = {
				a = { fg = 8, bg = 0 }, -- bright black on black
				b = { fg = 8, bg = 0 },
				c = { fg = 8, bg = 0 },
			},
		}

		-- Use terminal theme
		local theme = terminal_theme

		local mode = {
			"mode",
			fmt = function(str)
				-- return ' ' .. str:sub(1, 1) -- displays only the first character of the mode
				return " " .. str
			end,
		}

		local filename = {
			"filename",
			file_status = true, -- displays file status (readonly status, modified status)
			path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
		}

		local hide_in_width = function()
			return vim.fn.winwidth(0) > 100
		end

		local diagnostics = {
			"diagnostics",
			sources = { "nvim_diagnostic" },
			sections = { "error", "warn" },
			symbols = { error = " ", warn = " ", info = " ", hint = " " },
			colored = false,
			update_in_insert = false,
			always_visible = false,
			cond = hide_in_width,
		}

		local diff = {
			"diff",
			colored = false,
			symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
			cond = hide_in_width,
		}

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = theme, -- Use terminal theme
				-- Some useful glyphs:
				-- https://www.nerdfonts.com/cheat-sheet
				--        
				section_separators = { left = "", right = "" },
				component_separators = { left = "|", right = "|" },
				disabled_filetypes = { "alpha", "neo-tree", "Avante" },
				always_divide_middle = true,
			},
			sections = {
				lualine_a = { mode },
				lualine_b = { "branch" },
				lualine_c = { filename },
				lualine_x = {
					diagnostics,
					diff,
					{ "encoding", cond = hide_in_width },
					{ "filetype", cond = hide_in_width },
				},
				lualine_y = { "location" },
				lualine_z = { "progress" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { { "location", padding = 0 } },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = { "fugitive" },
		})
	end,
}
