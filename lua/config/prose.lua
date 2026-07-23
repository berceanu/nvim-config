-- Shared, quiet prose ergonomics for Markdown, reStructuredText, Typst, and
-- LaTeX. Language-specific conceal/compilation remains in its own ftplugin.

local M = {}

function M.setup()
  local opt = vim.opt_local
  opt.wrap = true
  opt.linebreak = true
  opt.textwidth = 0
  opt.spell = false
  opt.spelllang = { "en_us" }

  vim.keymap.set({ "n", "x" }, "j", "gj", { buffer = true })
  vim.keymap.set({ "n", "x" }, "k", "gk", { buffer = true })
  vim.keymap.set("n", "<localleader>ss", function()
    vim.wo.spell = not vim.wo.spell
    vim.notify("spell " .. (vim.wo.spell and "on" or "off"))
  end, { buffer = true, desc = "Toggle spell check" })
  vim.keymap.set("n", "<localleader>z", "1z=", {
    buffer = true,
    desc = "Fix spelling",
  })
end

return M
