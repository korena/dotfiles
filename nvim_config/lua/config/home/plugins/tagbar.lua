return {
 "majutsushi/tagbar",
  config = function ()
    vim.keymap.set({"n"}, "<leader>f", "<cmd>TagbarToggle<CR>")
  end

}
