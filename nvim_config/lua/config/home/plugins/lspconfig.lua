return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "folke/neodev.nvim", opts = {} },
		"mason-org/mason.nvim",
		"b0o/schemastore.nvim",
	},
	config = function()
		local has_lspconfig, lspconfig = pcall(require, "lspconfig")
		if not has_lspconfig then
			return
		end

		local keymap = vim.keymap

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(ev)
				-- buffer local mappings
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				-- show definition, references
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				-- go to declaration
				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				-- show lsp definitions
				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				-- show lsp implementations
				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				-- show lsp type definitions
				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				-- see available code actions
				opts.desc = "Show available code actions"
				keymap.set({ "n", "v" }, "<LocalLeader>ca", vim.lsp.buf.code_action, opts)

				-- smart rename
				opts.desc = "Smart rename"
				keymap.set("n", "<LocalLeader>rn", vim.lsp.buf.rename, opts)

				-- show diagnostics
				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<LocalLeader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				-- show diagnostics for line
				opts.desc = "Show line diagnostics"
				keymap.set("n", "<LocalLeader>d", vim.diagnostic.open_float, opts)

				-- jump to previous diagnostic in buffer
				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

				-- jump to next diagnostic in buffer
				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				-- show documentation for what is under cursor
				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)

				-- mapping to restart lsp if necessary
				opts.desc = "Restart LSP"
				keymap.set("n", "<LocalLeader>rs", "<cmd>LspRestart<CR>", opts)
			end,
		})

    vim.g.mapleader = ","
		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
		-- enable snippet
		capabilities.textDocument.completion.completionItem.snippetSupport = true

		-- enable inlay hint
		vim.lsp.inlay_hint.enable(true, { 0 })

		-- change diagnostic symbols in the sign column (gutter)
		local x = vim.diagnostic.severity
		vim.diagnostic.config({
			virtual_text = { prefix = "" },
			signs = {
				text = {
					[x.ERROR] = " ",
					[x.WARN] = " ",
					[x.HINT] = "󰠠 ",
					[x.INFO] = " ",
				},
			},
			underline = true,

			-- do the following for lsp diagnostics:
			-- 1. disable prefix (e.g. number)
			-- 2. sort from the highest severity
			-- 3. include the source where the warn/error come from
			float = { prefix = "", header = "", severity_sort = true, source = true },
		})

		-- lsp server config

		-- html: disable wrap line
		vim.lsp.config("html", {
			settings = {
				html = {
					format = {
						wrapLineLength = 0,
					},
				},
			},
		})
		-- json: validate using schema and pull from schemastore
		vim.lsp.config("jsonls", {
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
				},
			},
		})
		-- lua: recognize "vim" and "mp" global
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim", "mp" },
					},
				},
			},
		})

		-- clangd managed outside of mason
		lspconfig.clangd.setup({
			capabilities = capabilities,
			cmd = {
				"/usr/bin/clangd",
				"--background-index",
				"--clang-tidy",
				"--header-insertion=iwyu",
				"--completion-style=detailed",
				"--function-arg-placeholders",
				"--fallback-style=llvm",
			},
			filetypes = { "c", "cc", "cpp", "objc", "objcpp", "cuda", "proto" },
			init_options = {
				usePlaceholders = true,
				completeUnimported = true,
				clangdFileStatus = true,
			},
			root_dir = function(fname)
				return require("lspconfig.util").root_pattern(
					"Makefile",
					"configure.ac",
					"configure.in",
					"config.h.in",
					"meson.build",
					"meson_options.txt",
					"build.ninja",
					".clangd",
					".clang-tidy",
					".clang-format",
					".git"
				)(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
					fname
				) or require("lspconfig.util").find_git_ancestor(fname)
			end,
			single_file_support = true,
		})
	end,
}
