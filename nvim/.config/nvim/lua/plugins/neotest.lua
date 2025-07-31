return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			-- Test adapters
			"nvim-neotest/neotest-python",
			"olimorris/neotest-rspec",
			"rouge8/neotest-rust",
			-- For debugging integration (optional)
			"mfussenegger/nvim-dap",
		},
		keys = {
			{
				"<leader>tn",
				function()
					require("neotest").run.run()
				end,
				desc = "Run nearest test",
			},
			{
				"<leader>tf",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Run file tests",
			},
			{
				"<leader>ts",
				function()
					require("neotest").run.run({ suite = true })
				end,
				desc = "Run test suite",
			},
			{
				"<leader>tl",
				function()
					require("neotest").run.run_last()
				end,
				desc = "Run last test",
			},
			{
				"<leader>td",
				function()
					require("neotest").run.run({ strategy = "dap" })
				end,
				desc = "Debug nearest test",
			},
			{
				"<leader>to",
				function()
					require("neotest").output.open({ enter = true, auto_close = true })
				end,
				desc = "Show test output",
			},
			{
				"<leader>tO",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "Toggle test output panel",
			},
			{
				"<leader>tt",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Toggle test summary",
			},
			{
				"<leader>tw",
				function()
					require("neotest").watch.toggle(vim.fn.expand("%"))
				end,
				desc = "Toggle watch mode",
			},
			{
				"[t",
				function()
					require("neotest").jump.prev({ status = "failed" })
				end,
				desc = "Jump to previous failed test",
			},
			{
				"]t",
				function()
					require("neotest").jump.next({ status = "failed" })
				end,
				desc = "Jump to next failed test",
			},
		},
		config = function()
			local neotest = require("neotest")
			neotest.setup({
				adapters = {
					require("neotest-python")({
						dap = { justMyCode = false },
						runner = "pytest",
						python = ".venv/bin/python", -- Adjust if using different venv name
						args = { "--tb=short", "-vv" },
					}),
					require("neotest-rspec")({
						command = "bundle exec rspec",
						rspec_cmd = function()
							return vim.tbl_flatten({
								"bundle",
								"exec",
								"rspec",
							})
						end,
					}),
					require("neotest-rust")({
						args = { "--no-capture" },
						dap_adapter = "lldb",
					}),
				},
				discovery = {
					enabled = true,
				},
				diagnostic = {
					enabled = true,
					severity = vim.diagnostic.severity.ERROR,
				},
				floating = {
					border = "rounded",
					max_height = 0.8,
					max_width = 0.8,
					options = {},
				},
				icons = {
					expanded = "",
					child_prefix = "├",
					child_indent = "│",
					final_child_prefix = "└",
					non_collapsible = "─",
					collapsed = "",
					passed = "✓",
					running = "⟳",
					failed = "✗",
					skipped = "↓",
					unknown = "?",
				},
				output = {
					enabled = true,
					open_on_run = false,
				},
				output_panel = {
					enabled = true,
					open = "botright split | resize 10",
				},
				quickfix = {
					enabled = false,
					open = false,
				},
				run = {
					enabled = true,
				},
				running = {
					concurrent = true,
				},
				state = {
					enabled = true,
				},
				status = {
					enabled = true,
					virtual_text = true,
					signs = true,
				},
				strategies = {
					integrated = {
						height = 30,
						width = 120,
					},
				},
				summary = {
					animated = true,
					enabled = true,
					expand_errors = true,
					follow = true,
					mappings = {
						attach = "a",
						clear_marked = "M",
						clear_target = "T",
						debug = "d",
						debug_marked = "D",
						expand = { "<CR>", "<2-LeftMouse>" },
						expand_all = "e",
						jumpto = "i",
						mark = "m",
						next_failed = "J",
						output = "o",
						prev_failed = "K",
						run = "r",
						run_marked = "R",
						short = "O",
						stop = "u",
						target = "t",
						watch = "w",
					},
					open = "botright vsplit | vertical resize 40",
				},
				watch = {
					enabled = true,
					symbol_queries = {
						python = [[
              ;query
              ;Captures class, function and method definitions
              (class_definition
                name: (identifier) @symbol)
              (function_definition
                name: (identifier) @symbol)
            ]],
					},
				},
			})

			-- Set up code coverage signs
			vim.fn.sign_define("neotest_passed", { text = "✓", texthl = "NeotestPassed" })
			vim.fn.sign_define("neotest_failed", { text = "✗", texthl = "NeotestFailed" })
			vim.fn.sign_define("neotest_running", { text = "⟳", texthl = "NeotestRunning" })
			vim.fn.sign_define("neotest_skipped", { text = "↓", texthl = "NeotestSkipped" })
			vim.fn.sign_define("neotest_unknown", { text = "?", texthl = "NeotestUnknown" })
		end,
	},
	-- Coverage integration
	{
		"andythigpen/nvim-coverage",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{
				"<leader>tc",
				function()
					require("coverage").toggle()
				end,
				desc = "Toggle coverage",
			},
			{
				"<leader>tC",
				function()
					require("coverage").load(true)
				end,
				desc = "Load coverage",
			},
		},
		config = function()
			require("coverage").setup({
				auto_reload = true,
				commands = true,
				highlights = {
					covered = { fg = "#98C379" },
					uncovered = { fg = "#E06C75" },
				},
				signs = {
					covered = { hl = "CoverageCovered", text = "▎" },
					uncovered = { hl = "CoverageUncovered", text = "▎" },
				},
				summary = {
					min_coverage = 80.0,
				},
				lang = {
					python = {
						coverage_file = ".coverage",
						coverage_command = "coverage json -o -",
					},
					ruby = {
						coverage_file = "coverage/coverage.json",
						coverage_command = "bundle exec rspec",
					},
					rust = {
						coverage_file = "target/coverage/lcov.info",
					},
				},
			})
		end,
	},
}