-- Native LSP (Neovim 0.11+). nvim-lspconfig only ships the server definitions
-- under lsp/; Neovim's built-in vim.lsp.enable drives them. Each server is
-- enabled only if its binary is installed, so nothing errors when one is absent.
--
-- Install the servers yourself (outside this config), e.g.:
--   Python: pip install basedpyright ruff   (or: uv tool install …)
--   Typst:  brew install tinymist  /  cargo install tinymist
--
-- Neovim 0.11 already provides the default LSP maps: K (hover), grn (rename),
-- gra (code action), grr (references), gri (implementation), ]d / [d, gO.

vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

local servers = {
  basedpyright = "basedpyright-langserver", -- Python: types, hover, completion
  ruff = "ruff", -- Python: lint + format (fast)
  tinymist = "tinymist", -- Typst: LSP
}
for name, bin in pairs(servers) do
  if vim.fn.executable(bin) == 1 then
    vim.lsp.enable(name)
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLsp", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    -- As-you-type completion from the LSP (feeds the same <Tab> menu).
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
    vim.keymap.set("n", "<leader>cf", function()
      vim.lsp.buf.format()
    end, { buffer = ev.buf, desc = "Format buffer (LSP)" })
  end,
})
