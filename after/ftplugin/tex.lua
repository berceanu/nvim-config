-- Buffer-local settings for LaTeX files. Runs after VimTeX's own ftplugin.

local opt = vim.opt_local

require("config.prose").setup()

-- Conceal maths/markup (\alpha → α, \\ hidden, etc.); reveal on the cursor line.
opt.conceallevel = 2
opt.concealcursor = ""

-- VimTeX already provides the core maps under <localleader> (default `\`):
--   \ll  toggle continuous compilation      \lv  forward-search to the PDF
--   \lc  clean aux files                     \le  show the error list
--   \lt  table of contents                   \lk  stop compilation
--   \li  show compilation info
-- Text objects: ie/ae (environment), i$/a$ (math), id/ad (delimiter), etc.
-- Motions: ]] [[ (sections), ]m [m (environments).
