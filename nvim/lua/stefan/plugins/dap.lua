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
      delve = {},
      tests = {
        verbose = false,
      },
    }
    require('dap-python').setup '/opt/homebrew/bin/python3'
    vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = '#31353f' })
    vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#31353f' })
    vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '#31353f' })
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
