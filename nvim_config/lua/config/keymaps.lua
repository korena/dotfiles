vim.g.mapleader = ','
vim.g.loaded_matchit = 1

local function map(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, { silent = true })
end

-- nvim treesitter
vim.g.nvim_tree_quit_on_open = 1
vim.g.nvim_tree_highlight_opened_files = 1
map("n", "<leader>a", "<CMD>Neotree toggle<CR>")
map("n", "<leader>r", "<CMD>Neotree focus<CR>")

-- buffer navigation
map("n", "bn",":bn<CR>")
map("n", "bp",":bp<CR>")

-- resize panes
-- Simple arrow key window resizing
vim.keymap.set('n', '<Up>',    '<Cmd>resize +2<CR>',  { desc = 'Increase height' })
vim.keymap.set('n', '<Down>',  '<Cmd>resize -2<CR>',  { desc = 'Decrease height' })
vim.keymap.set('n', '<Left>',  '<Cmd>vertical resize -2<CR>', { desc = 'Decrease width' })
vim.keymap.set('n', '<Right>', '<Cmd>vertical resize +2<CR>', { desc = 'Increase width' })

-- With Alt for faster resizing (optional)
vim.keymap.set('n', '<A-Up>',    '<Cmd>resize +5<CR>')
vim.keymap.set('n', '<A-Down>',  '<Cmd>resize -5<CR>')
vim.keymap.set('n', '<A-Left>',  '<Cmd>vertical resize -5<CR>')
vim.keymap.set('n', '<A-Right>', '<Cmd>vertical resize +5<CR>')
