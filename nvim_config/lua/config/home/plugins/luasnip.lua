return {
	"L3MON4D3/LuaSnip",
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	dependencies = {
		"rafamadriz/friendly-snippets",
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	--	event = "VeryLazy",
	config = function()
		require("luasnip.loaders.from_vscode").lazy_load()

		-- my own snippets
		require("luasnip.loaders.from_lua").lazy_load({
			paths = { vim.fn.stdpath("config") .. "/lua/config/snippets" },
		})

		vim.keymap.set("n", "<leader>ls", function()
			local ft = vim.bo.filetype
			local snippets = require("luasnip").get_snippets(ft) or {}
			local lines = { "Available snippets:" }
			for _, s in ipairs(snippets) do
				table.insert(lines, "  - " .. s.trigger)
			end
			Show_debug_in_scratch(lines)
		end, { desc = "List LuaSnip snippets for current filetype" })

--		local ls = require("luasnip")
--		vim.keymap.set({ "i", "s" }, "<TAB>", function()
--			if ls.expand_or_jumpable() then
--				ls.expand_or_jump()
--			end
--		end, { silent = true, desc = "expand or jump in snippet" })
	end,
	opts = {
		history = true,
		delete_check_events = "TextChanged",
	},
}
