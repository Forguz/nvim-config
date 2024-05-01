local lsp_zero = require("lsp-zero")
local lspconfig = require("lspconfig")
lsp_zero.preset('recommended')

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({ buffer = bufnr })
  -- disable buffer format for vue so conform can apply prettier
  if vim.bo.filetype ~= 'vue' then
    lsp_zero.buffer_autoformat()
  end
end)

lsp_zero.format_mapping('gq', {
  format_opts = {
    async = false,
    timeout_ms = 10000,
  },
  servers = {
    ['eslint'] = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
    ['rust_analyzer'] = { 'rust' },
  }
})

lsp_zero.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = '⚑',
  info = '»',
})

require('mason').setup({
  ensure_installed = { 'prettier', 'prettierd' }
})

require('mason-lspconfig').setup({
  ensure_installed = { 'tsserver', 'emmet_language_server', 'clangd', 'eslint', 'cssmodules_ls', 'lua_ls', 'tailwindcss', 'rust_analyzer', 'volar' },
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      lspconfig.lua_ls.setup(lua_opts)
    end,
    eslint = function()
      lspconfig.eslint.setup {}
    end,
  }
})
lspconfig.gdscript.setup {}

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'eslint' },
    { name = 'codeium' }
  },
  formatting = lsp_zero.cmp_format(),
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
})
