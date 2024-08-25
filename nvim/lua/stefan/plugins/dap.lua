return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    return {
      { '<leader>dc', dap.continue, desc = 'Debug: Start/Continue' },
      {
        '<leader>dPt',
        function()
          require('dap-python').test_method()
        end,
        desc = 'Debug Method',
        ft = 'python',
      },
      {
        '<leader>dPc',
        function()
          require('dap-python').test_class()
        end,
        desc = 'Debug Class',
        ft = 'python',
      },
      { '<leader>dsi', dap.step_into, desc = 'Debug: Step Into' },
      { '<leader>dso', dap.step_over, desc = 'Debug: Step Over' },
      { '<leader>dsO', dap.step_out, desc = 'Debug: Step Out' },
      { '<leader>db', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
      {
        '<leader>dB',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },
      { '<F7>', dapui.toggle, desc = 'Debug: See last session result.' },
      unpack(keys),
    }
  end,

  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    dapui.setup()
    require('dap-go').setup {
      dap_configurations = {
        {
          type = 'go',
          name = 'Attach remote',
          mode = 'remote',
          request = 'attach',
        },
      },
      delve = {
        path = 'dlv',
        initialize_timeout_sec = 20,
        port = '${port}',
        args = {},
        build_flags = {},
        detached = vim.fn.has 'win32' == 0,
        cwd = nil,
      },
      tests = {
        verbose = false,
      },
    }
    require('dap-python').setup '/opt/homebrew/bin/python3'

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
  end,
}
