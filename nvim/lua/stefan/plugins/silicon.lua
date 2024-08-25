return {
  'michaelrommel/nvim-silicon',
  config = function()
    local nsilicon = require 'nvim-silicon'

    vim.keymap.set('v', '<leader>sc', function()
      nsilicon.clip()
    end, { desc = '[S]naspshot code' })
    require('silicon').setup {
      disable_defaults = false,
      window_title = function()
        return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()), ':t')
      end,

      line_offset = function(args)
        return args.line1
      end,
    }
  end,
}
