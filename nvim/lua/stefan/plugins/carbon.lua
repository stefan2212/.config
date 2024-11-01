return {
  'ellisonleao/carbon-now.nvim',
  opts = {},
  config = function()
    vim.keymap.set('v', '<leader>sn', ':CarbonNow<CR>', { silent = true })
    local carbon = require 'carbon-now'
    carbon.setup {
      options = {},
    }
  end,
}
