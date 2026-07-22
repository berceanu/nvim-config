-- Native completion — no plugin, no compiler. Completion comes from Neovim itself:
--   * VimTeX sets 'omnifunc' in .tex buffers → \cite, \ref, environments, files
--   * keyword completion from the current buffers ('complete')
--   * LuaSnip for snippet expansion
-- <Tab> drives everything; <C-Space> force-triggers the omni menu.
-- (When you later add an LSP, `vim.lsp.completion.enable({ autotrigger = true })`
--  gives an as-you-type popup with zero plugins.)

vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.pumheight = 12

local function feed(keys)
  vim.api.nvim_feedkeys(vim.keycode(keys), "n", false)
end

-- Is there a non-space character right before the cursor?
local function has_words_before()
  local col = vim.fn.col(".") - 1
  if col == 0 then
    return false
  end
  return vim.api.nvim_get_current_line():sub(col, col):match("%s") == nil
end

local function trigger()
  return vim.bo.omnifunc ~= "" and "<C-x><C-o>" or "<C-n>"
end

-- Force completion regardless of context.
vim.keymap.set("i", "<C-Space>", function()
  feed(trigger())
end, { silent = true, desc = "Trigger completion" })

-- Tab: navigate menu → expand/jump snippet → open completion → literal tab.
vim.keymap.set("i", "<Tab>", function()
  local ls = require("luasnip")
  if vim.fn.pumvisible() == 1 then
    feed("<C-n>")
  elseif ls.expand_or_jumpable() then
    ls.expand_or_jump()
  elseif has_words_before() then
    feed(trigger())
  else
    feed("<Tab>")
  end
end, { silent = true, desc = "Complete / snippet / indent" })

-- Shift-Tab: previous menu item → jump snippet back → literal.
vim.keymap.set("i", "<S-Tab>", function()
  local ls = require("luasnip")
  if vim.fn.pumvisible() == 1 then
    feed("<C-p>")
  elseif ls.jumpable(-1) then
    ls.jump(-1)
  else
    feed("<S-Tab>")
  end
end, { silent = true, desc = "Prev completion / snippet back" })

-- Enter: confirm the highlighted item, else a normal newline.
vim.keymap.set("i", "<CR>", function()
  return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>"
end, { expr = true, replace_keycodes = true, silent = true, desc = "Confirm completion / newline" })
