  ----------------------------------------------------------------
  --------------------------- VIM-PLUG ---------------------------
  ----------------------------------------------------------------

require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'ctrlpvim/ctrlp.vim'
  use 'windwp/nvim-autopairs'
  use 'tpope/vim-surround'
  use 'sainnhe/everforest'
  use 'chaoren/vim-wordmotion'
  use 'tpope/vim-sleuth'
  use 'chentoast/marks.nvim'
  use 'shellRaining/hlchunk.nvim'

  ---- Status line
  use {'aruhier/lualine.nvim', branch = 'pr_tabs', requires={'kyazdani42/nvim-web-devicons'}}

  -- Multiple cursors, with ctrl+n
  use {'mg979/vim-visual-multi', branch = 'master'}
end)

  ----------------------------------------------------------------
  -------------------- GENERAL CONFIGURATION ---------------------
  ----------------------------------------------------------------

local map = vim.api.nvim_set_keymap
local opts = { noremap=true, silent=true }

vim.opt.syntax = 'on'

-- Uncomment the following to have Vim jump to the last position when
-- reopening a file
-- vim.cmd [[
--  if has("autocmd")
--    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
--  endif
--]]

-- Line numbers.
vim.opt.nu = true
-- Disable mouse features.
vim.opt.mouse = ''
-- Enable status.
vim.opt.errorbells = false
-- Delete whitespace at the endline.
vim.cmd [[ autocmd BufWritePre * :%s/\s\+$//e ]]
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.scrolloff = 10
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.encoding = 'utf-8'
-- Disable autowrapping.
vim.opt.colorcolumn = '120'
vim.opt.textwidth = 119
vim.opt.fo:remove('t')
vim.cmd [[
  autocmd FileType {c,sh} set textwidth=79 colorcolumn=80 fo+=t
  autocmd FileType python set textwidth=88 colorcolumn=89 fo+=t
  autocmd FileType {go,rust} set textwidth=119 colorcolumn=120 fo+=t
]]

-- Mappings.
map('n', 'tt', ':tabprevious<CR>', {noremap = true})
map('n', 'ty', ':tabnext<CR>', {noremap = true})
map('n', '<F4>', '<cmd>lua vim.opt.hlsearch = !vim.opt.hlsearch<CR>', {noremap = true})
-- Avoid <Esc>.
for _, m in ipairs({'i', 'c', 'o'}) do
  map(m, 'jk', '<Esc>', {noremap = true})
end
map('v', 'ii', '<Esc>', {noremap = true})
-- M for Macros.
map('n', 'Mse', ':set spell spelllang=en<CR>', {noremap = true})
map('n', 'Msf', ':set spell spelllang=fr<CR>', {noremap = true})

-- Command aliases.
vim.cmd [[ cnoreabbrev t tabnew ]]

-- Autocompletion
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

-- Makefile
-- Make vim turn *off* expandtab for files named Makefile or makefile
-- We need the tab literal
vim.cmd [[ autocmd FileType make set noexpandtab ]]

-- Spell Check
vim.opt.spelllang = 'en'
-- Spell Check for *.txt and *.tex :
vim.cmd [[ autocmd FileType {text,tex} set spell spelllang=en ]]


    ----------------------------------------------------------------
    -------------------------- EXTENSIONS --------------------------
    ----------------------------------------------------------------


-- Theme
---------

vim.opt.termguicolors = true
map('n', '<F10>', ':let &background = ( &background == "dark"? "light" : "dark" )<CR>', {})
vim.opt.background = 'dark'
vim.g['everforest_background'] = 'medium'
vim.g['everforest_ui_contrast'] = 'high'
vim.g['everforest_better_performance'] = 1
vim.cmd [[ colorscheme everforest ]]


-- Status line
---------------

local function setupLualine()
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
setupLualine()


-- CtrlP
---------

vim.g['ctrlp_map'] = '<c-p>'
vim.g['ctrlp_cmd'] = 'CtrlP'


-- HL Chunk
-----------------

require('hlchunk').setup({
  -- Used a color blender between everforest comment color (#859289) and everforest fg_red (#f85552).
  -- Use a slightly brighter color to make it more readable.
  line_num = {
    style = "#a49088",
  },
  -- Used a color blender between everforest comment color (#859289) and everforest fg_red (#f85552).
  chunk = {
    style = {
      { fg = "#9A877F" },
    },
  },
})


-- Marks
--------

require'marks'.setup()
