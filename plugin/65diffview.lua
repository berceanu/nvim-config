-- diffview — whole-branch and working-tree review. Gitsigns remains the
-- lightweight buffer-level tool; Diffview supplies the changed-file panel,
-- deleted-file visibility, history, and merge layouts.

vim.pack.add({ "https://github.com/sindrets/diffview.nvim" })

require("diffview").setup({
  use_icons = false,
})

vim.api.nvim_create_user_command("ReviewBranch", function(opts)
  require("config.review").open(opts.args)
end, {
  nargs = "?",
  desc = "Review HEAD against upstream/HEAD, origin/HEAD, or an explicit base",
})

local map = vim.keymap.set
map("n", "<leader>gv", "<cmd>ReviewBranch<cr>", { desc = "Review branch" })
map("n", "<leader>gu", "<cmd>DiffviewOpen<cr>", { desc = "Review uncommitted changes" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "Current file history" })
