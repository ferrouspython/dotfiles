return {
	-- Auto-pairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		dependencies = { "hrsh7th/nvim-cmp" },
		config = function()
			local autopairs = require("nvim-autopairs")
			autopairs.setup({
				check_ts = true, -- Enable treesitter
				ts_config = {
					lua = { "string" }, -- Don't add pairs in lua string treesitter nodes
					javascript = { "template_string" },
				},
				disable_filetype = { "TelescopePrompt", "vim" },
				fast_wrap = {
					map = "<M-e>",
					chars = { "{", "[", "(", '"', "'" },
					pattern = [=[[%'%"%>%]%)%}%,]]=],
					end_key = "$",
					keys = "qwertyuiopzxcvbnmasdfghjkl",
					check_comma = true,
					highlight = "Search",
					highlight_grey = "Comment",
				},
			})

			-- Integration with nvim-cmp
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},

	-- Surround
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				keymaps = {
					insert = "<C-g>s",
					insert_line = "<C-g>S",
					normal = "ys",
					normal_cur = "yss",
					normal_line = "yS",
					normal_cur_line = "ySS",
					visual = "S",
					visual_line = "gS",
					delete = "ds",
					change = "cs",
					change_line = "cS",
				},
			})
		end,
	},

	-- Better diagnostics
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "Trouble", "TroubleToggle" },
		keys = {
			{ "<leader>dd", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
			{ "<leader>dD", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
			{ "<leader>dl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
			{ "<leader>dq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
			{ "<leader>dr", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP References (Trouble)" },
		},
		opts = {
			-- UI configuration
			icons = {
				indent = {
					fold_open = "",
					fold_closed = "",
				},
			},
			-- Window configuration
			win = {
				position = "bottom",
				size = 10,
			},
			-- Action keymaps
			keys = {
				["<esc>"] = "cancel",
				["q"] = "close",
				["r"] = "refresh",
				["<cr>"] = "jump",
				["<tab>"] = "jump",
				["<c-s>"] = "jump_split",
				["<c-v>"] = "jump_vsplit",
				["o"] = "jump_close",
				["P"] = "toggle_preview",
				["p"] = "preview",
				["zM"] = "fold_close_all",
				["zm"] = "fold_more",
				["zR"] = "fold_open_all",
				["zr"] = "fold_reduce",
				["zA"] = "fold_toggle_recursive",
				["za"] = "fold_toggle",
				["k"] = "prev",
				["j"] = "next",
				["i"] = "inspect",
				["dd"] = "delete",
			},
		},
	},

	-- Rust tools
	{
		"saecki/crates.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = { "BufRead Cargo.toml" },
		config = function()
			require("crates").setup({
				null_ls = {
					enabled = true,
					name = "crates.nvim",
				},
				popup = {
					border = "rounded",
					show_version_date = true,
					show_dependency_version = true,
					max_height = 30,
					min_width = 20,
					padding = 1,
				},
				completion = {
					cmp = {
						enabled = true,
					},
				},
			})

			-- Keymaps for crates.nvim
			vim.api.nvim_create_autocmd("BufRead", {
				group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
				pattern = "Cargo.toml",
				callback = function()
					local crates = require("crates")
					local opts = { noremap = true, silent = true, buffer = true }

					vim.keymap.set("n", "<leader>ct", crates.toggle, vim.tbl_extend("force", opts, { desc = "Toggle crates info" }))
					vim.keymap.set("n", "<leader>cr", crates.reload, vim.tbl_extend("force", opts, { desc = "Reload crates" }))
					vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, vim.tbl_extend("force", opts, { desc = "Show crate versions" }))
					vim.keymap.set("n", "<leader>cf", crates.show_features_popup, vim.tbl_extend("force", opts, { desc = "Show crate features" }))
					vim.keymap.set("n", "<leader>cd", crates.show_dependencies_popup, vim.tbl_extend("force", opts, { desc = "Show crate dependencies" }))
					vim.keymap.set("n", "<leader>cu", crates.update_crate, vim.tbl_extend("force", opts, { desc = "Update crate" }))
					vim.keymap.set("v", "<leader>cu", crates.update_crates, vim.tbl_extend("force", opts, { desc = "Update selected crates" }))
					vim.keymap.set("n", "<leader>ca", crates.update_all_crates, vim.tbl_extend("force", opts, { desc = "Update all crates" }))
					vim.keymap.set("n", "<leader>cU", crates.upgrade_crate, vim.tbl_extend("force", opts, { desc = "Upgrade crate" }))
					vim.keymap.set("v", "<leader>cU", crates.upgrade_crates, vim.tbl_extend("force", opts, { desc = "Upgrade selected crates" }))
					vim.keymap.set("n", "<leader>cA", crates.upgrade_all_crates, vim.tbl_extend("force", opts, { desc = "Upgrade all crates" }))
				end,
			})
		end,
	},

	-- Session management
	{
		"rmagatti/auto-session",
		config = function()
			-- Set sessionoptions as recommended by health check
			vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
			
			require("auto-session").setup({
				log_level = "error",
				auto_session_enable_last_session = false,
				auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
				auto_session_enabled = true,
				auto_save_enabled = true,
				auto_restore_enabled = true,
				auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
				auto_session_use_git_branch = true,
				-- Session lens
				session_lens = {
					buftypes_to_ignore = {}, -- list of buffer types that should not be deleted from current session
					load_on_setup = true,
					theme_conf = { border = true },
					previewer = false,
				},
			})

			-- Keymaps
			vim.keymap.set("n", "<leader>Ss", require("auto-session.session-lens").search_session, {
				noremap = true,
				desc = "Search sessions",
			})
			vim.keymap.set("n", "<leader>Sd", ":SessionDelete<CR>", { desc = "Delete session" })
			vim.keymap.set("n", "<leader>Sr", ":SessionRestore<CR>", { desc = "Restore session" })
			vim.keymap.set("n", "<leader>SS", ":SessionSave<CR>", { desc = "Save session" })
		end,
	},

	-- Terminal integration
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				size = function(term)
					if term.direction == "horizontal" then
						return 15
					elseif term.direction == "vertical" then
						return vim.o.columns * 0.4
					end
				end,
				open_mapping = [[<c-\>]],
				hide_numbers = true,
				shade_filetypes = {},
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				insert_mappings = true,
				terminal_mappings = true,
				persist_size = true,
				persist_mode = true,
				direction = "float",
				close_on_exit = true,
				shell = vim.o.shell,
				float_opts = {
					border = "curved",
					winblend = 0,
					highlights = {
						border = "Normal",
						background = "Normal",
					},
				},
			})

			-- Terminal keymaps
			function _G.set_terminal_keymaps()
				local opts = { buffer = 0 }
				vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], vim.tbl_extend("force", opts, { desc = "Exit terminal mode" }))
				vim.keymap.set("t", "jk", [[<C-\><C-n>]], vim.tbl_extend("force", opts, { desc = "Exit terminal mode" }))
				vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], vim.tbl_extend("force", opts, { desc = "Navigate to left window" }))
				vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], vim.tbl_extend("force", opts, { desc = "Navigate to lower window" }))
				vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], vim.tbl_extend("force", opts, { desc = "Navigate to upper window" }))
				vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], vim.tbl_extend("force", opts, { desc = "Navigate to right window" }))
			end

			vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

			-- Custom terminals
			local Terminal = require("toggleterm.terminal").Terminal

			-- Lazygit terminal
			local lazygit = Terminal:new({
				cmd = "lazygit",
				dir = "git_dir",
				direction = "float",
				float_opts = {
					border = "double",
				},
				on_open = function(term)
					vim.cmd("startinsert!")
					vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true, desc = "Close terminal" })
				end,
			})

			function _LAZYGIT_TOGGLE()
				lazygit:toggle()
			end

			-- Python terminal
			local python = Terminal:new({ cmd = "python3", hidden = true })

			function _PYTHON_TOGGLE()
				python:toggle()
			end

			-- Node terminal
			local node = Terminal:new({ cmd = "node", hidden = true })

			function _NODE_TOGGLE()
				node:toggle()
			end

			-- IRB terminal
			local irb = Terminal:new({ cmd = "irb", hidden = true })

			function _IRB_TOGGLE()
				irb:toggle()
			end

			-- Cargo run terminal
			local cargo_run = Terminal:new({ cmd = "cargo run", hidden = true })

			function _CARGO_RUN()
				cargo_run:toggle()
			end

			-- Additional keymaps
			vim.keymap.set("n", "<leader>tg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { desc = "Lazygit" })
			vim.keymap.set("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", { desc = "Python terminal" })
			vim.keymap.set("n", "<leader>tn", "<cmd>lua _NODE_TOGGLE()<CR>", { desc = "Node terminal" })
			vim.keymap.set("n", "<leader>ti", "<cmd>lua _IRB_TOGGLE()<CR>", { desc = "IRB terminal" })
			vim.keymap.set("n", "<leader>tR", "<cmd>lua _CARGO_RUN()<CR>", { desc = "Cargo run" })
			vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { desc = "Float terminal" })
			vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<CR>", { desc = "Horizontal terminal" })
			vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<CR>", { desc = "Vertical terminal" })
		end,
	},
}