-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "


-- Map 'jj' to escape insert mode
vim.api.nvim_set_keymap('i', 'jj', '<Esc>', {noremap = true, silent = true})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

-- Highlight the current line
vim.opt.cursorline = true

-- Disable Ex-mode.
vim.api.nvim_set_keymap('n', 'Q', '<Nop>', { noremap = true, silent = true })

-- Use C-x instead of C-o
vim.api.nvim_set_keymap('n', '<C-x>', '<C-o>', { noremap = true, silent = true })

-- Remove backup and swap files.
vim.opt.backup = false
vim.opt.swapfile = false

-- Alias accidental SHIFTs.
vim.api.nvim_set_keymap('c', 'W<CR>', 'w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', 'Q<CR>', 'q<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', 'X<CR>', 'x<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', 'Sh<CR>', 'sh<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', 'sH<CR>', 'sh<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', 'SH<CR>', 'sh<CR>', { noremap = true, silent = true })

-- Line numbering.
vim.wo.relativenumber = true
vim.wo.number = true

-- Prevent automatic commenting of new lines.
vim.cmd('set formatoptions-=c')
vim.cmd('set formatoptions-=r')
vim.cmd('set formatoptions-=o')

-- Associate .profile files with shell scripts
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.profile",
    command = "setfiletype sh",
})

-- Associate .param files with C++ code
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.param",
    command = "setfiletype cpp",
})

-- Show special characters
vim.opt.listchars = "eol:$,tab:>-,trail:~,extends:>,precedes:<"
vim.wo.list = true

-- Allow clipboard copy paste in neovide
if vim.g.neovide then
  vim.g.neovide_input_use_logo = 1
  vim.g.neovide_cursor_vfx_mode = "railgun"
  vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<D-c>', '"+y') -- Copy
  vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
end

-- Allow ESC in built-in terminal
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

-- Use gruvbox color theme
vim.opt.termguicolors = true
vim.opt.background = "dark" -- "dark/light"
vim.cmd([[colorscheme gruvbox]])

-- Disable virtual LSP warnings/errors
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = false
  }
)

-- Use treesitter for syntax highlighting
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- or install a subset of parsers
  ignore_install = {},
  sync_install = false,
  auto_install = false,
  highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
  },
}

-- Set up mason for installing various language servers
require("mason").setup()
require("mason-lspconfig").setup()

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}


-- After setting up mason-lspconfig we may set up servers via lspconfig

-- Setup language servers.
local lspconfig = require('lspconfig')

lspconfig.pyright.setup{
    cmd = {"pyright-langserver", "--stdio"},
    capabilities = capabilities,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true
          -- Add extra paths if needed, for example:
          -- extraPaths = {"/path/to/your/custom/python/site-packages"}
          -- Remeber to create pyrightconfig.json in the root of your project, for example:
          -- {
          --   "venvPath": ".",
          --   "venv": ".pixi/env"
          -- }
        }
      }
    },
}

-- Global mappings for LSP
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>z', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- Setup lua_ls and enable call snippets
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  }
})

-- Format with Ruff.
-- vim.api.nvim_set_keymap('n', '<leader>f', ':!ruff format %<CR>:echo "Formatted with Ruff"<CR>', { noremap = true, silent = true })

-- Configure `ruff-lsp`.
-- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ruff_lsp
-- For the default config, along with instructions on how to customize the settings
-- require('lspconfig').ruff_lsp.setup{}

-- Configure typst language server
require('lspconfig').typst_lsp.setup{
  capabilities = capabilities,
  settings = {
    exportPdf = "onType" -- Choose onType, onSave or never.
  }
}

-- Associate .typ files with typst filetype
vim.cmd [[
  au BufRead,BufNewFile *.typ set filetype=typst
]]

-- Setup telescope.
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Setup status bar.
require('lualine').setup{
  options = {
    icons_enabled = true,
    theme = 'gruvbox',
  },
  sections = {
    lualine_c = {{'filename', path = 2}},
  },
  inactive_sections = {
    lualine_c = {{'filename', path = 2}},
  },
}

-- For breadcrumbs
require'treesitter-context'.setup{
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to show for a single context
  trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20, -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

-- GitHub Copilot support
-- vim.api.nvim_set_keymap('n', '<leader>t', ':lua require("copilot.suggestion").toggle_auto_trigger()<CR>', { noremap = true, silent = true })
