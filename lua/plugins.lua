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
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      require("ibl").setup()
    end,
  },
  -- Comment code
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  -- GitHub Copilot
  --  { "zbirenbaum/copilot.lua", cmd = "Copilot", 
  --    config = function()
  --      require("copilot").setup({})
  --    end,
  --  },
  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  -- FZF sorter for telescope
  -- { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  -- Status bar
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons'},
  },
  -- Autocompletion plugin
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  -- Snippets source for nvim-cmp
  "saadparwaiz1/cmp_luasnip",
  -- Snippets plugin
  "L3MON4D3/LuaSnip",
  -- Diffview.nvim
  "sindrets/diffview.nvim",
  -- File explorer tree
  {
    "nvim-neo-tree/neo-tree.nvim",
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
  {
    "folke/neodev.nvim",
    config = function()
      require("neodev").setup()
    end,
  },
  -- Org mode
  {
    "nvim-orgmode/orgmode",
    dependencies = {
      {"nvim-treesitter/nvim-treesitter"},
    },
  },
}
