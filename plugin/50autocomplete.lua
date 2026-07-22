-- Completion — blink.cmp (fast, actively developed) wired to LuaSnip for
-- snippets and to VimTeX (via blink.compat + cmp-vimtex) for LaTeX citations,
-- \ref labels, glossary entries, package/command names, and file paths.

vim.pack.add({
  "https://github.com/micangl/cmp-vimtex", -- VimTeX completion source (nvim-cmp API)
  "https://github.com/saghen/blink.lib", -- shared library used by blink.compat
  "https://github.com/saghen/blink.compat", -- lets blink.cmp consume nvim-cmp sources
  "https://github.com/saghen/blink.cmp", -- the completion engine
})

require("blink.compat").setup({})

require("blink.cmp").setup({
  keymap = {
    preset = "default", -- <C-space> open, <C-e> close, <C-y> accept, <C-n>/<C-p> select
    ["<Tab>"] = { "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "snippet_backward", "fallback" },
  },
  snippets = { preset = "luasnip" },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
    -- In LaTeX files, put the VimTeX source first for citations/refs.
    per_filetype = {
      tex = { "vimtex", "snippets", "buffer", "path" },
    },
    providers = {
      snippets = { score_offset = 10 },
      vimtex = {
        name = "vimtex",
        module = "blink.compat.source",
        score_offset = 15,
      },
    },
  },
  signature = { enabled = true },
  completion = {
    documentation = { auto_show = true, window = { border = "single" } },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
})

-- blink.cmp's Rust fuzzy matcher gives typo-resistant sorting. On a source
-- checkout (vim.pack tracks the default branch) blink can't download a matching
-- prebuilt binary, so build it from source with blink's own build routine —
-- which compiles AND copies the library into blink's native cache where the
-- loader reads it (a plain `cargo build` leaves it where blink won't look).
-- Requires `cargo`; guarded so it only runs when the library is missing, and
-- falls back to a pure-Lua matcher if the build is unavailable.
vim.schedule(function()
  local ok, fuzzy = pcall(require, "blink.cmp.fuzzy")
  if not ok then
    return
  end
  local got, _, libpath = pcall(fuzzy.get_lib)
  local have = got and libpath ~= nil and vim.uv.fs_stat(libpath) ~= nil
  if not have and vim.fn.executable("cargo") == 1 then
    vim.notify("Building blink.cmp fuzzy matcher (one-time)…", vim.log.levels.INFO)
    pcall(function()
      require("blink.cmp").build()
    end)
  end
end)
