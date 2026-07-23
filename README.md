# nvim-config

A compact Neovim configuration for scientific software and technical writing.
It uses Neovim’s native `vim.pack`, LSP, completion, diagnostics, statusline,
and filetype support instead of plugin-manager, completion, lint, formatter, or
task-runner frameworks.

## Design

The 13 locked plugins have bounded roles:

| Role | Packages |
|---|---|
| parsing and language intelligence | `nvim-treesitter`, `nvim-lspconfig` |
| search, Git, and files | `fzf-lua`, `gitsigns.nvim`, `oil.nvim` |
| technical writing | `vimtex`, `LuaSnip`, `typst-preview.nvim`, `nabla.nvim` |
| editing ergonomics | `nvim-surround`, `smart-splits.nvim`, `which-key.nvim` |
| appearance | `catppuccin` |

There is deliberately no Mason, `nvim-cmp`, Conform, `nvim-lint`, DAP,
Neotest, terminal, project, or build-runner plugin. Host package profiles own
language executables; project lockfiles and build systems own project tools.

## Requirements

- Neovim 0.12 or newer
- `tree-sitter` CLI 0.26.1 or newer, a C compiler, `tar`, and `curl` to build
  the parsers selected by the locked `nvim-treesitter` checkout
- `fzf` and `rg` for finders

Language services activate only when their executable and, for Julia, its
dedicated environment are present:

| Files | Service | Host prerequisite |
|---|---|---|
| Python | basedpyright + Ruff | `basedpyright-langserver`, `ruff` |
| Fortran | fortls | `fortls`; add a project `.fortls` when includes or preprocessing need help |
| C, C++, CUDA | clangd | `clangd` and a project `compile_commands.json` |
| Rust | rust-analyzer | `rust-analyzer` |
| Julia | LanguageServer.jl | `julia` plus `scripts/setup-julia-lsp.sh` |
| JavaScript/TypeScript/TSX | typescript-language-server | host wrapper; projects pin their own `typescript` |
| Typst | tinymist | `tinymist` |

VimTeX uses `latexmk` when available and otherwise falls back to Tectonic.
Skim provides forward/inverse search on macOS.

Typst live preview is enabled only on a graphical host with both `tinymist` and
`websocat` in `PATH`. Both paths are passed explicitly, so the plugin never
downloads executables. Headless hosts retain Typst parsing, completion,
diagnostics, and formatting without initializing browser-preview machinery.

## Layout

```text
init.lua                    module cache and architecture notes
plugin/                     ordered options, mappings, and package setup
after/ftplugin/             prose, TeX, Typst, Markdown, RST, and BibTeX settings
lua/config/languages.lua    single parser/LSP/language-matrix inventory
lua/config/prose.lua        shared soft-wrap and opt-in spell behavior
lua/config/health.lua       headless language-matrix validation
lua/luasnip/                global and math-aware LaTeX snippets
julia-lsp/Project.toml      reviewed isolated Julia LSP environment
scripts/check-config.sh     read-only headless configuration test
scripts/setup-julia-lsp.sh  guarded Julia LSP bootstrap/update
scripts/setup-skim.sh       one-time Skim inverse-search setup
nvim-pack-lock.json         exact plugin commits
```

## Install and validate

The dotfiles repository owns the locked checkout and fleet workflow:

```sh
~/.dotfiles/prewarm.sh
~/.config/nvim/scripts/check-config.sh
nvim-plugin-check
```

Prewarm installs and updates every requested parser revision, then runs the
headless matrix check. That check validates filetype detection, parser loading,
all eight LSP definitions, and the complete locked plugin set.

Set up Julia once per host:

```sh
~/.config/nvim/scripts/setup-julia-lsp.sh
~/.config/nvim/scripts/setup-julia-lsp.sh --check
```

`--update` deliberately resolves newer compatible Julia packages. The script
refuses to replace a changed `Project.toml`.

Configure Skim once on macOS:

```sh
~/.config/nvim/scripts/setup-skim.sh
osascript -e 'quit app "Skim"'
```

## Project metadata

clangd is only as accurate as the compilation database. For CMake projects:

```sh
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
ln -s build/compile_commands.json compile_commands.json
```

For Make-based projects, run the real build through Bear:

```sh
bear -- make
```

Do not invent global flags in Neovim. Commit a project `.clangd` or `.fortls`
only when the build genuinely needs include paths, preprocessing, or
toolchain-specific options.

## Daily keys

| Key | Action |
|---|---|
| `<space>ff` / `fg` / `fb` | files / live grep / buffers |
| `K`, `grn`, `gra`, `grr`, `gri` | hover, rename, action, references, implementation |
| `]d` / `[d`, `<space>e` | diagnostics |
| `<space>cf` / `<space>ci` | LSP format / toggle inlay hints |
| `Tab`, `S-Tab`, `C-Space`, `Enter` | native completion |
| `<space>tp` | toggle Typst preview when its explicit prerequisites exist |
| `\ss` / `\z` | toggle spell checking / accept first correction in prose |

VimTeX keeps its standard local-leader workflow: `\ll` compile, `\lv` view,
`\lc` clean, `\le` errors, and `\lt` table of contents.

## Updating

Use `:lua vim.pack.update()` to review plugin updates. After accepting one,
refresh `nvim-pack-lock.json`, run prewarm and the headless check, commit this
repository, and then update the locked `nvim-config` commit in the dotfiles
repository. A dirty checkout is intentionally never reconciled automatically.
