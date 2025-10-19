----------------------------------------------------------------
-------------------------- EXTENSIONS --------------------------
----------------------------------------------------------------

require("plugins.settings")
return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
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
    event = "VeryLazy",
    config = function()
      PluginSetupTelescope()
    end,
  },
  {
    "liuchengxu/vista.vim",
    config = function()
      PluginSetupVista()
    end
  },
  {
    "windwp/nvim-autopairs",
    event = {"InsertEnter", "VeryLazy"},
    config = true
  },
  {
    "tpope/vim-surround",
    event = {"InsertEnter", "VeryLazy"}
  },
  {
    "sainnhe/everforest",
    priority=1000,
    config = function()
      PluginSetupEverforestTheme()
    end,
  },
  { "chaoren/vim-wordmotion" },
  { "dhruvasagar/vim-table-mode" },
  { "tpope/vim-sleuth" },
  {
    "rhysd/vim-grammarous",
    cmd = {"GrammarousCheck", "GrammarousReset"},
  },
  {
    "chentoast/marks.nvim",
    config = true,
  },
  {
    "shellRaining/hlchunk.nvim",
    config = function()
      PluginSetupHLChunk()
    end,
  },

  ---- Autocomplete
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      -- Not strictly required but ensures that everything linked to the lsp is loaded.
      "neovim/nvim-lspconfig",
    },
    version = '1.*',
    event = {"InsertEnter", "CmdlineEnter", "VeryLazy"},
    config = function()
      PluginSetupLSP()
      PluginSetupBlink()
    end
  },
  {
    "mason-org/mason.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    event = {"InsertEnter", "VeryLazy"},
    config = function()
      PluginSetupLSPInstaller()
    end
  },

  ---- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {"nvim-treesitter/nvim-treesitter-textobjects", branch = "main"},
    },
    branch = "main",
    build = ":TSUpdate",
    config = function() PluginSetupTreesitter() end,
    lazy = false,
  },
  ---- Code diagnostic
  {"folke/trouble.nvim", dependencies = {"kyazdani42/nvim-web-devicons"}, config = function() PluginSetupTrouble() end},
  ---- Unit tests
  {
    "vim-test/vim-test",
    event = "VeryLazy",
    config = function()
      PluginSetupTest()
    end
  },
  { "alfredodeza/coveragepy.vim", ft = {"python"} },
  ---- LaTeX
  { "lervag/vimtex", ft = {"tex"} },
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
  { "psf/black", ft = {"python"}, config = function() PluginSetupBlack() end },
  ---- Rust
  { "rust-lang/rust.vim", ft = {"rust"}, config = function() PluginSetupRust() end },
  ---- XML
  { "sukima/xmledit", ft = {"xml"} },

  ---- Git support
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true
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
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = {"InsertEnter", "VeryLazy"},
  },

  -- Key helpers
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      preset = "modern",
      triggers = {
        -- Disable for visual mode.
        { "<auto>", mode = "nso" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
}
