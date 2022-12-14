local api = vim.api
local lsp = vim.lsp

local M = {}

function M.show_line_diagnostics()
  local opts = {
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    border = 'rounded',
    source = 'always',  -- show source in diagnostic popup window
    prefix = ' '
  }
  vim.diagnostic.open_float(nil, opts)
end

local custom_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    api.nvim_buf_set_keymap(bufnr, ...)
  end

  -- Mappings.
  local opts = { noremap = true, silent = true }
  buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "<C-]>", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setqflist({open = true})<CR>", opts)
  buf_set_keymap("n", "<space>s", "<cmd>lua vim.diagnostic.show()<CR>", opts)
  buf_set_keymap("n", "<space>h", "<cmd>lua vim.diagnostic.hide()<CR>", opts)
  buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)

  vim.cmd([[
    autocmd CursorHold <buffer> lua require('config.lsp').show_line_diagnostics()
  ]])

  -- Set some key bindings conditional on server capabilities
  if client.server_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", opts)
  end
  if client.server_capabilities.document_range_formatting then
    buf_set_keymap("x", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR><ESC>", opts)
  end

  -- The blow command will highlight the current variable and its usages in the buffer.
  if client.server_capabilities.document_highlight then
    vim.cmd([[
      hi! link LspReferenceRead Visual
      hi! link LspReferenceText Visual
      hi! link LspReferenceWrite Visual
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]])
  end

  if vim.g.logging_level == 'debug' then
    local msg = string.format("Language server %s started!", client.name)
    vim.notify(msg, 'info', {title = 'Nvim-config'})
  end
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lspconfig = require("lspconfig")

lspconfig.pylsp.setup({
  on_attach = custom_attach,
  settings = {
    pylsp = {
      plugins = {
        pylint = { enabled = true, executable = "pylint" },
        pyflakes = { enabled = false },
        pycodestyle = { enabled = false },
        jedi_completion = { fuzzy = true },
        pyls_isort = { enabled = true },
        pylsp_mypy = { enabled = true },
      },
    },
  },
  flags = {
    debounce_text_changes = 200,
  },
  capabilities = capabilities,
})

 lspconfig.pyright.setup{
   on_attach = custom_attach,
   capabilities = capabilities
 }

lspconfig.clangd.setup({
  on_attach = custom_attach,
  capabilities = capabilities,
  filetypes = { "c", "cpp", "cc", "objc", "objcpp" },
  flags = {
    debounce_text_changes = 500,
  },
  cmd = {
    -- see clangd --help-hidden
    "clangd",
    "--background-index",
    -- by default, clang-tidy use -checks=clang-diagnostic-*,clang-analyzer-*
    -- to add more checks, create .clang-tidy file in the root directory
    -- and add Checks key, see https://clang.llvm.org/extra/clang-tidy/
    "--clang-tidy",
    "--completion-style=bundled",
    "--cross-file-rename",
    "--header-insertion=iwyu",
  }
})

-- set up vim-language-server
lspconfig.vimls.setup({
  on_attach = custom_attach,
  capabilities = capabilities,
  filetypes = {"sh"},
  flags = {
    debounce_text_changes = 500,
  },
  cmd = {
    "bash-language-server",
    "start"
  }
})


-- golang language server

lspconfig.gopls.setup {

	cmd = {'gopls'},
-- for postfix snippets and analyzers
	capabilities = capabilities,
	    settings = {
	      gopls = {
		      experimentalPostfixCompletions = true,
		      analyses = {
		        unusedparams = true,
		        shadow = true,
		     },
		     staticcheck = true,
		    },
	    },
	on_attach = custom_attach,
}

  function goimports(timeoutms)
    local context = { source = { organizeImports = true } }
    vim.validate { context = { context, "t", true } }

    local params = vim.lsp.util.make_range_params()
    params.context = context

    -- See the implementation of the textDocument/codeAction callback
    -- (lua/vim/lsp/handler.lua) for how to do this properly.
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
    if not result or next(result) == nil then return end
    local actions = result[1].result
    if not actions then return end
    local action = actions[1]

    -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
    -- is a CodeAction, it can have either an edit, a command or both. Edits
    -- should be executed first.
    if action.edit or type(action.command) == "table" then
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit)
      end
      if type(action.command) == "table" then
        vim.lsp.buf.execute_command(action.command)
      end
    else
      vim.lsp.buf.execute_command(action)
    end
  end

local sumneko_binary_path = vim.fn.exepath("lua-language-server")
if vim.g.is_mac or vim.g.is_linux and sumneko_binary_path ~= "" then
  local sumneko_root_path = vim.fn.fnamemodify(sumneko_binary_path, ":h:h:h")

  local runtime_path = vim.split(package.path, ";")
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  require("lspconfig").sumneko_lua.setup({
    on_attach = custom_attach,
    cmd = { sumneko_binary_path, "-E", sumneko_root_path .. "/main.lua" },
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
    capabilities = capabilities,
  })
end

-- Change diagnostic signs.
vim.fn.sign_define("DiagnosticSignError", { text = "✗", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "!", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

-- global config for diagnostic
vim.diagnostic.config({
  underline = true,
  virtual_text = false,
  signs = true,
  severity_sort = true,
  update_in_insert = false,
})

--lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
--  underline = false,
--  virtual_text = false,
--  signs = true,
--  update_in_insert = false,
--})

-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})



-- nvim-lsputils plugin
-- local bufnr = vim.api.nvim_buf_get_number(0)
--
-- lsp.handlers['textDocument/codeAction'] = function(_, _, actions)
--     require('lsputil.codeAction').code_action_handler(nil, actions, nil, nil, nil)
-- end
--
-- lsp.handlers['textDocument/references'] = function(_, _, result)
--     require('lsputil.locations').references_handler(nil, result, { bufnr = bufnr }, nil)
-- end
--
-- lsp.handlers['textDocument/definition'] = function(_, method, result)
--     require('lsputil.locations').definition_handler(nil, result, { bufnr = bufnr, method = method }, nil)
-- end
--
-- lsp.handlers['textDocument/declaration'] = function(_, method, result)
--     require('lsputil.locations').declaration_handler(nil, result, { bufnr = bufnr, method = method }, nil)
-- end
--
-- lsp.handlers['textDocument/typeDefinition'] = function(_, method, result)
--     require('lsputil.locations').typeDefinition_handler(nil, result, { bufnr = bufnr, method = method }, nil)
-- end
--
-- lsp.handlers['textDocument/implementation'] = function(_, method, result)
--     require('lsputil.locations').implementation_handler(nil, result, { bufnr = bufnr, method = method }, nil)
-- end
--
-- lsp.handlers['textDocument/documentSymbol'] = function(_, _, result, _, bufn)
--     require('lsputil.symbols').document_handler(nil, result, { bufnr = bufn }, nil)
-- end
--
-- lsp.handlers['textDocument/symbol'] = function(_, _, result, _, bufn)
--     require('lsputil.symbols').workspace_handler(nil, result, { bufnr = bufn }, nil)
-- end

return M
