return {
  "rcarriga/nvim-notify",
  config = function ()
   vim.notify = require("notify")
   vim.notify.setup({
      stages = "fade_in_slide_out",
      timeout = 2000,
      background_colour = "#2E3440"
    })
  end
}
