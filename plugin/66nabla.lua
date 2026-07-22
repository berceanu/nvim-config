-- nabla — render the LaTeX math under the cursor as Unicode art. Pure Lua,
-- no external tools, works fine inside tmux.
--   <leader>m   peek at the formula under the cursor in a popup
--   <leader>M   toggle inline rendering of every equation in the buffer

vim.pack.add({ "https://github.com/jbyuki/nabla.nvim" })

vim.keymap.set("n", "<leader>m", function()
  require("nabla").popup()
end, { desc = "Preview math (nabla)" })

vim.keymap.set("n", "<leader>M", function()
  require("nabla").toggle_virt()
end, { desc = "Toggle inline math (nabla)" })
