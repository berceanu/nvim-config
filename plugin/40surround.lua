-- nvim-surround — add/change/delete surrounding pairs (quotes, brackets, LaTeX
-- environments, \command{...}). Lua rewrite of tpope's vim-surround.
--
--   ysiw$    surround a word with $…$
--   cs"'     change "…" to '…'
--   dst      delete the surrounding tag/\command
-- VimTeX also adds tex-aware surrounds; the two coexist fine.

vim.pack.add({ "https://github.com/kylechui/nvim-surround" })

require("nvim-surround").setup({})
