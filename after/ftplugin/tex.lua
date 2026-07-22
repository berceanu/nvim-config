-- Buffer-local settings for LaTeX files. Runs after VimTeX's own ftplugin.

local opt = vim.opt_local

-- Soft-wrap prose without inserting hard line breaks.
opt.wrap = true
opt.linebreak = true
opt.spell = true
opt.spelllang = { "en_us" }

-- Conceal maths/markup (\alpha → α, \\ hidden, etc.); reveal on the cursor line.
opt.conceallevel = 2
opt.concealcursor = ""

-- Treat wrapped display lines as real lines when moving with j/k.
vim.keymap.set({ "n", "x" }, "j", "gj", { buffer = true })
vim.keymap.set({ "n", "x" }, "k", "gk", { buffer = true })

-- Fix the word under the cursor to the first spelling suggestion.
vim.keymap.set("n", "<localleader>z", "1z=", { buffer = true, desc = "Fix spelling" })

-- VimTeX already provides the core maps under <localleader> (default `\`):
--   \ll  toggle continuous compilation      \lv  forward-search to the PDF
--   \lc  clean aux files                     \le  show the error list
--   \lt  table of contents                   \lk  stop compilation
--   \li  show compilation info
-- Text objects: ie/ae (environment), i$/a$ (math), id/ad (delimiter), etc.
-- Motions: ]] [[ (sections), ]m [m (environments).
