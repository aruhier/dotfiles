-- All system-wide defaults are set in $VIMRUNTIME/archlinux.vim (usually just
-- /usr/share/vim/vimfiles/archlinux.vim) and sourced by the call to :runtime
-- you can find below.  If you wish to change any of those settings, you should
-- do it in this file (/etc/vimrc), since archlinux.vim will be overwritten
-- everytime an upgrade of the vim packages is performed.  It is recommended to
-- make changes after sourcing archlinux.vim since it alters the value of the
-- 'compatible' option.

vim.opt.runtimepath = {'~/.vim', '$VIM/vimfiles', '$VIMRUNTIME', '$VIM/vimfiles/after', '~/.vim/after'}

-- This line should not be removed as it ensures that various options are
-- properly set to work with the Vim-related packages.
vim.cmd [[ runtime! archlinux.vim debian.vim ]]

  ----------------------------------------------------------------
  --------------------------- VIM-PLUG ---------------------------
  ----------------------------------------------------------------

local Plug = vim.fn['plug#']
vim.call('plug#begin', vim.fn.stdpath('data')..'/plugged')

Plug 'ctrlpvim/ctrlp.vim'
Plug 'windwp/nvim-autopairs'
Plug 'tpope/vim-surround'
Plug 'sainnhe/everforest'
Plug 'chaoren/vim-wordmotion'
Plug 'tpope/vim-sleuth'
-- Multiple cursors, with ctrl+n
Plug('mg979/vim-visual-multi', {branch = 'master'})
-- Status line
Plug 'nvim-lualine/lualine.nvim'
-- Dependency of lualine.nvim
Plug 'kyazdani42/nvim-web-devicons'

vim.call('plug#end')

  ----------------------------------------------------------------
  -------------------- GENERAL CONFIGURATION ---------------------
  ----------------------------------------------------------------

local map = vim.api.nvim_set_keymap

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
        {'diagnostics', sources={'nvim_diagnostic'}, colored=false, icons_enabled=false}
      },
      lualine_c = {'filename'},
      lualine_x = {'encoding', {'fileformat' , icons_enabled=false}, {'filetype', icons_enabled=false}},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    extensions = {}
  }
end
setupLualine()


-- CtrlP
---------

vim.g['ctrlp_map'] = '<c-p>'
vim.g['ctrlp_cmd'] = 'CtrlP'
