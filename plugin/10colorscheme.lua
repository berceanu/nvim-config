-- Colour scheme: Catppuccin (Mocha), carried over from the previous config.

vim.pack.add({
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
})

require("catppuccin").setup({
  flavour = "mocha",
  integrations = {
    blink_cmp = true,
    native_lsp = { enabled = true },
    nvim_surround = true,
  },
})

vim.cmd.colorscheme("catppuccin-mocha")
