#!/usr/bin/env bash
# Configure Skim.app for use with Neovim + VimTeX.
#
#   * Forward search  (Neovim -> Skim): handled by VimTeX's `skim` viewer,
#     no Skim setting needed beyond auto-reload below.
#   * Inverse search  (Skim -> Neovim): Cmd-Shift-Click in the PDF jumps to the
#     matching source line. Implemented via Skim's "PDF-TeX Sync" preset, which
#     we point at a headless nvim running :VimtexInverseSearch.
#
# Re-run any time; changes take effect after Skim is restarted.
set -euo pipefail

DOMAIN="net.sourceforge.skim-app.skim"

# Inverse search: custom preset -> headless nvim that locates the running
# instance editing the file and jumps to the clicked line.
defaults write "$DOMAIN" SKTeXEditorPreset -string ""
defaults write "$DOMAIN" SKTeXEditorCommand -string "nvim"
defaults write "$DOMAIN" SKTeXEditorArguments -string "--headless -c \"VimtexInverseSearch %line '%file'\""

# Auto-refresh the PDF when latexmk rewrites it, without a focus-stealing prompt.
defaults write "$DOMAIN" SKAutoReloadFileUpdate -bool true
defaults write "$DOMAIN" SKAutoCheckFileUpdate  -bool true

echo "Skim configured for Neovim inverse search."
echo "Restart Skim for the changes to take effect:"
echo "    osascript -e 'quit app \"Skim\"'   # then reopen"
