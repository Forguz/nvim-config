return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    local ts = require("nvim-treesitter")

    ts.setup()

    -- In the new version, use ts.install instead of ensure_installed in setup.
    -- This is a no-op if the parsers are already installed.
    ts.install({
      "javascript",
      "typescript",
      "c",
      "lua",
      "vim",
      "vimdoc",
      "query",
      "markdown",
      "yaml",
      "markdown_inline",
      "svelte",
      "html",
      "css",
    })

    -- Highlighting must be enabled manually in the new version.
    vim.api.nvim_create_autocmd('FileType', {
      callback = function()
        local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
        if lang then
          pcall(vim.treesitter.start)
        end
      end,
    })
  end
}
