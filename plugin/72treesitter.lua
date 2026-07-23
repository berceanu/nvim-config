-- Tree-sitter via nvim-treesitter (main branch — vim.pack tracks the repo's
-- default branch cleanly). Parsers are built by the `tree-sitter` CLI (a single
-- managed binary: brew on macOS, ~/.local/bin on Linux). Highlighting only —
-- indentation stays native.

vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

local ok, ts = pcall(require, "nvim-treesitter")
if ok and ts.install and vim.fn.executable("tree-sitter") == 1 then
  local parsers = require("config.languages").parsers
  if vim.env.NVIM_CONFIG_CHECK ~= "1" then
    local install = ts.install(parsers, { max_jobs = 4 })
    if vim.env.NVIM_PREWARM == "1" then
      assert(install:wait(420000), "one or more Tree-sitter parsers failed to install")
      assert(
        ts.update(parsers, { max_jobs = 4, summary = true }):wait(420000),
        "one or more Tree-sitter parsers failed to update"
      )
    end
  end
end

-- Start highlighting in any buffer whose language has an installed parser.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
