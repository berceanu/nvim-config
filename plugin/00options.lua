-- Editor options and leader keys. Numbered 00 so it runs before any plugin
-- file: leaders must be set before plugins create <leader>/<localleader> maps.

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- Line numbers and cursor
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.scrolloff = 5
opt.signcolumn = "yes"

-- Mouse & clipboard. mouse=a makes a plain drag a *buffer* selection (excludes
-- the number/sign gutter — Shift+drag grabs those rendered cells instead, which
-- is why gutter text leaks into copies). unnamedplus routes plain y/p through the
-- system clipboard: pbcopy locally, or the OSC 52 provider below over SSH. Net:
-- drag-select + y lands clean on the Mac clipboard, no line numbers.
opt.mouse = "a"
opt.clipboard = "unnamedplus"

-- Colours
opt.termguicolors = true
opt.background = "dark"

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Indentation (2 spaces; LaTeX/prose friendly)
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- Wrapping: soft-wrap at word boundaries, keep indentation on wrapped lines.
-- (ftplugin/tex.lua turns wrap on for prose.)
opt.wrap = false
opt.linebreak = true
opt.breakindent = true

-- Show invisible characters (trailing space, tabs, non-breaking space)
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", extends = "›", precedes = "‹" }

-- Files: reload clean buffers changed by external tools, keep persistent undo,
-- and avoid backup/swap files.
opt.autoread = true
opt.backup = false
opt.swapfile = false
opt.undofile = true

-- Splits open to the right / below
opt.splitright = true
opt.splitbelow = true

-- Completion menu behaviour
opt.completeopt = { "menu", "menuone", "noselect" }

-- Disable the built-in netrw file browser (oil.nvim replaces it)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Stop new lines from inheriting comment leaders / auto-wrapping by textwidth.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("UserFormatOptions", { clear = true }),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Diagnostics: no inline virtual text (kept quiet on purpose); show on demand
-- via <leader>e (see 03keymaps.lua) or the native float.
vim.diagnostic.config({
  virtual_text = false,
  severity_sort = true,
  float = { border = "single" },
})

-- Over SSH there's no local display, so route the "+"/"*" clipboard through
-- OSC 52: yanks land in the terminal that opened the ssh session (your Mac's
-- Ghostty). SSH_CONNECTION (not SSH_TTY) is used because tmux propagates it to
-- panes. Only enabled on remote sessions; local macOS clipboard is untouched.
if vim.env.SSH_CONNECTION and vim.env.SSH_CONNECTION ~= "" then
  local osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name = "OSC52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
  }
end
