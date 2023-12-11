-- Linter
local nvim_lint = require("lint")
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    nvim_lint.try_lint()
  end,
})

nvim_lint.linters_by_ft = {
  javascript = { 'eslint' },
  javascriptreact = { 'eslint' },
  typescript = { 'eslint' },
  typescriptreact = { 'eslint' },
}
