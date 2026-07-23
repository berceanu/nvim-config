-- Native, responsive statusline — no plugin. Tmux owns session/machine context;
-- this bar owns editor context: mode, file, Git, diagnostics, LSP and position.

vim.opt.laststatus = 3
vim.opt.showmode = false

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
  set(0, "StSep", { fg = c.surface1, bg = bg })
  set(0, "StFile", { fg = c.text, bg = bg, bold = true })
  set(0, "StModified", { fg = c.peach, bg = bg, bold = true })
  set(0, "StMuted", { fg = c.subtext0, bg = bg })
  set(0, "StGit", { fg = c.mauve, bg = bg })
  set(0, "StAdded", { fg = c.green, bg = bg })
  set(0, "StChanged", { fg = c.yellow, bg = bg })
  set(0, "StRemoved", { fg = c.red, bg = bg })
  set(0, "StErr", { fg = c.red, bg = bg, bold = true })
  set(0, "StWarn", { fg = c.yellow, bg = bg })
  set(0, "StLsp", { fg = c.blue, bg = bg })
  set(0, "StMacro", { fg = c.crust, bg = c.peach, bold = true })
  set(0, "StatusLine", { fg = c.text, bg = bg })
  set(0, "StatusLineNC", { fg = c.overlay0, bg = bg })
  set(0, "WinBar", { fg = c.subtext0, bg = c.base })
  set(0, "WinBarNC", { fg = c.overlay0, bg = c.base })
end

local modes = {
  n = { "NORMAL", "N", "StModeNormal" },
  no = { "OPERATOR", "O", "StModeNormal" },
  i = { "INSERT", "I", "StModeInsert" },
  ic = { "INSERT", "I", "StModeInsert" },
  v = { "VISUAL", "V", "StModeVisual" },
  V = { "V-LINE", "VL", "StModeVisual" },
  ["\22"] = { "V-BLOCK", "VB", "StModeVisual" },
  s = { "SELECT", "S", "StModeVisual" },
  S = { "S-LINE", "SL", "StModeVisual" },
  c = { "COMMAND", "C", "StModeCommand" },
  ["!"] = { "SHELL", "!", "StModeCommand" },
  R = { "REPLACE", "R", "StModeReplace" },
  Rv = { "V-REPLACE", "VR", "StModeReplace" },
  t = { "TERMINAL", "T", "StModeTerminal" },
}

local function escape(text)
  return (text or ""):gsub("%%", "%%%%")
end

local function segment(group, text)
  if not text or text == "" then
    return ""
  end
  return ("%%#%s#%s"):format(group, escape(text))
end

local separator = "%#StSep# │ "

local function mode_segment(width)
  local current = vim.api.nvim_get_mode().mode
  local info = modes[current] or modes[current:sub(1, 1)] or { current:upper(), "?", "StModeNormal" }
  local label = width < 80 and info[2] or info[1]
  return segment(info[3], " " .. label .. " ")
end

local function file_segment(width)
  local name = vim.api.nvim_buf_get_name(0)
  local path
  if name == "" then
    path = "[No Name]"
  elseif width < 80 then
    path = vim.fn.fnamemodify(name, ":t")
  else
    path = vim.fn.fnamemodify(name, ":~:.")
    local budget = width >= 140 and 52 or 34
    if vim.fn.strdisplaywidth(path) > budget then
      path = vim.fn.pathshorten(path)
    end
    if vim.fn.strdisplaywidth(path) > budget then
      path = "…/" .. vim.fn.fnamemodify(name, ":t")
    end
  end

  local result = segment("StFile", " " .. path)
  if vim.bo.modified then
    result = result .. segment("StModified", " [+]")
  end
  if vim.bo.readonly then
    result = result .. segment("StWarn", " [RO]")
  end
  return result
end

local function git_segment(width)
  local status = vim.b.gitsigns_status_dict
  local head = status and status.head or vim.b.gitsigns_head
  if not head or head == "" then
    return nil
  end

  local result = segment("StGit", "git:" .. head)
  if width >= 120 and status then
    local added = status.added or 0
    local changed = status.changed or 0
    local removed = status.removed or 0
    if added > 0 then
      result = result .. segment("StAdded", " +" .. added)
    end
    if changed > 0 then
      result = result .. segment("StChanged", " ~" .. changed)
    end
    if removed > 0 then
      result = result .. segment("StRemoved", " -" .. removed)
    end
  end
  return result
end

local function diagnostic_segment()
  local counts = vim.diagnostic.count(0)
  local errors = counts[vim.diagnostic.severity.ERROR] or 0
  local warnings = counts[vim.diagnostic.severity.WARN] or 0
  local result = ""
  if errors > 0 then
    result = result .. segment("StErr", "E" .. errors)
  end
  if warnings > 0 then
    if result ~= "" then
      result = result .. " "
    end
    result = result .. segment("StWarn", "W" .. warnings)
  end
  return result ~= "" and result or nil
end

local function lsp_segment(width)
  if width < 120 then
    return nil
  end
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return nil
  end
  local seen, names = {}, {}
  for _, client in ipairs(clients) do
    if not seen[client.name] then
      seen[client.name] = true
      names[#names + 1] = client.name
    end
  end
  table.sort(names)
  return segment("StLsp", "LSP:" .. table.concat(names, ","))
end

local function metadata_segment(width)
  if width < 80 then
    return nil
  end
  local metadata = {}
  if vim.bo.filetype ~= "" then
    metadata[#metadata + 1] = vim.bo.filetype
  end
  if width >= 140 then
    local encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
    if encoding ~= "utf-8" then
      metadata[#metadata + 1] = encoding
    end
    if vim.bo.fileformat ~= "unix" then
      metadata[#metadata + 1] = vim.bo.fileformat
    end
  end
  return #metadata > 0 and segment("StMuted", table.concat(metadata, "·")) or nil
end

local function macro_segment()
  local register = vim.fn.reg_recording()
  return register ~= "" and segment("StMacro", " REC @" .. register .. " ") or nil
end

local function cursor_segment()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local lines = math.max(vim.api.nvim_buf_line_count(0), 1)
  local percent = math.floor((cursor[1] / lines) * 100)
  return segment("StMuted", ("%d:%d  %d%% "):format(cursor[1], cursor[2] + 1, percent))
end

function _G.Statusline()
  local width = vim.o.columns
  local left = mode_segment(width) .. separator .. file_segment(width)
  local git = git_segment(width)
  if git then
    left = left .. separator .. git
  end

  local right = {}
  local function add(value)
    if value then
      right[#right + 1] = value
    end
  end
  add(macro_segment())
  add(diagnostic_segment())
  add(lsp_segment(width))
  add(metadata_segment(width))
  add(cursor_segment())

  return left .. "%#StFill#%=" .. table.concat(right, separator)
end

-- A global statusline cannot identify every split. Show a quiet per-window
-- filename only while a tab has multiple normal editing windows.
local function update_winbars()
  local regular = {}
  local is_regular = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local config = vim.api.nvim_win_get_config(win)
    local buf = vim.api.nvim_win_get_buf(win)
    if config.relative == "" and vim.bo[buf].buftype == "" and vim.bo[buf].filetype ~= "oil" then
      regular[#regular + 1] = win
      is_regular[win] = true
    end
  end
  local show = #regular > 1
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local value = show and is_regular[win] and " %t %m%r" or ""
    vim.api.nvim_set_option_value("winbar", value, { win = win })
  end
end

set_highlights()
vim.o.statusline = "%!v:lua.Statusline()"
vim.schedule(update_winbars)

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("UserStatuslineColors", { clear = true }),
  callback = set_highlights,
})

vim.api.nvim_create_autocmd({ "WinNew", "WinClosed", "BufWinEnter", "TabEnter" }, {
  group = vim.api.nvim_create_augroup("UserWinbars", { clear = true }),
  callback = function()
    vim.schedule(update_winbars)
  end,
})

vim.api.nvim_create_autocmd({
  "BufModifiedSet",
  "DiagnosticChanged",
  "LspAttach",
  "LspDetach",
  "RecordingEnter",
  "RecordingLeave",
  "VimResized",
}, {
  group = vim.api.nvim_create_augroup("UserStatuslineRefresh", { clear = true }),
  callback = function()
    vim.cmd.redrawstatus()
  end,
})
