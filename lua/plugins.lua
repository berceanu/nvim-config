return {
  -- Color theme
  {'ellisonleao/gruvbox.nvim'},
  -- Better syntax highlighting via tree-sitter
  {'nvim-treesitter/nvim-treesitter', build = ":TSUpdate"},
  -- Breadcrumbs
  {'nvim-treesitter/nvim-treesitter-context'},
  -- Language Server Protocol
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'neovim/nvim-lspconfig',
  -- Indentation guide
  "lukas-reineke/indent-blankline.nvim",
  -- Comment code
  "numToStr/Comment.nvim",
  -- GitHub Copilot
  --  { "zbirenbaum/copilot.lua", cmd = "Copilot", 
  --    config = function()
  --      require("copilot").setup({})
  --    end,
  --  },
  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  -- FZF sorter for telescope
  -- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  -- Status bar
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons'},
  },
  -- Autocompletion plugin
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    },
  },
  -- Snippets source for nvim-cmp
  'saadparwaiz1/cmp_luasnip',
  -- Snippets plugin
  'L3MON4D3/LuaSnip',
  -- File explorer tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>ft", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
    },
    config = function()
      require("neo-tree").setup()
    end,
  },
  "folke/which-key.nvim",
  "folke/neodev.nvim",
}
