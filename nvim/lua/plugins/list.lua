    ----------------------------------------------------------------
    -------------------------- EXTENSIONS --------------------------
    ----------------------------------------------------------------

require("plugins.settings")
require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    config = function() PluginSetupTelescope() end
  }
  use {
    'windwp/nvim-autopairs',
    config = function() require("nvim-autopairs").setup {} end
  }
  use 'tpope/vim-surround'
  use {'sainnhe/everforest', config = function() PluginSetupEverforestTheme() end }
  use 'chaoren/vim-wordmotion'
  use 'tpope/vim-sleuth'
  use {
    'chentoast/marks.nvim',
    config = function() require('marks').setup() end
  }
  use {'shellRaining/hlchunk.nvim', config = function() PluginSetupHLChunk() end }

  ---- Status line
  use {'nvim-lualine/lualine.nvim', requires={'kyazdani42/nvim-web-devicons'}, config = function() PluginSetupLuaLine() end }

  -- Multiple cursors, with ctrl+n
  use {'mg979/vim-visual-multi', branch = 'master'}
end)
