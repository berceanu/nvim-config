-- Native LSP (Neovim 0.11+). nvim-lspconfig only ships the server definitions
-- under lsp/; Neovim's built-in vim.lsp.enable drives them. Each server is
-- enabled only if its binary is installed, so nothing errors when one is absent.
--
-- Server installation stays outside Neovim. The dotfiles Linux core provides
-- Python, Fortran, Typst, Rust, and x86_64 clangd; the macOS research profile
-- adds the rolling research/editor tools. Julia uses the dedicated environment
-- created by scripts/setup-julia-lsp.sh. TypeScript projects keep TypeScript
-- itself project-local; only the small LSP wrapper is host-level.
--
-- Neovim 0.11 already provides the default LSP maps: K (hover), grn (rename),
-- gra (code action), grr (references), gri (implementation), ]d / [d, gO.

vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

local languages = require("config.languages")
for _, server in ipairs(languages.servers) do
  if languages.server_available(server) then
    vim.lsp.enable(server.name)
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLsp", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end
    -- As-you-type completion from the LSP (feeds the same <Tab> menu).
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
    -- Inlay hints (types / parameter names) — great for Rust and C++.
    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end
    vim.keymap.set("n", "<leader>cf", function()
      vim.lsp.buf.format()
    end, { buffer = ev.buf, desc = "Format buffer (LSP)" })
    vim.keymap.set("n", "<leader>ci", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
    end, { buffer = ev.buf, desc = "Toggle inlay hints" })
  end,
})
