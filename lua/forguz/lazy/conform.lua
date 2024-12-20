return {
  'stevearc/conform.nvim',
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        c = { "clang_format" },
        html = {},
        css = { "prettier" },
        vue = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        gdscript = { "gdformat" }
      },
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 500,
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
  
