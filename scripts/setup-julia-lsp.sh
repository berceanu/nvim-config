#!/usr/bin/env bash
# Install or verify the isolated Julia environment expected by nvim-lspconfig.
set -euo pipefail

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE="$CONFIG_DIR/julia-lsp/Project.toml"
MODE=install

case "${1:-}" in
  "") ;;
  --check) MODE=check ;;
  --update) MODE=update ;;
  --help|-h)
    echo "usage: setup-julia-lsp.sh [--check|--update]"
    exit 0
    ;;
  *)
    echo "unknown option: $1" >&2
    exit 2
    ;;
esac

command -v julia >/dev/null 2>&1 || {
  echo "julia is required" >&2
  exit 1
}

DEPOT_ROOT="$(
  julia --startup-file=no --history-file=no -e 'print(first(DEPOT_PATH))'
)"
case "$DEPOT_ROOT" in
  /*) ;;
  *)
    echo "Julia returned an unsafe depot path: $DEPOT_ROOT" >&2
    exit 1
    ;;
esac
TARGET="$DEPOT_ROOT/environments/nvim-lspconfig"
PROJECT="$TARGET/Project.toml"

if [ "$MODE" = check ]; then
  [ -f "$PROJECT" ] || {
    echo "Julia LSP environment missing: $TARGET" >&2
    exit 1
  }
  cmp -s "$TEMPLATE" "$PROJECT" || {
    echo "Julia LSP Project.toml differs from the reviewed template" >&2
    exit 1
  }
  julia --startup-file=no --history-file=no --project="$TARGET" \
    -e 'using LanguageServer, SymbolServer, StaticLint'
  echo "Julia LSP environment OK: $TARGET"
  exit 0
fi

if [ -f "$PROJECT" ] && ! cmp -s "$TEMPLATE" "$PROJECT"; then
  echo "refusing to replace changed Julia LSP project: $PROJECT" >&2
  exit 1
fi
mkdir -p "$TARGET"
chmod 700 "$TARGET"
install -m 600 "$TEMPLATE" "$PROJECT"

if [ "$MODE" = update ]; then
  julia --startup-file=no --history-file=no --project="$TARGET" \
    -e 'using Pkg; Pkg.update(); Pkg.precompile()'
else
  julia --startup-file=no --history-file=no --project="$TARGET" \
    -e 'using Pkg; Pkg.instantiate(); Pkg.precompile()'
fi
echo "Julia LSP environment ready: $TARGET"
