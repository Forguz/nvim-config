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
    local cmp = require('cmp')
    local cmp_lsp = require("cmp_nvim_lsp")
    local lspconfig = require("lspconfig")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities())

    require("fidget").setup({})
    require('mason').setup({
      ensure_installed = {
        'prettier',
        'prettierd',
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
        'biome'
      },
      handlers = {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities
          }
        end,
        ts_ls = function()
          -- Create a copy of the base capabilities
          local ts_ls_capabilities = vim.tbl_deep_extend("force", {}, capabilities)

          -- 🛑 DISABLE DOCUMENT FORMATTING
          ts_ls_capabilities.document_formatting = false
          ts_ls_capabilities.document_range_formatting = false

          -- All other ts_ls features (diagnostics, completions, etc.) remain active
          lspconfig.ts_ls.setup {
            capabilities = ts_ls_capabilities,
            -- ... other settings
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
          -- Create a copy of the base capabilities
          local eslint_capabilities = vim.tbl_deep_extend("force", {}, capabilities)

          -- 🛑 DISABLE DOCUMENT FORMATTING
          eslint_capabilities.document_formatting = false
          eslint_capabilities.document_range_formatting = false
          lspconfig.eslint.setup {
            capabilities = eslint_capabilities,
            settings = {
              experimental = {
                useFlatConfig = nil, -- option not in the latest eslint-lsp
              },
            }
          }
        end,
        biome = function()
          local on_attach = function(client)
            if not client or not client.resolved_capabilities then
              print("Biome client failed to initialize fully. Skipping on_attach.")
              return -- Exit the function early if capabilities are nil
            end
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = vim.api.nvim_create_augroup("LspBiomeFixAllOnSave", { clear = true }),
              -- Target files where Biome should run (adjust this list as needed)
              pattern = {
                "*.js", "*.jsx", "*.ts", "*.tsx", "*.json",
              },
              callback = function(args)
                -- Check if the Biome LSP client is available for the current buffer
                -- Trigger the Biome 'source.fixAll.biome' code action
                vim.lsp.buf.code_action({
                  bufnr = args.buf,
                  context = {
                    only = { "source.fixAll.biome" },
                    isPreferred = true,
                  },
                  apply = true,      -- Apply the changes immediately
                  timeout_ms = 2000, -- Time for the server to respond
                })
              end,
            })
          end

          lspconfig.biome.setup({
            capabilities = capabilities,
            on_attach = on_attach
          })
        end
      }
    })

    vim.keymap.set({ "n", "v" }, "<leader>mf", function()
      -- Check if the LSP function is loaded before calling it
      if vim.lsp and vim.lsp.buf and vim.lsp.buf.code_action then
        -- Trigger the Biome 'source.fixAll.biome' code action on the current buffer
        vim.lsp.buf.code_action({
          context = {
            only = { "source.fixAll.biome" },
            isPreferred = true,
          },
          apply = true,
          timeout_ms = 2000, -- Use a generous timeout
        })
      else
        print("LSP functions not available yet.")
      end
    end, { desc = "Biome: Fix All (LSP Code Action)" })

    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
      }, {
        { name = 'buffer' },
      })
    })
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
