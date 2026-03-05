return {
  "stevearc/conform.nvim",
  lazy = false,
  event = { "BufWritePre" },
  cmd = { "ConformInfo", "ConformFormat" },
  config = function()
    local conform = require("conform")

    -- FIXED: Use vim.fs.find to safely check for config files
    local function get_js_formatter(bufnr)
      local bufname = vim.api.nvim_buf_get_name(bufnr)

      -- If the buffer doesn't have a name (e.g., new file), check the current working directory
      local path = vim.fn.fnamemodify(bufname, ":p:h")
      if bufname == "" then
        path = vim.fn.getcwd()
      end

      -- Search upward for biome.json or biome.jsonc
      local biome_config = vim.fs.find({ "biome.json", "biome.jsonc" }, {
        upward = true,
        path = path,
        type = "file",
      })

      -- If found, use Biome
      if #biome_config > 0 then
        return { "biome" }
      end

      -- Otherwise, fallback to Prettier/ESLint
      return { "prettierd", "eslint_d" }
    end

    conform.setup({
      format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 1000,
      },

      -- Customize Biome args if needed
      formatters = {
        biome = {
          args = { "check", "--write", "--stdin-file-path", "$FILENAME" },
        },
      },

      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        c = { "clang_format" },
        vue = { "prettierd" },
        svelte = { "prettierd", "eslint_d" },

        -- Use the dynamic function here
        javascript = get_js_formatter,
        typescript = get_js_formatter,
        javascriptreact = get_js_formatter,
        typescriptreact = get_js_formatter,
        json = get_js_formatter,
        css = get_js_formatter,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_format = "fallback",
        timeout_ms = 1000,
      })
    end)
  end,
}
