return {
  { 'nvim-lua/plenary.nvim', name = 'plenary' },
  {
    'Exafunction/codeium.nvim',
    config = function()
      require("codeium").setup({})
    end
  },
  'VonHeikemen/lsp-zero.nvim',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'mfussenegger/nvim-dap',
  'lommix/godot.nvim',
  'epheien/termdbg',
  'mattn/emmet-vim',
  'stevearc/conform.nvim',
}
