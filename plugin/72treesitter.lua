-- Tree-sitter via nvim-treesitter (main branch — vim.pack tracks the repo's
-- default branch cleanly). Parsers are built by the `tree-sitter` CLI (a single
-- managed binary: brew on macOS, ~/.local/bin on Linux). Highlighting only —
-- indentation stays native.

vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

local ok, ts = pcall(require, "nvim-treesitter")
if ok and ts.install and vim.fn.executable("tree-sitter") == 1 then
  -- Only languages Neovim does NOT already bundle. Nvim ships c, lua, markdown,
  -- markdown_inline, query, vim and vimdoc (parser + queries) in its runtime, so
  -- listing them here would just rebuild redundant copies.
  ts.install({
    "python", "rust", "cpp", "bash", "json", "yaml", "toml",
    "typst", "regex", "diff", "gitcommit",
    "fortran", "cuda", "cmake",   -- HPC: Flash-X, GPU kernels, WarpX/spack builds
  })
end

-- Start highlighting in any buffer whose language has an installed parser.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
