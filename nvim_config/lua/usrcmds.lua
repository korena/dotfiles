-- Toggle inline diagnostics
vim.api.nvim_create_user_command("ToggleDiagnostics",
function ()
  vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text})
end,
{}
)
