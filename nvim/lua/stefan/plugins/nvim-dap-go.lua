return {
  'leoluz/nvim-dap-go',
  ft = 'go',
  dependencies = 'mfussenegger/nvim-dap',
  keys = {
    {
      '<leader>dGs',
      function()
        require('dap-go').continue()
      end,
      desc = 'Go Debug Mode',
      ft = 'go',
    },
    {
      '<leader>dGt',
      function()
        require('dap-go').debug_test()
      end,
      desc = 'Go Debug Test',
      ft = 'go',
    },
  },
  config = function(_, opts)
    require('dap-go').setup(opts)
  end,
}
