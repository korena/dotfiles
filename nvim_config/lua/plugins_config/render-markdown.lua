vim.pack.add({
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
})

require('render-markdown').setup({
  completions = { lsp = { enabled = true } },
  render_modes = true,
  sign = {
    enabled = false,
  },
  file_types = { "markdown", "codecompanion" },
})
