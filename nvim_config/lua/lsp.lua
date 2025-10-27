-- set global config for all language servers
vim.lsp.config("*", {
	root_markers = { ".git" },
})

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

-- style the popup floating diagnostics thinger
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  opts.max_width = opts.max_width or 80
  opts.max_height = opts.max_height or 20
  opts.winhighlight = "NormalFloat:DiagnosticFloat,FloatBorder:DiagnosticBorder"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end



-- See config/nvim/lsp/*.lsp
vim.lsp.enable({'clangd', 'bashls', 'gopls', 'pyright', 'rust-analyzer'})
