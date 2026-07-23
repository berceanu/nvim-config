-- Typst live preview. Completion/diagnostics/format come from the tinymist LSP
-- (enabled in 74lsp.lua when the `tinymist` binary is present). This plugin adds
-- an incrementally-updating browser preview — the Typst analogue of \lv for LaTeX.
--   <leader>tp   toggle the live preview
-- See https://myriad-dreamin.github.io/tinymist/frontend/neovim.html

local dependency_check = vim.env.NVIM_TYPST_DEPENDENCY_CHECK == "1"
local has_display = dependency_check
  or (
    vim.env.NVIM_CONFIG_CHECK ~= "1"
    and #vim.api.nvim_list_uis() > 0
    and (
      vim.fn.has("mac") == 1
      or (vim.env.DISPLAY and vim.env.DISPLAY ~= "")
      or (vim.env.WAYLAND_DISPLAY and vim.env.WAYLAND_DISPLAY ~= "")
    )
  )
local tinymist = vim.fn.exepath("tinymist")
local websocat = vim.fn.exepath("websocat")
local load_preview = has_display and tinymist ~= "" and websocat ~= ""

-- Supplying both paths is a security/reproducibility boundary: the plugin must
-- never fetch executables on its own. Headless hosts keep editing/LSP support
-- without initializing a browser-preview stack they cannot use.
vim.pack.add({ "https://github.com/chomosuke/typst-preview.nvim" }, {
  load = load_preview,
})
if not load_preview then
  return
end

require("typst-preview").setup({
  dependencies_bin = {
    ["tinymist"] = tinymist,
    ["websocat"] = websocat,
  },
})
vim.keymap.set("n", "<leader>tp", "<cmd>TypstPreviewToggle<cr>", {
  desc = "Typst preview (toggle)",
})
