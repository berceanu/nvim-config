-- fzf-lua — fast fuzzy finder (files, grep, buffers, help). Uses the fzf
-- binary you already have. Restores the <leader>f… maps from the old config.

vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })

require("fzf-lua").setup({})

local map = vim.keymap.set
map("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>FzfLua help_tags<cr>", { desc = "Help tags" })
map("n", "<leader>fr", "<cmd>FzfLua resume<cr>", { desc = "Resume last picker" })
