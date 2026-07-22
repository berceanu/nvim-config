-- LuaSnip — the snippet engine. Snippet definitions live in lua/luasnip/*.lua
-- and are loaded lazily per filetype (tex.lua for LaTeX, all.lua for global).

-- Pure-Lua: no jsregexp C build. Our snippets use plain/word triggers, not
-- regex transforms, so the optional jsregexp extension isn't needed.
vim.pack.add({ "https://github.com/L3MON4D3/LuaSnip" })

local ls = require("luasnip")

ls.setup({
  -- Re-evaluate snippets as you type so autosnippets (e.g. maths triggers) fire.
  update_events = { "TextChanged", "TextChangedI" },
  enable_autosnippets = true,
  store_selection_keys = "<Tab>",
})

-- Load the Lua snippet files under lua/luasnip/ (filename = filetype).
require("luasnip.loaders.from_lua").lazy_load({
  paths = { vim.fn.stdpath("config") .. "/lua/luasnip" },
})

-- Snippet navigation. <Tab> expand/jump is handled in 50completion.lua;
-- these are explicit always-available fallbacks.
vim.keymap.set({ "i" }, "<C-k>", function()
  if ls.expandable() then
    ls.expand()
  end
end, { silent = true, desc = "LuaSnip expand" })
vim.keymap.set({ "i", "s" }, "<C-j>", function()
  if ls.jumpable(1) then
    ls.jump(1)
  end
end, { silent = true, desc = "LuaSnip jump forward" })
vim.keymap.set({ "i", "s" }, "<C-h>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true, desc = "LuaSnip jump back" })

-- Reload snippets without restarting Neovim (handy while editing tex.lua).
vim.keymap.set("n", "<leader>L", function()
  require("luasnip.loaders.from_lua").load({
    paths = { vim.fn.stdpath("config") .. "/lua/luasnip" },
  })
  vim.notify("Snippets reloaded.")
end, { desc = "Reload snippets" })
