return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
  },
  config = function()
    local lspconfig = require("lspconfig")
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    require("fidget").setup({})
    require('mason').setup({
      ensure_installed = {
        'prettier',
        'prettierd',
        'eslint_d',
      }
    })
    require('mason-lspconfig').setup({
      ensure_installed = {
        'ts_ls',
        'emmet_language_server',
        'clangd',
        'eslint',
        'cssmodules_ls',
        'lua_ls',
        'tailwindcss',
        'rust_analyzer',
        'biome',
        'svelte',
      },
      handlers = {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities
          }
        end,
        ts_ls = function()
          -- Create a copy of the base capabilities
          local ts_ls_capabilities = vim.deepcopy(capabilities)

          -- 🛑 DISABLE DOCUMENT FORMATTING
          ts_ls_capabilities.textDocument = ts_ls_capabilities.textDocument or {}

          lspconfig.ts_ls.setup {
            capabilities = ts_ls_capabilities,
            init_options = {
              preferences = {
                disableSuggestions = true, -- Disable TS suggestions in favor of LSP/Blink
              }
            },
            on_attach = function(client)
              client.server_capabilities.documentFormattingProvider = false
              client.server_capabilities.documentRangeFormattingProvider = false
            end
          }
        end,
        lua_ls = function()
          lspconfig.lua_ls.setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim", "it", "describe", "before_each", "after_each" },
                }
              }
            }
          }
        end,
        eslint = function()
          lspconfig.eslint.setup {
            capabilities = capabilities,
            on_attach = function(client)
              client.server_capabilities.documentFormattingProvider = false
              client.server_capabilities.documentRangeFormattingProvider = false
            end,
            settings = {
              experimental = {
                useFlatConfig = nil,
              },
            }
          }
        end,
      }
    })

    vim.keymap.set({ "n", "v" }, "<leader>mf", function()
      local ft = vim.bo.filetype
      local action_kind = "source.fixAll.biome"

      if ft == "svelte" then
        action_kind = "source.fixAll.eslint"
      end

      -- Check if the LSP function is loaded before calling it
      if vim.lsp and vim.lsp.buf and vim.lsp.buf.code_action then
        -- Trigger the LSP code action on the current buffer
        vim.lsp.buf.code_action({
          context = {
            only = { action_kind },
            isPreferred = true,
          },
          apply = true,
          timeout_ms = 2000, -- Use a generous timeout
        })
      else
        print("LSP functions not available yet.")
      end
    end, { desc = "LSP: Fix All (ESLint/Biome)" })

    vim.diagnostic.config({
      -- update_in_insert = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end
}
