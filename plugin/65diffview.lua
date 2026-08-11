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
  nargs = 1,
  desc = "Review HEAD against an explicit base revision",
})

local map = vim.keymap.set
map("n", "<leader>gv", ":ReviewBranch ", { desc = "Review branch against base" })
map("n", "<leader>gu", "<cmd>DiffviewOpen<cr>", { desc = "Review uncommitted changes" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "Current file history" })
