return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"hrsh7th/cmp-nvim-lsp",
			"b0o/schemastore.nvim", -- For JSON schemas
		},
		config = function()
			-- Auto-detect Python virtual environments
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "python",
				callback = function()
					local venv = vim.fn.findfile("venv/bin/python", vim.fn.getcwd() .. ";")
					if venv ~= "" then
						vim.g.python3_host_prog = vim.fn.getcwd() .. "/venv/bin/python"
					else
						venv = vim.fn.findfile(".venv/bin/python", vim.fn.getcwd() .. ";")
						if venv ~= "" then
							vim.g.python3_host_prog = vim.fn.getcwd() .. "/.venv/bin/python"
						end
					end
				end,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})
						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end
					if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							check = {
								command = "clippy",
							},
							cargo = {
								features = "all",
							},
						},
					},
				},
				pyright = {
					settings = {
						python = {
							analysis = {
								autoSearchPaths = true,
								diagnosticMode = "openFilesOnly",
								useLibraryCodeForTypes = true,
								typeCheckingMode = "strict",
							},
						},
					},
				},
				solargraph = {
					settings = {
						solargraph = {
							diagnostics = true,
							completion = true,
							hover = true,
							formatting = false, -- We'll use standardrb for formatting
							symbols = true,
							definitions = true,
							rename = true,
							references = true,
							folding = true,
						},
					},
				},
				clangd = {
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--header-insertion=iwyu",
						"--completion-style=detailed",
						"--function-arg-placeholders",
						"--fallback-style=llvm",
					},
					init_options = {
						usePlaceholders = true,
						completeUnimported = true,
						clangdFileStatus = true,
					},
				},
				yamlls = {
					settings = {
						yaml = {
							schemas = {
								kubernetes = "*.yaml",
								["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
								["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
							},
							format = {
								enable = true,
							},
						},
					},
				},
				jsonls = {
					settings = {
						json = {
							schemas = require("schemastore").json.schemas(),
							validate = { enable = true },
						},
					},
				},
				terraformls = {},
				dockerls = {},
				helm_ls = {
					settings = {
						["helm-ls"] = {
							yamlls = {
								path = "yaml-language-server",
							},
						},
					},
				},
				sqlls = {
					settings = {
						sqls = {
							connections = {
								-- You can add database connections here later
								-- {
								--   driver = "postgresql",
								--   dataSourceName = "host=localhost port=5432 user=myuser dbname=mydb sslmode=disable",
								-- },
							},
						},
					},
				},
			}
			require("mason").setup()
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				-- Formatters
				"stylua", -- Lua formatter
				"ruff", -- Python formatter and linter
				"black", -- Python formatter (alternative)
				"isort", -- Python import sorter (alternative)
				"standardrb", -- Ruby formatter
				"rubocop", -- Ruby formatter (alternative)
				"rustfmt", -- Rust formatter (installed via rustup usually)
				"clang-format", -- C/C++ formatter
				"prettier", -- Multi-language formatter (JSON, YAML, MD, etc.)
				"terraform", -- Terraform CLI (includes formatter)
				-- Debuggers
				"debugpy", -- Python debugger
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
