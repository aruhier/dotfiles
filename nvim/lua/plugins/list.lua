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
  { "tpope/vim-sleuth" },
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
