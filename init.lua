-- load lua/plugins.lua
require('plugins')

-- Set the <leader> key to ","
vim.g.mapleader = " "

-- Set the neovide font to FiraCode 14 pt
vim.o.guifont = "FiraCode NF:h14"

-- Disable Ex-mode.
vim.api.nvim_set_keymap('n', 'Q', '<Nop>', { noremap = true, silent = true })

-- Remove backup and swap files.
vim.o.backup = false
vim.o.swapfile = false

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

-- Show special characters
vim.o.listchars = "eol:$,tab:>-,trail:~,extends:>,precedes:<"
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
vim.o.termguicolors = true
vim.o.background = "dark" -- "dark/light"
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
  highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
  },
}

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

-- Set up mason for installing various language servers
require("mason").setup()
require("mason-lspconfig").setup()

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
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

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
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>z', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- Format with Ruff.
vim.api.nvim_set_keymap('n', '<space>f', ':!ruff format %<CR>:echo "Formatted with Ruff"<CR>', { noremap = true, silent = true })


-- Configure `ruff-lsp`.
-- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ruff_lsp
-- For the default config, along with instructions on how to customize the settings
require('lspconfig').ruff_lsp.setup{}

-- Configure typst language server
require('lspconfig').typst_lsp.setup{
	settings = {
		exportPdf = "onType" -- Choose onType, onSave or never.
        -- serverPath = "" -- Normally, there is no need to uncomment it.
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
vim.api.nvim_set_keymap('n', '<leader>t', ':lua require("copilot.suggestion").toggle_auto_trigger()<CR>', { noremap = true, silent = true })

