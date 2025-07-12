return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")


      -- Ensure codelldb is installed
      -- I had to do this because mason refused to install it until I manually
      -- ran :Mason and hit "i" hovering on it.
      local codelldb_path = vim.fn.stdpath("data") .. "/mason/bin/codelldb"
      if vim.fn.executable(codelldb_path) == 0 then
        vim.notify("codelldb not found! Installing via Mason...", vim.log.levels.WARN)
        vim.cmd("MasonInstall codelldb")
      end

      -- Common adapter configuration for Rust/C/C++
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      -- Rust configuration
      dap.configurations.rust = {
        {
          name = "Launch Rust Debug",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      -- C/C++ configuration
      dap.configurations.cpp = {
        {
          name = "Launch C++ Debug",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
          -- Uncomment if you use CMake:
          -- program = function()
          --   local cwd = vim.fn.getcwd()
          --   local build_type = vim.fn.input("Build type [Debug/Release]: ", "Debug")
          --   return cwd .. "/build/" .. (build_type or "Debug") .. "/app"
          -- end,
        },
      }
      -- Share C++ config with C
      dap.configurations.c = dap.configurations.cpp

      -- Configure DAP UI
      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
        },
      })

      -- Auto-open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close

      -- Debug keymaps
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step Out" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run Last" })
      vim.keymap.set("n", "<leader>dq", dap.close, { desc = "Quit Debugger" })
    end
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "codelldb",       -- Debugger for Rust/C/C++
        "cpptools",       -- C/C++ language server (optional)
        "clangd",         -- C/C++ language server (optional)
      }
    }
  }
}
