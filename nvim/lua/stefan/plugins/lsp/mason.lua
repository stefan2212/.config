return {
  'williamboman/mason.nvim',
  dependecies = {

    { 'williamboman/mason-lspconfig.nvim' },
    { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
  },
  cmd = { 'DapInstall', 'DapUninstall' },
  opt = {
    automatic_installation = true,
    handlers = {},
    ensure_installed = {
      -- Update this to ensure that you have the debuggers for the langs you want
    },
  },
  config = function()
    require('mason').setup()

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'prettier',
      'gopls',
      'pyright',
      'lua_ls',
      'yamlls',
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      ensure_installed = {
        'prettier',
        'gopls',
        'pyright',
        'lua_ls',
        'yamlls',
      },
    }
  end,
}
