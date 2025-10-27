-- set configuration for rust analyzer
--@type vim.lsp.Config
return {
cmd = { "rust-analyzer" },
filetypes = { "rust" },
settings = {
  ["rust-analyzer"] = {}
},
}
