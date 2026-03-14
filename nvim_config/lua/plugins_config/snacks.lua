vim.pack.add({
  { src = "https://github.com/folke/snacks.nvim" },
})

local snacks_ok, snacks = pcall(require, "snacks")
if snacks_ok then
  snacks.setup({
    input = {},
    picker = {
      actions = {
        opencode_send = function(...)
          return require("opencode").snacks_picker_send(...)
        end,
      },
      win = {
        input = {
          keys = {
            ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
          },
        },
      },
    },
  })
end
