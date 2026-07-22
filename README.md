# nvim-config

A LaTeX-focused Neovim configuration. Pure Lua, no external plugin manager —
plugins are managed by the built-in [`vim.pack`](https://neovim.io/doc/user/pack.html)
(Neovim **0.12+**).

Based on the [Sussman Lab (Neo)vim + LaTeX guide](https://www.dmsussman.org/resources/vimandlatex/)
and Elijan Mastnak's [Vim + LaTeX series](https://ejmastnak.com/tutorials/vim-latex/intro/),
adapted for macOS + Skim.

## Requirements

- Neovim ≥ 0.12
- A TeX distribution with `latexmk` (MacTeX / TeX Live)
- [Skim.app](https://skim-app.sourceforge.io/) as the PDF viewer

Pure Lua — **no compilers or build tools required**. Every plugin is Lua-only.

## Layout

```
init.lua                  enables the module cache; entry point is plugin/
plugin/                   auto-sourced at startup, in filename order
  00options.lua           options + leader keys (must load first)
  02autocmds.lua          general autocommands
  03keymaps.lua           global key maps
  10colorscheme.lua       catppuccin
  20oil.lua               oil.nvim file explorer  (press -)
  30luasnip.lua           LuaSnip snippet engine
  40surround.lua          nvim-surround
  50completion.lua        native completion ergonomics (Tab-driven, no plugin)
  60whichkey.lua          which-key
  62fzflua.lua            fzf-lua finder
  64gitsigns.lua          gitsigns
  66nabla.lua             nabla (math preview)
  70statusline.lua        native Lua statusline (no plugin)
  80latex.lua             VimTeX (set BEFORE loading; Skim viewer)
after/ftplugin/
  tex.lua                 spell, conceal, soft-wrap, local maps
  bib.lua                 BibTeX buffer settings
lua/luasnip/
  all.lua                 global snippets
  tex.lua                 LaTeX snippets (math-aware autosnippets)
scripts/
  setup-skim.sh           configure Skim for inverse search (run once)
```

## First launch

1. `nvim` — `vim.pack` clones every plugin on the first start. Nothing to
   compile; restart once cloning finishes.
2. Configure Skim for inverse search (once):
   ```sh
   ~/.config/nvim/scripts/setup-skim.sh
   osascript -e 'quit app "Skim"'   # then reopen Skim
   ```
   In Skim → Settings → Sync you should now see the preset command `nvim`.

## LaTeX workflow (localleader is `\`)

| Key        | Action                                   |
|------------|------------------------------------------|
| `\ll`      | toggle continuous compilation (latexmk)  |
| `\lv`      | forward-search: jump Skim to the cursor  |
| `\lc`      | clean auxiliary files                    |
| `\le`      | show the error/warning list              |
| `\lt`      | table of contents                        |
| `\lk`      | stop compilation                         |
| `Cmd-Shift-Click` in Skim | inverse-search back to the source line |

Text objects: `ie`/`ae` (environment), `i$`/`a$` (maths), `id`/`ad`
(delimiter). Motions: `]]`/`[[` (sections), `]m`/`[m` (environments).

### Snippets

Math-aware, expanded by [LuaSnip](https://github.com/L3MON4D3/LuaSnip). A few
examples (see `lua/luasnip/tex.lua` for the full list, edit and reload with
`<leader>L`):

| Trigger | Expands to            | Where        |
|---------|-----------------------|--------------|
| `mk`    | `$…$`                 | outside math |
| `dm`    | display-math block    | outside math |
| `//`    | `\frac{…}{…}`         | inside math  |
| `beg`   | `\begin{}…\end{}`     | line start   |
| `;a`    | `\alpha` (`;b` → β …) | inside math  |

## Completion (native — no plugin)

Completion comes from Neovim itself: VimTeX sets `omnifunc` in `.tex` buffers
(`\cite`, `\ref`, environments, files) and LuaSnip handles snippets.

`<Tab>` open completion / next item / expand-jump snippet · `<S-Tab>` previous ·
`<C-Space>` force the omni menu · `<CR>` confirm · `<C-k>`/`<C-j>` snippet
expand/jump. Add an LSP later and `vim.lsp.completion.enable({autotrigger=true})`
gives an as-you-type popup with zero plugins.

## Managing plugins

- `:lua vim.pack.update()` — update all plugins (opens a confirmable diff)
- `:lua =vim.pack.get()` — list installed plugins
- Add one: put `vim.pack.add({ "https://github.com/owner/repo" })` in a
  `plugin/*.lua` file, then restart.

The previous lazy.nvim configuration is preserved on the `archive/lazy-nvim`
git branch.
