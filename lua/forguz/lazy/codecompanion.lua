vim.schedule(function()
  vim.notify('GEMINI KEY STATUS: ' .. (os.getenv('GEMINI_API_KEY') and "LOADED" or "MISSING"))
end)

return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',                     -- Required utility functions
    'nvim-treesitter/nvim-treesitter',           -- Required for parsing
    'MeanderingProgrammer/render-markdown.nvim', -- (Optional, for better chat rendering)
  },
  config = function()
    require('codecompanion').setup({
      -- Your custom configuration goes here
      adapters = {
        gemini = function()
          return require('codecompanion.adapters').extend('gemini', {
            env = {
              -- This line automatically reads the GEMINI_API_KEY from your Windows Environment Variables
              api_key = os.getenv("GEMINI_API_KEY"),
            },
            schema = {
              model = {
                -- You can specify your preferred model here.
                -- 'gemini-2.5-flash' is a great default for speed and general coding tasks.
                default = "gemini-3-flash-preview",
              },
            },
          })
        end
      },
      strategies = {
        chat = {
          adapter = 'gemini',
        },
        inline = {
          adapter = 'gemini',
        },
      }
    })
  end,
}
