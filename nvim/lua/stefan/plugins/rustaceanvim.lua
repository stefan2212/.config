return {
  'mrcjkb/rustaceanvim',
  version = '^6',
  lazy = false, -- must be loaded eagerly for filetype detection
  ft = { 'rust' },
  config = function()
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(_, bufnr)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
          end
          map('<leader>ca', function()
            vim.cmd.RustLsp 'codeAction'
          end, '[C]ode [A]ction')
          map('K', function()
            vim.cmd.RustLsp { 'hover', 'actions' }
          end, 'Hover Documentation')
          map('<leader>rr', function()
            vim.cmd.RustLsp 'runnables'
          end, '[R]ust [R]unnables')
          map('<leader>rd', function()
            vim.cmd.RustLsp 'debuggables'
          end, '[R]ust [D]ebuggables')
        end,
        default_settings = {
          ['rust-analyzer'] = {
            cargo = { allFeatures = true },
            checkOnSave = { command = 'clippy' },
            inlayHints = {
              lifetimeElisionHints = { enable = true, useParameterNames = true },
            },
          },
        },
      },
    }
  end,
}
