-- gitsigns — inline git diff signs, hunk navigation and staging. Handy since
-- the papers live in git/Overleaf repos.

vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end
    map("n", "]h", function() gs.nav_hunk("next") end, "Next git hunk")
    map("n", "[h", function() gs.nav_hunk("prev") end, "Prev git hunk")
    map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
    map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk")
    map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
    map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
    map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
    map("n", "<leader>hd", gs.diffthis, "Diff this")
  end,
})
