-- Global key mappings. Filetype-specific maps live in after/ftplugin/*.lua.
--
-- Note: Neovim 0.11+ ships default LSP/diagnostic maps out of the box —
-- K (hover), grn (rename), gra (code action), grr (references),
-- gri (implementation), ]d / [d (next/prev diagnostic), gO (document symbols).
-- We deliberately do not redefine those.

local map = vim.keymap.set

-- Escape insert mode with jj (kept from the previous config)
map("i", "jj", "<Esc>", { silent = true })

-- Disable accidental Ex mode
map("n", "Q", "<Nop>")

-- Move the current visual selection up/down, re-indenting as it goes
map("v", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true })

-- Diagnostics
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics → loclist" })

-- Leave terminal insert mode with Esc
map("t", "<Esc>", "<C-\\><C-n>")

-- Guard against the classic :W / :Q / :Wq typos (Shift held too long)
for _, c in ipairs({ "W", "Q", "Wq", "WQ", "Wa", "Qa" }) do
  vim.cmd(("cnoreabbrev %s %s"):format(c, c:lower()))
end
