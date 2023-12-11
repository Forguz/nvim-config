require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    javascript = { { "prettierd", "prettier" } },
    javascriptreact = { { "prettierd", "prettier" } },
    typescript = { { "prettierd", "prettier" } },
    typescriptreact = { { "prettierd", "prettier" } },
    markdown = { { "prettierd", "prettier" } },
    mdx = { { "prettierd", "prettier" } },
    json = { { "prettierd", "prettier" } },
    css = { { "prettierd", "prettier" } },
    html = { { "prettierd", "prettier" } },
    c = { "clang_format" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})
