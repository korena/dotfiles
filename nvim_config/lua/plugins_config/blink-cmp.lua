vim.pack.add({
  { src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1.*") },
})

require("blink.cmp").setup({
  signature = { enabled = true },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
    menu = {
      auto_show = true,
      draw = {
        treesitter = { 'lsp' },
        columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
      },
    },
  },
  keymap = {
    ['<CR>'] = { 'accept', 'fallback' }
  },
})
