-- Neovim configuration for scientific software and technical writing, built
-- on the native vim.pack plugin manager (Neovim 0.12+).
--
-- Layout:
--   plugin/*.lua          options, keymaps, autocmds, plugin setup.
--                         Neovim auto-sources these at startup in filename
--                         order, hence the numeric prefixes (00, 02, 10, …).
--   after/ftplugin/*.lua  filetype-local prose and TeX settings.
--   lua/config/*.lua      shared language inventory, prose, and health checks.
--   lua/luasnip/*.lua     snippet definitions loaded by LuaSnip.
--
-- There is deliberately nothing to `require` here: the plugin/ directory is
-- the entry point. This file only enables the module byte-compile cache.

vim.loader.enable()
