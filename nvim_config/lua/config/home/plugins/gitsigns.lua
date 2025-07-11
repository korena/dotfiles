return {
	"lewis6991/gitsigns.nvim",
	config = function()
		local gitsigns = require("gitsigns")
		gitsigns.setup({
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir = {
				interval = 1000,
				follow_files = true,
			},
			attach_to_untracked = true,
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000, -- Disable if file is longer than this (in lines)
			preview_config = {
				-- Options passed to nvim_open_win
				border = "single",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},

			on_attach = function(bufnr)
				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end
				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end)

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end)

				-- Actions
				map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk", noremap = true })
				map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk", noremap = true })

				map("v", "<leader>hs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Stage Selection", noremap = true })

				map("v", "<leader>hr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Reset Selection", noremap = true })

				map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Reset Buffer", noremap = true })
				map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset Buffer", noremap = true })
				map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk", noremap = true })
				map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline", noremap = true })

				map("n", "<leader>hb", function()
					gitsigns.blame_line({ full = true })
				end, { desc = "Blame line", noremap = true })

				map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff this" })

				map("n", "<leader>hD", function()
					gitsigns.diffthis("~")
				end, { desc = "Diff this All" })

				map("n", "<leader>hQ", function()
					gitsigns.setqflist("all")
				end, { desc = "I don't know what this is" })
				map("n", "<leader>hq", gitsigns.setqflist)

				-- Toggles
				map(
					"n",
					"<leader>tb",
					gitsigns.toggle_current_line_blame,
					{ desc = "Toggle current line blame", noremap = true }
				)
				map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "toggle word diff", noremap = true })

				-- Text object
				map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select hunk", noremap = true })
			end,
		})
	end,
}
