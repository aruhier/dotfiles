----------------------------------------------------------------
-------------------------- EXTENSIONS --------------------------
----------------------------------------------------------------

require("plugins.settings")
return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
	"nvim-telescope/telescope-fzf-native.nvim",
	-- NOTE: If you are having trouble with this installation,
	--       refer to the README for telescope-fzf-native for more instructions.
	build = "make",
	cond = function()
	  return vim.fn.executable("make") == 1
	end,
      },
    },
    config = function()
      PluginSetupTelescope()
    end,
  },
  {"liuchengxu/vista.vim", config = function() PluginSetupVista() end},
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
  { "tpope/vim-surround" },
  {
    "sainnhe/everforest",
    config = function()
      PluginSetupEverforestTheme()
    end,
  },
  { "chaoren/vim-wordmotion" },
  { "dhruvasagar/vim-table-mode" },
  { "tpope/vim-sleuth" },
  { "rhysd/vim-grammarous" },
  {
    "chentoast/marks.nvim",
    config = function()
      require("marks").setup()
    end,
  },
  {
    "shellRaining/hlchunk.nvim",
    config = function()
      PluginSetupHLChunk()
    end,
  },

  ---- Autocomplete
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      -- Not strictly required but ensures that everything linked to the lsp is loaded.
      "neovim/nvim-lspconfig",
      "ray-x/lsp_signature.nvim",
    },
    config = function() PluginSetupLSP(); PluginSetupNvimCMP() end
  },
  {
    "mason-org/mason.nvim", "WhoIsSethDaniel/mason-tool-installer.nvim", "mason-org/mason-lspconfig.nvim",
    dependencies = {"neovim/nvim-lspconfig"},
    config = function() PluginSetupLSPInstaller() end
  },

  ---- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = false })()
    end,
    config = function() PluginSetupTreesitter() end
  },
  ---- Code diagnostic
  {"folke/trouble.nvim", dependencies = {"kyazdani42/nvim-web-devicons"}, config = function() PluginSetupTrouble() end},
  ---- Unit tests
  {"janko-m/vim-test", config = function() PluginSetupTest() end},
  {"alfredodeza/coveragepy.vim", ft = {"python"}},
  ---- LaTeX
  {"lervag/vimtex", ft = {"tex"}},
  ---- Markdown
  {
    "preservim/vim-markdown",
    ft = {"markdown"},
    config = function()
      vim.g["vim_markdown_no_default_key_mappings"] = 1
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = {"markdown"},
    build = function() vim.fn["mkdp#util#install"]() end,
    config = function()
      vim.api.nvim_set_keymap("n", "<leader>lv", "<cmd>:MarkdownPreview<cr>", {silent = true, noremap = true})
    end,
  },
  -- WARNING: Deprecated.
  {
    "ellisonleao/glow.nvim",
    ft = {"markdown"},
    config = function()
      require("glow").setup()
      vim.api.nvim_set_keymap("n", "<leader>ll", "<cmd>Glow<cr>", {silent = true, noremap = true})
    end,
  },
  ---- Python
  {"psf/black", ft = {"python"}, config = function() PluginSetupBlack() end},
  ---- Rust
  {"rust-lang/rust.vim", ft = {"rust"}, config = function() PluginSetupRust() end},
  ---- XML
  {"sukima/xmledit", ft = {"xml"}},

  ---- Git support
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("gitsigns").setup() end
  },

  { "tpope/vim-fugitive" },
  { "rhysd/git-messenger.vim" },

  ---- Status line
  {
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      PluginSetupLuaLine()
    end,
  },

  -- Multiple cursors, with ctrl+n
  { "mg979/vim-visual-multi", branch = "master" },
}
