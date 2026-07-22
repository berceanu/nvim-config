-- VimTeX — the LaTeX plugin: compilation (latexmk), PDF viewing with
-- forward/inverse search, motions, text objects, and completion data.
--
-- IMPORTANT: every vim.g.vimtex_* option must be set BEFORE the plugin loads,
-- i.e. before vim.pack.add() at the bottom of this file.

-- Treat plain .tex files as LaTeX.
vim.g.tex_flavor = "latex"

-- Use LuaSnip for insert-mode expansions instead of VimTeX's built-in imaps.
vim.g.vimtex_imaps_enabled = 0

-- Compiler: latexmk (the default) runs continuously and re-typesets on save,
-- passing -synctex=1 so forward/inverse search work.
vim.g.vimtex_compiler_method = "latexmk"

-- Don't auto-open the quickfix window on warnings; :VimtexErrors shows it.
vim.g.vimtex_quickfix_mode = 0
-- Suppress the noisiest, usually-harmless latex warnings.
vim.g.vimtex_quickfix_ignore_filters = {
  "Underfull \\\\hbox",
  "Overfull \\\\hbox",
  "LaTeX Warning: .\\+ float specifier changed to",
  "Package hyperref Warning: Token not allowed in a PDF string",
}

-- ---------------------------------------------------------------------------
-- PDF viewer: Skim (macOS). Configure it once for inverse search with:
--   scripts/setup-skim.sh   (sets Skim's PDF-TeX Sync preset to Neovim)
-- ---------------------------------------------------------------------------
vim.g.vimtex_view_method = "skim"
vim.g.vimtex_view_skim_sync = 1 -- forward-search to Skim after each compile
vim.g.vimtex_view_skim_activate = 1 -- bring Skim to the foreground on view
vim.g.vimtex_view_skim_reading_bar = 1 -- highlight the synced line in Skim

-- Load the plugin.
vim.pack.add({ "https://github.com/lervag/vimtex" })
