-- Toggle diagnostic
vim.keymap.set('n', '<leader>td', "<cmd>ToggleDiagnostics<CR>", {silent = true, desc = 'Toggle diagnostics line'})


local function map(mode, l, r, opts)
  opts = opts or { silent = true }
  opts.buffer = bufnr
  vim.keymap.set(mode, l, r, opts)
end

-- gitsign keys
local gitsigns = require('gitsigns')
    -- Navigation
map('n', ']c', function() if vim.wo.diff then vim.cmd.normal({']c', bang = true}) else gitsigns.nav_hunk('next') end end, { desc = " Next hunk", silent = true })
map('n', '[c', function() if vim.wo.diff then vim.cmd.normal({'[c', bang = true}) else gitsigns.nav_hunk('prev') end end, { desc = " Prev hunk", silent = true })
map({ "n" }, "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk", silent = true })
map({ "n" }, "<leader>hr", gitsigns.reset_hunk, { desc = "reset hunk", silent = true })
map({ "v" }, "<leader>hs", function() gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { desc = " Stage hunk", silent = true })
map({ "v" }, "<leader>hr", function() gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, { desc = " reset hunk", silent = true })
map({ "n" }, "<leader>hS", gitsigns.stage_buffer, { desc = "Stage Buffer", silent = true })
map({ "n" }, "<leader>hR", gitsigns.reset_buffer, { desc = "Reset Buffer", silent = true })
map({ "n" }, "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk", silent = true })
map({ "n" }, "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })
map({ "n" }, "<leader>hb", function() gitsigns.blame_line({ full = true }) end, { desc = "Blame line", silent = true })
map({ "n" }, "<leader>hd", gitsigns.diffthis, { desc = "Diff this", silent = true })
map({ "n" }, "<leader>hD", function() gitsigns.diffthis('~') end, { desc = "Diff this (?)", silent = true })
map({ "n" }, "<leader>hQ", function() gitsigns.setqflist('all') end, { desc = "Set qflist (?)", silent = true })
map({ "n" }, "<leader>hq", gitsigns.setqflist, { desc = "Set qflist (?)", silent = true })
    -- Toggles
map({ "n" }, "<leader>tB", gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame", silent = true })
map({ "n" }, "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle word diff", silent = true })
    -- Text object
map({'o', 'x'}, "<leader>ih", gitsigns.select_hunk, { desc = "select hunk", silent = true })


-- AI assistant
vim.keymap.set({ "n", "x" }, "<leader>q", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
vim.keymap.set({ "n", "x" }, "<leader>qa", function() require("opencode").select() end, { desc = "Execute opencode action…" })
vim.keymap.set({ "n", "t" }, "<leader>ta", function() require("opencode").toggle() end, { desc = "Toggle opencode" })

vim.keymap.set({ "n", "x" }, "<leader>qr",  function() return require("opencode").operator("@this ") end, { desc = "Add range to opencode", expr = true })
vim.keymap.set("n",          "<leader>ql", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })

vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll opencode up" })
vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll opencode down" })
-- nvim tree
vim.g.nvim_tree_quit_on_open = 1
vim.g.nvim_tree_highlight_opened_files = 1
map("n", "<leader>a", "<CMD>Neotree toggle<CR>")
map("n", "<leader>r", "<CMD>Neotree focus<CR>")

-- tagbar
vim.keymap.set("n", "<leader>f", "<cmd>TagbarToggle<CR>")

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


vim.keymap.set('n', '<Leader>p', '"_dP') -- Paste without overwriting the default register


-- Telescope keymaps definition --------------------------------------------------
vim.keymap.set("n", "<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
vim.keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "Fuzzy find recent files" })
vim.keymap.set("n", "<leader>sb", "<cmd>Telescope buffers<cr>", { desc = "Find string in cwd" })
vim.keymap.set("n", "<leader>ss", "<cmd>Telescope git_status<cr>", { desc = "Find string under cursor in cwd" })
vim.keymap.set("n", "<leader>sc", "<cmd>Telescope git commits<cr>", { desc = "Find todos" })

-- LSP keymaps definition -------------------------------------------------------
-- buffer local mappings
local opts = { silent = true }
-- set keybinds
-- show definition, references
opts.desc = "Show LSP references"
vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

-- go to declaration
opts.desc = "Go to declaration"
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

-- show lsp definitions
opts.desc = "Show LSP definitions"
vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

-- show lsp implementations
opts.desc = "Show LSP implementations"
vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

-- show lsp type definitions
opts.desc = "Show LSP type definitions"
vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

-- see available code actions
opts.desc = "Show available code actions"
vim.keymap.set({ "n", "v" }, "<LocalLeader>ca", vim.lsp.buf.code_action, opts)

-- smart rename
opts.desc = "Smart rename"
vim.keymap.set("n", "<LocalLeader>rn", vim.lsp.buf.rename, opts)

-- show diagnostics
opts.desc = "Show buffer diagnostics"
vim.keymap.set("n", "<LocalLeader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

-- show diagnostics for line
opts.desc = "Show line diagnostics"
vim.keymap.set("n", "<LocalLeader>d", vim.diagnostic.open_float, opts)

-- jump to previous diagnostic in buffer
opts.desc = "Go to previous diagnostic"
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

-- jump to next diagnostic in buffer
opts.desc = "Go to next diagnostic"
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

-- show documentation for what is under cursor
opts.desc = "Show documentation for what is under cursor"
vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

-- mapping to restart lsp if necessary
opts.desc = "Restart LSP"
vim.keymap.set("n", "<LocalLeader>rs", "<cmd>LspRestart<CR>", opts)

