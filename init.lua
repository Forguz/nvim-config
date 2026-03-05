vim.api.nvim_set_hl(0, 'Comment', { italic = true })
vim.filetype.add({
  extension = {
    svelte = "svelte",
  },
})

require("forguz")
