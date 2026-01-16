return {
  'stevearc/conform.nvim',
  lazy = false,
  event = { "BufWritePre" },
  cmd = { "ConformInfo", "ConformFormat" },
  config = function()
    local conform = require("conform")

    conform.setup({
      format_on_save = {
        -- 'fallback': Use LSP formatting if no formatter is available
        -- 'never': Never use LSP for formatting (rely only on tools below)
        lsp_format = "fallback",
        timeout_ms = 1000, -- Biome is fast, but 500ms can sometimes be too tight
      },

      -- Define how Biome should behave
      formatters = {
        biome = {
          -- "check" with "--write" does formatting, organizes imports,
          -- and applies safe fixes (like removing unused variables).
          args = { "check", "--write", "--stdin-file-path", "$FILENAME" },
        },
      },

      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        c = { "clang_format" },
        html = {},
        vue = { "prettierd" },

        -- STRICTLY use Biome only. Removed Prettier to avoid conflicts.
        css = { "biome-check" }, -- Biome supports CSS, you could switch this too
        typescript = { "biome-check" },
        typescriptreact = { "biome-check" },
        javascript = { "biome-check" },
        javascriptreact = { "biome-check" },
        json = { "biome-check" },
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_format = "fallback",
        timeout_ms = 1000,
      })
    end)
  end
}
