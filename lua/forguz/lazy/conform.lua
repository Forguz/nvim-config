return {
  'stevearc/conform.nvim',
  lazy = false,
  event = { "BufWritePre" },
  cmd = { "ConformInfo", "ConformFormat" },
  config = function()
    local conform = require("conform")
    conform.setup({
      format_on_save = {
        lsp_format = true,
        timeout_ms = 500,
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        c = { "clang_format" },
        html = {},
        css = { "prettierd", "prettier" },
        vue = { "prettierd", "prettier" },
        typescript = { "biome", "prettierd", "prettier" },
        typescriptreact = { "biome", "prettierd", "prettier" },
        javascript = { "biome", "prettierd", "prettier" },
        javascriptreact = { "biome", "prettierd", "prettier" },
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_fallback = true,
        timeout_ms = 500,
      })
    end)
  end
}
