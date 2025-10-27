vim.pack.add({
  -- git support
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  -- neo-tree and telescope dependencies
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons"},
  { src = "https://github.com/MunifTanjim/nui.nvim"},
  { src = "https://github.com/s1n7ax/nvim-window-picker", version = 'v2.4.0' },
  { src = "https://github.com/antosha417/nvim-lsp-file-operations" },
  -- neo-tree
  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },
  -- tagbar
  { src = "https://github.com/majutsushi/tagbar" },
  -- whichkey
  { src = "https://github.com/folke/which-key.nvim" },
  -- luasnip
  { src = "https://github.com/rafamadriz/friendly-snippets"},
  { src = "https://github.com/L3MON4D3/LuaSnip"},
  -- blink.cmp (completion)
  { src = "https://github.com/Saghen/blink.cmp", version= vim.version.range("1.*")},
  -- bufferline
  { src = "https://github.com/akinsho/bufferline.nvim", version = "v4.9.1"},
  -- telescope
  { src = "https://github.com/nvim-telescope/telescope.nvim", branch = "0.1.6" },
  -- autosave
  { src = "https://github.com/Pocco81/auto-save.nvim" },
})

require('gitsigns').setup({ signcolumn = true })
require('neo-tree').setup({
	lazy = false,
	
})
require("luasnip.loaders.from_vscode").lazy_load()
require("blink.cmp").setup({
  signature = {enabled = true},
  completion = {
    documentation = {auto_show = true, auto_show_delay_ms = 500},
    menu = {
      auto_show = true,
      draw = {
        treesitter = {'lsp'},
        columns = { {"kind_icon", "label", "label_description", gap = 1}, {"kind"} },
      },
    },
  },
  keymap = {
    -- These are the defaults, got them from the docs, get used to them! They're sensible
    --
    -- ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    -- ['<C-e>'] = { 'hide', 'fallback' },
    -- ['<C-y>'] = { 'select_and_accept', 'fallback' },
    -- 
    -- ['<Up>'] = { 'select_prev', 'fallback' },
    -- ['<Down>'] = { 'select_next', 'fallback' },
    -- ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
    -- ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
    -- 
    -- ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    -- ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
    -- 
    -- ['<Tab>'] = { 'snippet_forward', 'fallback' },
    -- ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
    -- 
    -- ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    ['<CR>'] = {'accept', 'fallback'}
  },
})
require("bufferline").setup({
  options = {
    numbers = "buffer_id",
    close_command = "bdelete! %d",
    right_mouse_command = nil,
    left_mouse_command = "buffer %d",
    middle_mouse_command = nil,
    indicator = {
      style = 'icon',
      icon = "▎"
    },
    buffer_close_icon = "✕",
    modified_icon = "●",
    close_icon = "x",
    left_trunc_marker = "",
    right_trunc_marker = "",
    max_name_length = 18,
    max_prefix_length = 15,
    tab_size = 10,
    diagnostics = false,
    custom_filter = function(bufnr)
      -- if the result is false, this buffer will be shown, otherwise, this
      -- buffer will be hidden.

      -- filter out filetypes you don't want to see
      local exclude_ft = { "qf", "fugitive", "git" }
      local cur_ft = vim.bo[bufnr].filetype
      local should_filter = vim.tbl_contains(exclude_ft, cur_ft)

      if should_filter then
        return false
      end

      return true
    end,
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true,
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    separator_style = "bar",
    enforce_regular_tabs = false,
    always_show_bufferline = true,
    sort_by = "id",
  },
})
