-- Typst live preview. Completion/diagnostics/format come from the tinymist LSP
-- (enabled in 74lsp.lua when the `tinymist` binary is present). This plugin adds
-- an incrementally-updating browser preview — the Typst analogue of \lv for LaTeX.
--   <leader>tp   toggle the live preview
-- See https://myriad-dreamin.github.io/tinymist/frontend/neovim.html

vim.pack.add({ "https://github.com/chomosuke/typst-preview.nvim" })

require("typst-preview").setup({
  -- Reuse the tinymist binary already installed for the LSP instead of
  -- downloading a second copy.
  dependencies_bin = { ["tinymist"] = "tinymist" },
})

vim.keymap.set("n", "<leader>tp", "<cmd>TypstPreview<cr>", { desc = "Typst preview (toggle)" })
