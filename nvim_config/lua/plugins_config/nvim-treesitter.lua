vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
})

require('nvim-treesitter').setup({
  install_dir = vim.fn.stdpath('data') .. '/site'
})

require('nvim-treesitter').install({ 'yaml' })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "yaml" },
  callback = function()
    vim.treesitter.start()
  end,
})
