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
  { "tpope/vim-sleuth" },
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
