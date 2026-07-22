-- Neovim configuration — LaTeX-focused, built on the native vim.pack plugin
-- manager (Neovim 0.12+). Pure Lua, no external plugin manager.
--
-- Layout:
--   plugin/*.lua          options, keymaps, autocmds, plugin setup.
--                         Neovim auto-sources these at startup in filename
--                         order, hence the numeric prefixes (00, 02, 10, …).
--   after/ftplugin/*.lua  filetype-local settings (tex, bib).
--   lua/luasnip/*.lua     snippet definitions loaded by LuaSnip.
--
-- There is deliberately nothing to `require` here: the plugin/ directory is
-- the entry point. This file only enables the module byte-compile cache.

vim.loader.enable()
