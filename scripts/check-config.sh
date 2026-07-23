#!/usr/bin/env bash
# Read-only, headless validation. Run prewarm.sh first so plugins and parsers
# already exist; this command deliberately refuses an incomplete plugin set.
set -euo pipefail

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUN_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/nvim-config-check.XXXXXX")"
DATA_ROOT="${XDG_DATA_HOME:-$HOME/.local/share}"
PLUGIN_ROOT="$DATA_ROOT/nvim/site/pack/core/opt"
trap 'rm -rf "$RUN_ROOT"' EXIT

while IFS= read -r plugin; do
  [ -d "$PLUGIN_ROOT/$plugin" ] || {
    echo "missing locked plugin $plugin; run ~/.dotfiles/prewarm.sh" >&2
    exit 1
  }
done < <(sed -n 's/^    "\([^"]*\)": {$/\1/p' "$CONFIG_DIR/nvim-pack-lock.json")

mkdir -p "$RUN_ROOT/config" "$RUN_ROOT/cache" "$RUN_ROOT/state" "$RUN_ROOT/runtime"
chmod 700 "$RUN_ROOT/runtime"
ln -s "$CONFIG_DIR" "$RUN_ROOT/config/nvim"

env -u TERM_PROGRAM -u TMUX -u TMUX_PANE \
  XDG_CONFIG_HOME="$RUN_ROOT/config" \
  XDG_CACHE_HOME="$RUN_ROOT/cache" \
  XDG_STATE_HOME="$RUN_ROOT/state" \
  XDG_RUNTIME_DIR="$RUN_ROOT/runtime" \
  NVIM_CONFIG_CHECK=1 \
  nvim --headless \
    "+lua local ok, err = pcall(require('config.health').check); if not ok then vim.api.nvim_err_writeln(err); vim.cmd('cquit 1') end" \
    "+qa!"

# Exercise typst-preview with fake, explicitly supplied host binaries and an
# isolated data root. Any executable below typst-preview means the plugin
# downloaded a hidden dependency.
mkdir -p "$RUN_ROOT/bin" "$RUN_ROOT/data/nvim/site/pack/core"
printf '#!/bin/sh\nexit 0\n' > "$RUN_ROOT/bin/tinymist"
printf '#!/bin/sh\nexit 0\n' > "$RUN_ROOT/bin/websocat"
chmod 700 "$RUN_ROOT/bin/tinymist" "$RUN_ROOT/bin/websocat"
ln -s "$PLUGIN_ROOT" "$RUN_ROOT/data/nvim/site/pack/core/opt"

env -u TERM_PROGRAM -u TMUX -u TMUX_PANE \
  PATH="$RUN_ROOT/bin:$PATH" \
  XDG_CONFIG_HOME="$RUN_ROOT/config" \
  XDG_DATA_HOME="$RUN_ROOT/data" \
  XDG_CACHE_HOME="$RUN_ROOT/cache" \
  XDG_STATE_HOME="$RUN_ROOT/state" \
  XDG_RUNTIME_DIR="$RUN_ROOT/runtime" \
  NVIM_CONFIG_CHECK=1 \
  NVIM_TYPST_DEPENDENCY_CHECK=1 \
  nvim --headless \
    "+lua assert(vim.fn.exists(':TypstPreviewToggle') == 2, 'Typst preview did not initialize with explicit dependencies')" \
    "+qa!"

if find "$RUN_ROOT/data/nvim/typst-preview" -type f -perm -111 -print 2>/dev/null |
   grep -q .; then
  echo "typst-preview downloaded an executable despite explicit dependencies" >&2
  exit 1
fi
