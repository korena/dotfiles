-- set configuration for clangd
-- @type vim.lsp.Config
return {
  cmd = {"gopls"},
  filetypes = {"go", "gomod"},
  root_markers = {"go.mod", ".git" }
}
