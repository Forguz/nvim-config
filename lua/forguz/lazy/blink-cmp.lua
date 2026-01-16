return {
  'saghen/blink.cmp',
  -- Use a release tag to download pre-built binaries
  version = '*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',

  -- If you use specific snippet plugins (like friendly-snippets), add them here
  dependencies = { 'rafamadriz/friendly-snippets' },

  opts = {
    -- 'default' preset matches your previous <C-y>, <C-n>, <C-p> behavior
    keymap = {
      preset        = 'none',
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-e>']     = { 'hide' },
      ['<C-y>']     = { 'select_and_accept' },
      ['<C-p>']     = { 'select_prev', 'fallback' },
      ['<C-n>']     = { 'select_next', 'fallback' },

      -- Scrolling docs (optional, if you want them)
      ['<C-b>']     = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>']     = { 'scroll_documentation_down', 'fallback' },
    },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono'
    },

    -- Default sources
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    -- Signature help (optional, similar to lsp_signature)
    signature = { enabled = true }
  },
}
