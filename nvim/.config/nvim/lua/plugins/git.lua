return {
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "G", "Gstatus", "Gblame", "Gpush", "Gpull", "Gdiff", "Glog" },
		keys = {
			{ "<leader>gs", ":Git<CR>", desc = "Git status" },
			{ "<leader>gb", ":Git blame<CR>", desc = "Git blame" },
			{ "<leader>gd", ":Gdiffsplit<CR>", desc = "Git diff split" },
			{ "<leader>gc", ":Git commit<CR>", desc = "Git commit" },
			{ "<leader>gC", ":Git cz<CR>", desc = "Git commit with commitizen" },
			{ "<leader>gp", ":Git push<CR>", desc = "Git push" },
			{ "<leader>gP", ":Git pull<CR>", desc = "Git pull" },
			{ "<leader>gl", ":Git log --oneline<CR>", desc = "Git log" },
			{ "<leader>gL", ":Git log<CR>", desc = "Git log (full)" },
			-- Hunks navigation (works with gitsigns)
			{ "[g", ":Gitsigns prev_hunk<CR>", desc = "Previous git hunk" },
			{ "]g", ":Gitsigns next_hunk<CR>", desc = "Next git hunk" },
		},
		config = function()
			-- Better Git commit window
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "gitcommit",
				callback = function()
					vim.opt_local.spell = true
					vim.opt_local.spelllang = "en_us"
					vim.opt_local.textwidth = 72
					vim.opt_local.colorcolumn = "50,72"
				end,
			})
		end,
	},
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
		keys = {
			{ "<leader>gv", "<cmd>DiffviewOpen<CR>", desc = "Open diff view" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
			{ "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "Branch history" },
			{ "<leader>gx", "<cmd>DiffviewClose<CR>", desc = "Close diff view" },
		},
		config = function()
			require("diffview").setup({
				diff_binaries = false,
				enhanced_diff_hl = true,
				git_cmd = { "git" },
				use_icons = true,
				icons = {
					folder_closed = "",
					folder_open = "",
				},
				signs = {
					fold_closed = "",
					fold_open = "",
					done = "✓",
				},
				view = {
					default = {
						layout = "diff2_horizontal",
						winbar_info = true,
					},
					merge_tool = {
						layout = "diff3_horizontal",
						disable_diagnostics = true,
						winbar_info = true,
					},
					file_history = {
						layout = "diff2_horizontal",
						winbar_info = true,
					},
				},
				file_panel = {
					listing_style = "tree",
					tree_options = {
						flatten_dirs = true,
						folder_statuses = "only_folded",
					},
					win_config = {
						position = "left",
						width = 35,
						win_opts = {},
					},
				},
				file_history_panel = {
					log_options = {
						git = {
							single_file = {
								diff_merges = "combined",
							},
							multi_file = {
								diff_merges = "first-parent",
							},
						},
					},
					win_config = {
						position = "bottom",
						height = 16,
						win_opts = {},
					},
				},
				commit_log_panel = {
					win_config = {},
				},
				default_args = {
					DiffviewOpen = {},
					DiffviewFileHistory = {},
				},
				hooks = {
					diff_buf_read = function()
						vim.opt_local.wrap = false
						vim.opt_local.list = false
						vim.opt_local.colorcolumn = { 80 }
					end,
				},
				keymaps = {
					disable_defaults = false,
					view = {
						["<tab>"] = require("diffview.actions").select_next_entry,
						["<s-tab>"] = require("diffview.actions").select_prev_entry,
						["gf"] = require("diffview.actions").goto_file,
						["<C-w><C-f>"] = require("diffview.actions").goto_file_split,
						["<C-w>gf"] = require("diffview.actions").goto_file_tab,
						["<leader>e"] = require("diffview.actions").focus_files,
						["<leader>b"] = require("diffview.actions").toggle_files,
					},
					file_panel = {
						["j"] = require("diffview.actions").next_entry,
						["<down>"] = require("diffview.actions").next_entry,
						["k"] = require("diffview.actions").prev_entry,
						["<up>"] = require("diffview.actions").prev_entry,
						["<cr>"] = require("diffview.actions").select_entry,
						["o"] = require("diffview.actions").select_entry,
						["<2-LeftMouse>"] = require("diffview.actions").select_entry,
						["-"] = require("diffview.actions").toggle_stage_entry,
						["S"] = require("diffview.actions").stage_all,
						["U"] = require("diffview.actions").unstage_all,
						["X"] = require("diffview.actions").restore_entry,
						["R"] = require("diffview.actions").refresh_files,
						["<tab>"] = require("diffview.actions").select_next_entry,
						["<s-tab>"] = require("diffview.actions").select_prev_entry,
						["gf"] = require("diffview.actions").goto_file,
						["<C-w><C-f>"] = require("diffview.actions").goto_file_split,
						["<C-w>gf"] = require("diffview.actions").goto_file_tab,
						["i"] = require("diffview.actions").listing_style,
						["f"] = require("diffview.actions").toggle_flatten_dirs,
						["<leader>e"] = require("diffview.actions").focus_files,
						["<leader>b"] = require("diffview.actions").toggle_files,
					},
					file_history_panel = {
						["g!"] = require("diffview.actions").options,
						["<C-A-d>"] = require("diffview.actions").open_in_diffview,
						["y"] = require("diffview.actions").copy_hash,
						["zR"] = require("diffview.actions").open_all_folds,
						["zM"] = require("diffview.actions").close_all_folds,
						["j"] = require("diffview.actions").next_entry,
						["<down>"] = require("diffview.actions").next_entry,
						["k"] = require("diffview.actions").prev_entry,
						["<up>"] = require("diffview.actions").prev_entry,
						["<cr>"] = require("diffview.actions").select_entry,
						["o"] = require("diffview.actions").select_entry,
						["<2-LeftMouse>"] = require("diffview.actions").select_entry,
						["<tab>"] = require("diffview.actions").select_next_entry,
						["<s-tab>"] = require("diffview.actions").select_prev_entry,
						["gf"] = require("diffview.actions").goto_file,
						["<C-w><C-f>"] = require("diffview.actions").goto_file_split,
						["<C-w>gf"] = require("diffview.actions").goto_file_tab,
						["<leader>e"] = require("diffview.actions").focus_files,
						["<leader>b"] = require("diffview.actions").toggle_files,
					},
				},
			})
		end,
	},
}