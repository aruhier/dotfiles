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
  use {'liuchengxu/vista.vim', config = function() PluginSetupVista() end}
  use {
    'windwp/nvim-autopairs',
    config = function() require("nvim-autopairs").setup {} end
  }
  use 'tpope/vim-surround'
  use {'sainnhe/everforest', config = function() PluginSetupEverforestTheme() end }
  use 'chaoren/vim-wordmotion'
  use 'dhruvasagar/vim-table-mode'
  use 'tpope/vim-sleuth'
  use 'rhysd/vim-grammarous'
  use {
    'chentoast/marks.nvim',
    config = function() require('marks').setup() end
  }
  use {'shellRaining/hlchunk.nvim', config = function() PluginSetupHLChunk() end }

  ---- Status line
  use {'nvim-lualine/lualine.nvim', requires={'kyazdani42/nvim-web-devicons'}, config = function() PluginSetupLuaLine() end }

  -- Multiple cursors, with ctrl+n
  use {'mg979/vim-visual-multi', branch = 'master'}

  ---- Autocomplete
  use {
    'hrsh7th/nvim-cmp',
    requires={
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
      -- Not strictly required but ensures that everything linked to the lsp is loaded.
      'neovim/nvim-lspconfig',
      'ray-x/lsp_signature.nvim',
    },
    config = function() PluginSetupLSP(); PluginSetupNvimCMP() end
  }
  use {
    'mason-org/mason.nvim', 'WhoIsSethDaniel/mason-tool-installer.nvim', 'mason-org/mason-lspconfig.nvim',
    requires={'neovim/nvim-lspconfig'},
    config = function() PluginSetupLSPInstaller() end
  }

  ---- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = false })
      ts_update()
    end,
    config = function() PluginSetupTreesitter() end
  }
  ---- Code diagnostic
  use {'folke/trouble.nvim', requires={'kyazdani42/nvim-web-devicons'}, config = function() PluginSetupTrouble() end}
  ---- Unit tests
  use {'janko-m/vim-test', config = function() PluginSetupTest() end}
  use {'alfredodeza/coveragepy.vim', ft = {'python'}}
  ---- LaTeX
  use {'lervag/vimtex', ft = {'tex'}}
  ---- Markdown
  use {'preservim/vim-markdown', ft = {'markdown'},
    config = function()
      vim.g['vim_markdown_no_default_key_mappings'] = 1
    end,
  }
  use {'iamcco/markdown-preview.nvim', ft = {'markdown'},
    run = function() vim.fn["mkdp#util#install"]() end,
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>lv', '<cmd>:MarkdownPreview<cr>', {silent = true, noremap = true})
    end,
  }
  -- WARNING: Deprecated.
  use {'ellisonleao/glow.nvim', ft = {'markdown'},
    config = function()
      require('glow').setup()
      vim.api.nvim_set_keymap('n', '<leader>ll', '<cmd>Glow<cr>', {silent = true, noremap = true})
    end,
  }
  ---- Python
  use {'psf/black', ft = {'python'}, config = function() PluginSetupBlack() end}
  ---- Rust
  use {'rust-lang/rust.vim', ft = {'rust'}, config = function() PluginSetupRust() end}
  ---- XML
  use {'sukima/xmledit', ft = {'xml'}}

  ---- Git support
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('gitsigns').setup() end
  }

  use 'tpope/vim-fugitive'
  use 'rhysd/git-messenger.vim'
end)
