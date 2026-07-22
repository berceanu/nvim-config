-- Native statusline — pure Lua, no plugin. Colours pulled from Catppuccin's
-- Mocha palette so it matches the theme (and the tmux bar). One global bar.

vim.opt.laststatus = 3 -- a single statusline for the whole UI (cleaner)
vim.opt.showmode = false -- the bar shows the mode, so hide the default -- INSERT --

-- Highlight groups, (re)built from the active Mocha palette.
local function set_highlights()
  local ok, palettes = pcall(require, "catppuccin.palettes")
  if not ok then
    return
  end
  local c = palettes.get_palette("mocha")
  local bg = c.mantle
  local set = vim.api.nvim_set_hl
  set(0, "StModeNormal", { fg = c.crust, bg = c.blue, bold = true })
  set(0, "StModeInsert", { fg = c.crust, bg = c.green, bold = true })
  set(0, "StModeVisual", { fg = c.crust, bg = c.mauve, bold = true })
  set(0, "StModeCommand", { fg = c.crust, bg = c.peach, bold = true })
  set(0, "StModeReplace", { fg = c.crust, bg = c.red, bold = true })
  set(0, "StModeTerminal", { fg = c.crust, bg = c.teal, bold = true })
  set(0, "StFill", { fg = c.text, bg = bg })
  set(0, "StGit", { fg = c.mauve, bg = bg })
  set(0, "StFile", { fg = c.text, bg = bg, bold = true })
  set(0, "StInfo", { fg = c.subtext0, bg = bg })
  set(0, "StErr", { fg = c.red, bg = bg })
  set(0, "StWarn", { fg = c.yellow, bg = bg })
  set(0, "StatusLine", { fg = c.text, bg = bg })
  set(0, "StatusLineNC", { fg = c.overlay0, bg = bg })
end

local mode_hl = {
  n = "StModeNormal", no = "StModeNormal",
  i = "StModeInsert", ic = "StModeInsert",
  v = "StModeVisual", V = "StModeVisual", ["\22"] = "StModeVisual",
  s = "StModeVisual", S = "StModeVisual",
  c = "StModeCommand", ["!"] = "StModeCommand",
  R = "StModeReplace", Rv = "StModeReplace",
  t = "StModeTerminal",
}
local mode_name = {
  n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE", ["\22"] = "V-BLOCK",
  c = "COMMAND", R = "REPLACE", t = "TERMINAL", s = "SELECT", S = "S-LINE",
}

function _G.Statusline()
  local m = vim.api.nvim_get_mode().mode
  local hl = mode_hl[m] or "StModeNormal"
  local name = mode_name[m] or m:upper()

  local left = ("%%#%s# %s %%#StFill# "):format(hl, name)

  local head = vim.b.gitsigns_head
  if head and head ~= "" then
    left = left .. ("%%#StGit#  %s %%#StFill# "):format(head)
  end
  left = left .. "%#StFile#%f%#StInfo#%m%r"

  local counts = vim.diagnostic.count(0)
  local right = ""
  local e = counts[vim.diagnostic.severity.ERROR] or 0
  local w = counts[vim.diagnostic.severity.WARN] or 0
  if e > 0 then
    right = right .. ("%%#StErr# E%d "):format(e)
  end
  if w > 0 then
    right = right .. ("%%#StWarn# W%d "):format(w)
  end
  right = right .. "%#StInfo# %{&filetype} %#StFill# %l:%c  %#StInfo#%P "

  return left .. "%#StFill#%=" .. right
end

set_highlights()
vim.o.statusline = "%!v:lua.Statusline()"

-- Rebuild colours if the colorscheme is reloaded.
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("UserStatusline", { clear = true }),
  callback = set_highlights,
})
