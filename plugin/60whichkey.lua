-- which-key — popup cheatsheet of pending key sequences. Invaluable for
-- discovering VimTeX's many <localleader>l… maps: press `\` and wait.

vim.pack.add({ "https://github.com/folke/which-key.nvim" })

require("which-key").setup({
  preset = "modern",
  delay = 350,
})
