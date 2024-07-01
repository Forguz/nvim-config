-- Linter
local nvim_lint = require("lint")
nvim_lint.linters_by_ft = {
  javascript = { 'eslint' },
  javascriptreact = { 'eslint' },
  typescript = { 'eslint' },
  typescriptreact = { 'eslint' },
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true });

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    nvim_lint.try_lint(nil, { ignore_errors = true })
  end,
})
