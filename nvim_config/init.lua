local function setup_clipboard()
  local is_wsl = vim.fn.has('wsl') == 1
  local is_linux = vim.fn.has('unix') == 1 and not is_wsl and not vim.fn.has('macunix')
  local has_display = os.getenv('DISPLAY') ~= nil


  -- WSL (Windows Subsystem for Linux)
  if is_wsl then
    if vim.fn.executable('win32yank.exe') == 1 then
      vim.g.clipboard = {
        name = 'WslClipboard',
        copy = {
          ['+'] = 'win32yank.exe -i --crlf',
          ['*'] = 'win32yank.exe -i --crlf'
        },
        paste = {
          ['+'] = 'win32yank.exe -o --lf',
          ['*'] = 'win32yank.exe -o --lf'
        },
        cache_enabled = true
      }
      vim.opt.clipboard = 'unnamedplus'
    else
      vim.notify("WSL: Install win32yank.exe for clipboard support", vim.log.levels.WARN)
    end

  -- Standard Linux (X11/Wayland)
  elseif is_linux then
    vim.opt.clipboard = 'unnamedplus'

    -- Only configure xclip/wl-clipboard if DISPLAY is available
    if has_display then
      local copy_cmd, paste_cmd

      if vim.fn.executable('wl-copy') == 1 then
        -- Wayland
        copy_cmd = 'wl-copy'
        paste_cmd = 'wl-paste -n'
      elseif vim.fn.executable('xclip') == 1 then
        -- X11
        copy_cmd = 'xclip -selection clipboard'
        paste_cmd = 'xclip -selection clipboard -o'
      end

      if copy_cmd and paste_cmd then
        vim.g.clipboard = {
          name = 'LinuxClipboard',
          copy = { ['+'] = copy_cmd, ['*'] = copy_cmd },
          paste = { ['+'] = paste_cmd, ['*'] = paste_cmd },
          cache_enabled = true
        }
      end
    else
      vim.notify("Linux: No DISPLAY available - xclip/wl-clipboard disabled", vim.log.levels.INFO)
    end

  -- macOS
  elseif vim.fn.has('macunix') == 1 then
    vim.opt.clipboard = 'unnamed'  -- uses pbcopy/pbpaste automatically

  -- Windows
  elseif vim.fn.has('win32') == 1 then
    vim.opt.clipboard = 'unnamed'  -- uses clip.exe automatically
  end
end

setup_clipboard()


-- Quick Scratch buffer
-- Initialize a counter for scratch buffers
local scratch_count = 0

-- Define the user command
vim.api.nvim_create_user_command("Scratch", function ()
  scratch_count = scratch_count + 1
  local buf_name = "Scratch " .. scratch_count

  -- create a new split window and buffer
  vim.cmd("split")
  local buf = vim.api.nvim_create_buf(false, true) -- unlisted, scrach buffer
  vim.api.nvim_win_set_buf(0, buf)

  -- set buffer name and filetype
  vim.api.nvim_buf_set_name(buf, buf_name)
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
end, {})


-- print to a new buffer .. I use this for debugging, so I can print stuff and actually see them
function Show_debug_in_scratch(lines)
  vim.cmd("new") -- open new split
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
end

vim.g.user = {
event = 'UserGroup',
config = {
	undodir = vim.fn.stdpath('cache') .. '/undo',
},
}

-- Next comes the stuff needed to restore the cursor to where it was when the file was closed last
vim.api.nvim_create_augroup(vim.g.user.event,{})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.g.user.event,
  callback = function(args)
    local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')
    local not_commit = vim.b[args.buf].filetype ~= 'commit'

    if valid_line and not_commit then
      vim.cmd([[normal! g`"]])
    end
  end,
})

-- The path here means ./config/home/settings
require("config.home.settings")
require("config.keymaps")
require("config.home.lazy")
