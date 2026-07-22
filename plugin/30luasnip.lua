-- LuaSnip — the snippet engine. Snippet definitions live in lua/luasnip/*.lua
-- and are loaded lazily per filetype (tex.lua for LaTeX, all.lua for global).

vim.pack.add({ "https://github.com/L3MON4D3/LuaSnip" })

-- LuaSnip's transform/regex features need the `jsregexp` C extension. It is not
-- shipped prebuilt, so build it once in the background if it is missing.
local function ensure_jsregexp_built()
  local init = vim.api.nvim_get_runtime_file("lua/luasnip/init.lua", false)[1]
  if not init then
    return
  end
  local root = vim.fn.fnamemodify(init, ":h:h:h")
  local artifact = root .. "/deps/jsregexp/jsregexp.so"
  if vim.fn.has("win32") == 1 then
    artifact = root .. "/deps/jsregexp/jsregexp.dll"
  end
  if not vim.uv.fs_stat(artifact) then
    vim.notify("Building LuaSnip jsregexp in the background…", vim.log.levels.INFO)
    vim.system({ "make", "install_jsregexp" }, { cwd = root }, function(out)
      vim.schedule(function()
        if out.code == 0 then
          vim.notify("LuaSnip jsregexp built.", vim.log.levels.INFO)
        else
          vim.notify("LuaSnip jsregexp build failed:\n" .. (out.stderr or out.stdout or ""), vim.log.levels.ERROR)
        end
      end)
    end)
  end
end
ensure_jsregexp_built()

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

-- Snippet navigation. Expansion under <Tab> is handled by blink.cmp
-- (see 50autocomplete.lua); these are explicit fallbacks.
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
