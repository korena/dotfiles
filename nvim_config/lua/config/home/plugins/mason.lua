return {
	{
		"williamboman/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			-- list of lsp for mason to install
			ensure_installed = {
				"html",
				"jsonls",
				"yamlls",
				"lua_ls",
				"rust_analyzer",
				"pyright",
				"bashls",
				"vimls",
				"mdx_analyzer",
				"gopls",
			},
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			-- list of formatter and linter for mason to install
			ensure_installed = {
				"prettierd", -- prettierd formatter
				"stylua", -- lua formatter
				"shfmt", -- sh formatter with bash support
			},
		},
	},
}
