return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		main = "nvim-treesitter.configs",
		opts = {
			ensure_installed = {
				-- Original parsers
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"latex",
				"query",
				"vim",
				"vimdoc",
				-- Language parsers
				"python",
				"ruby",
				"rust",
				"cpp",
				-- Config/Data parsers
				"json",
				"jsonc",
				"yaml",
				"toml",
				"ini",
				"csv",
				-- DevOps parsers
				"dockerfile",
				"terraform",
				"hcl",
				"make",
				"cmake",
				-- Additional parsers
				"sql",
				"proto",
				-- Web dev (for occasional use)
				"javascript",
				"typescript",
				"tsx",
				"css",
				-- Git
				"git_config",
				"git_rebase",
				"gitcommit",
				"gitignore",
				"gitattributes",
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["as"] = "@scope",
						["ai"] = "@conditional.outer",
						["ii"] = "@conditional.inner",
						["al"] = "@loop.outer",
						["il"] = "@loop.inner",
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
						["]o"] = "@loop.outer",
						["]s"] = "@scope",
						["]z"] = "@fold",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
						["[o"] = "@loop.outer",
						["[s"] = "@scope",
						["[z"] = "@fold",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
			},
		},
	},
}
