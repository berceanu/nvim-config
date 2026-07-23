-- smart-splits.nvim — seamless Ctrl-hjkl movement between Neovim splits and
-- tmux panes. At a split edge it hands off to the adjacent tmux pane; the tmux
-- side (an is_vim guard in tmux.conf) passes Ctrl-hjkl back to Neovim when nvim
-- is focused. Normal-mode only, so it never clashes with LuaSnip's insert-mode
-- <C-h/j/k> jumps (plugin/30luasnip.lua).

vim.pack.add({ "https://github.com/mrjones2014/smart-splits.nvim" })

local ss = require("smart-splits")
vim.keymap.set("n", "<C-h>", ss.move_cursor_left,  { desc = "Go to left split / tmux pane" })
vim.keymap.set("n", "<C-j>", ss.move_cursor_down,  { desc = "Go to below split / tmux pane" })
vim.keymap.set("n", "<C-k>", ss.move_cursor_up,    { desc = "Go to above split / tmux pane" })
vim.keymap.set("n", "<C-l>", ss.move_cursor_right, { desc = "Go to right split / tmux pane" })
