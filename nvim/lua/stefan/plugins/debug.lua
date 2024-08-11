return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup()
    require('dap-python').setup()
    require('dap-go').setup()

    -- custom adapter for running tasks before starting debug
    local custom_adapter = 'pwa-node-custom'
    dap.adapters[custom_adapter] = function(cb, config)
      if config.preLaunchTask then
        local async = require 'plenary.async'
        local notify = require('notify').async

        async.run(function()
          ---@diagnostic disable-next-line: missing-parameter
          notify('Running [' .. config.preLaunchTask .. ']').events.close()
        end, function()
          vim.fn.system(config.preLaunchTask)
          config.type = 'pwa-node'
          dap.run(config)
        end)
      end
    end
    -- language config
    for _, language in ipairs { 'typescript', 'javascript' } do
      dap.configurations[language] = {
        {
          name = 'Launch',
          type = 'pwa-node',
          request = 'launch',
          program = '${file}',
          rootPath = '${workspaceFolder}',
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          skipFiles = { '<node_internals>/**' },
          protocol = 'inspector',
          console = 'integratedTerminal',
        },
        {
          name = 'Attach to node process',
          type = 'pwa-node',
          request = 'attach',
          rootPath = '${workspaceFolder}',
          processId = require('dap.utils').pick_process,
        },
        {
          name = 'Debug Main Process (Electron)',
          type = 'pwa-node',
          request = 'launch',
          program = '${workspaceFolder}/node_modules/.bin/electron',
          args = {
            '${workspaceFolder}/dist/index.js',
          },
          outFiles = {
            '${workspaceFolder}/dist/*.js',
          },
          resolveSourceMapLocations = {
            '${workspaceFolder}/dist/**/*.js',
            '${workspaceFolder}/dist/*.js',
          },
          rootPath = '${workspaceFolder}',
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          skipFiles = { '<node_internals>/**' },
          protocol = 'inspector',
          console = 'integratedTerminal',
        },
        {
          name = 'Compile & Debug Main Process (Electron)',
          type = custom_adapter,
          request = 'launch',
          preLaunchTask = 'npm run build-ts',
          program = '${workspaceFolder}/node_modules/.bin/electron',
          args = {
            '${workspaceFolder}/dist/index.js',
          },
          outFiles = {
            '${workspaceFolder}/dist/*.js',
          },
          resolveSourceMapLocations = {
            '${workspaceFolder}/dist/**/*.js',
            '${workspaceFolder}/dist/*.js',
          },
          rootPath = '${workspaceFolder}',
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          skipFiles = { '<node_internals>/**' },
          protocol = 'inspector',
          console = 'integratedTerminal',
        },
      }
    end

    vim.keymap.set('n', '<leader>do', dapui.open, { desc = 'Debug: Start Ui' })
    vim.keymap.set('n', '<leader>dc', dapui.close, { desc = 'Debug: Stop Ui' })
    vim.keymap.set('n', '<leader>dt', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F7>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F8>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F9>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F6>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

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
