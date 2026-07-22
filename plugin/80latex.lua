-- VimTeX — the LaTeX plugin: compilation (latexmk), PDF viewing with
-- forward/inverse search, motions, text objects, and completion data.
--
-- IMPORTANT: every vim.g.vimtex_* option must be set BEFORE the plugin loads,
-- i.e. before vim.pack.add() at the bottom of this file.

-- Treat plain .tex files as LaTeX.
vim.g.tex_flavor = "latex"

-- Use LuaSnip for insert-mode expansions instead of VimTeX's built-in imaps.
vim.g.vimtex_imaps_enabled = 0

-- Compiler: latexmk by default (continuous, -synctex=1 for forward/inverse
-- search). On a host with no TeX distribution but tectonic available (e.g. a
-- headless Linux box), fall back to tectonic — a self-contained LaTeX engine.
if vim.fn.executable("latexmk") == 0 and vim.fn.executable("tectonic") == 1 then
  vim.g.vimtex_compiler_method = "tectonic"
else
  vim.g.vimtex_compiler_method = "latexmk"
end

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
-- PDF viewer. Skim on macOS (configure once with scripts/setup-skim.sh). On
-- Linux/remote there's usually no viewer, so fall back to the generic one —
-- VimTeX still loads fine; only \lv is inert on a headless box.
-- ---------------------------------------------------------------------------
if vim.fn.has("mac") == 1 then
  vim.g.vimtex_view_method = "skim"
  vim.g.vimtex_view_skim_sync = 1 -- forward-search to Skim after each compile
  vim.g.vimtex_view_skim_activate = 1 -- bring Skim to the foreground on view
  vim.g.vimtex_view_skim_reading_bar = 1 -- highlight the synced line in Skim
else
  vim.g.vimtex_view_method = "general"
end

-- Load the plugin.
vim.pack.add({ "https://github.com/lervag/vimtex" })
