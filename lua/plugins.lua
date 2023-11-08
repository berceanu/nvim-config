return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  -- Popular color theme
  use {'ellisonleao/gruvbox.nvim'}
  -- Better syntax highlighting via tree-sitter
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use {'nvim-treesitter/nvim-treesitter-context'}  -- breadcrumbs
  -- Language Server Protocol
  use {'williamboman/mason.nvim',
       'williamboman/mason-lspconfig.nvim',
       'neovim/nvim-lspconfig',
      }
  -- Indentation guide
  use "lukas-reineke/indent-blankline.nvim"
  -- Comment code
  use "numToStr/Comment.nvim"
  -- GitHub Copilot
--  use { "zbirenbaum/copilot.lua", cmd = "Copilot", 
--    config = function()
--      require("copilot").setup({})
--    end,
--  }
  -- Telescope
  use {
      'nvim-telescope/telescope.nvim', branch = '0.1.x',
      requires = { {'nvim-lua/plenary.nvim'} }
  }
  -- FZF sorter for telescope
  -- use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  -- Status bar
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  -- Autocompletion plugin
  use 'hrsh7th/nvim-cmp'
  -- LSP source for nvim-cmp
  use 'hrsh7th/cmp-nvim-lsp' 
  -- Snippets source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip'
  -- Snippets plugin
  use 'L3MON4D3/LuaSnip' 
  -- File explorer tree
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional
    },
  }
  -- which-key
  use {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup {
        -- your configuration comes here
      }
    end
  }
  -- Tab support
  use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}
end)
