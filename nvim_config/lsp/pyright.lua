-- set configuration for pyls
-- @type vim.lsp.Config
return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { 'python' },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true
      }
    }
  }
}
