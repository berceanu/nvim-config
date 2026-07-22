-- oil.nvim — edit the filesystem like a normal buffer. Replaces netrw.
-- Press `-` to open the parent directory of the current file.

vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

require("oil").setup({
  view_options = { show_hidden = true },
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory (oil)" })
