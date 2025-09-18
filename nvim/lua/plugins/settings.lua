-------------------------------------------------------------------
-------------------------- Configuration --------------------------
-------------------------------------------------------------------

local map = vim.keymap.set
local opts = { noremap=true, silent=true }


-- Everforest Theme
--------------------

function PluginSetupEverforestTheme()
  vim.opt.termguicolors = true
  map('n', '<F10>', ':let &background = ( &background == "dark"? "light" : "dark" )<CR>', {desc = 'Toggle Background (dark/light)'})
  vim.g['everforest_background'] = 'medium'
  vim.g['everforest_ui_contrast'] = 'high'
  vim.g['everforest_better_performance'] = 1
  vim.cmd [[ colorscheme everforest ]]
end


-- Status line
---------------

function PluginSetupLuaLine()
  local solarized_dark = require'lualine.themes.solarized_dark'
  solarized_dark.normal.b.bg = '#808e8e'
  solarized_dark.inactive.b.bg = '#808e8e'
  solarized_dark.insert.a.bg = '#b58900'
  local solarized_light = require'lualine.themes.solarized_light'
  solarized_light.insert.a.bg = '#b58900'

  require'lualine'.setup {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
      disabled_filetypes = {},
      always_divide_middle = true,
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {
        'branch',
        { 'diff', colored=false},
        {
          'diagnostics',
          sources={function()
            if vim.fn.has('nvim-0.5') == 1 then
              return 'nvim-lsp'
            end
            return 'nvim-diagnostic'
          end},
          colored=false, icons_enabled=false
        }
      },
      lualine_c = {
        {
          'filename',
          -- Relative path.
          path=1,
        },
      },
      lualine_x = {'encoding', {'fileformat' , icons_enabled=false}, {'filetype', icons_enabled=false}},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        {
          'filename',
          -- Relative path.
          path=1,
        },
      },
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {
      lualine_a = {{'tabs', mode = 1, path=1, max_length = vim.o.columns}},
    },
    extensions = {}
  }

  -- Needed because of that: https://github.com/nvim-lualine/lualine.nvim/discussions/845
  if #vim.api.nvim_list_tabpages() < 2 then
    require('lualine').hide({
      place = { 'tabline' },
    })
  end
  vim.api.nvim_create_autocmd({ 'TabNew', 'TabClosed' }, {
    group = vim.api.nvim_create_augroup('LualineTab', {}),
    callback = function()
      local show = #vim.api.nvim_list_tabpages() > 1
      vim.o.showtabline = show and 1 or 0
      require('lualine').hide({
        place = { 'tabline' },
        unhide = show,
      })
    end,
  })
end


-- HL Chunk
-----------------

function PluginSetupHLChunk()
  require('hlchunk').setup({
    -- Used a color blender between everforest comment color (#859289) and everforest fg_red (#f85552).
    -- Use a slightly brighter color to make it more readable.
    line_num = {
      enable = true,
      style = "#a49088",
    },
    -- Used a color blender between everforest comment color (#859289) and everforest fg_red (#f85552).
    chunk = {
      enable = true,
      style = {
        { fg = "#9A877F" },
      },
      delay = 0,
    },
    indent = {
      enable = true,
    },
    blank = {
      enable = true,
      chars = {
        '․',
      },
      style = {
        { vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui"), "" },
      },
    },
  })
end


-- Telescope
-------------

function PluginSetupTelescope()
  -- [[ Configure Telescope ]]
  -- See `:help telescope` and `:help telescope.setup()`
  require('telescope').setup {
    defaults = {
      mappings = {
        i = {
          ['<C-u>'] = false,
          ['<C-d>'] = false,
        },
      },
    },
  }

  -- Enable telescope fzf native, if installed
  pcall(require('telescope').load_extension, 'fzf')

  -- See `:help telescope.builtin`
  vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
  vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer' })

  vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
  vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sb', require('telescope.builtin').keymaps, { desc = '[S]earch [B]indings' })
end
