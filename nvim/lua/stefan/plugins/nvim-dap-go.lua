return {
  'leoluz/nvim-dap-go',
  ft = 'go',
  dependencies = 'mfussenegger/nvim-dap',
  opts = {
    delve = {
      detached = false,
    },
  },
  config = function(_, opts)
    local dapGo = require 'dap-go'
    vim.keymap.set('n', '<leader>dGt', dapGo.debug_test, { desc = 'Go Debug Test' })
    require('dap').set_log_level 'TRACE'
    dapGo.setup(opts)
  end,
}
