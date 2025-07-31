return {
	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format" },
				-- Alternative Python formatters (commented out):
				-- python = { "black" },
				-- python = { "isort", "black" }, -- Run both sequentially
				-- python = { "autopep8" },
				
				ruby = { "standardrb" },
				-- Alternative Ruby formatters (commented out):
				-- ruby = { "rubocop" },
				-- ruby = { "rufo" },
				
				rust = { "rustfmt" },
				
				c = { "clang_format" },
				cpp = { "clang_format" },
				
				json = { "prettier" },
				jsonc = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				
				terraform = { "terraform_fmt" },
				tf = { "terraform_fmt" },
				
				-- For any filetype not listed above, try prettier as a fallback
				["_"] = { "trim_whitespace" },
			},
			formatters = {
				ruff_format = {
					command = "ruff",
					args = {
						"format",
						"--stdin-filename",
						"$FILENAME",
						"-",
					},
				},
				standardrb = {
					command = "standardrb",
					args = { "--fix", "--stdin", "$FILENAME" },
					stdin = true,
				},
				clang_format = {
					command = "clang-format",
					args = {
						"--style={BasedOnStyle: LLVM, IndentWidth: 4, ColumnLimit: 100}",
						"--assume-filename",
						"$FILENAME",
					},
				},
				prettier = {
					prepend_args = { "--tab-width", "4", "--print-width", "100" },
				},
			},
		},
	},
}
