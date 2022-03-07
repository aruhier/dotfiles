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

require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'ctrlpvim/ctrlp.vim'
  use 'windwp/nvim-autopairs'
  use 'tpope/vim-surround'
  use 'sainnhe/everforest'
  use 'chaoren/vim-wordmotion'
  use 'tpope/vim-sleuth'

  ---- Status line
  use {'nvim-lualine/lualine.nvim', requires={'kyazdani42/nvim-web-devicons'}}
  use {'romgrk/barbar.nvim', requires = {'kyazdani42/nvim-web-devicons'}}

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


-- Tabline
----------

local function setupBarbar()
  -- Move to previous/next
  map('n', '<A-,>', ':BufferPrevious<CR>', opts)
  map('n', '<A-.>', ':BufferNext<CR>', opts)
  -- Re-order to previous/next
  map('n', '<A-<>', ':BufferMovePrevious<CR>', opts)
  map('n', '<A->>', ' :BufferMoveNext<CR>', opts)
  -- Goto buffer in position...
  map('n', '<A-1>', ':BufferGoto 1<CR>', opts)
  map('n', '<A-2>', ':BufferGoto 2<CR>', opts)
  map('n', '<A-3>', ':BufferGoto 3<CR>', opts)
  map('n', '<A-4>', ':BufferGoto 4<CR>', opts)
  map('n', '<A-5>', ':BufferGoto 5<CR>', opts)
  map('n', '<A-6>', ':BufferGoto 6<CR>', opts)
  map('n', '<A-7>', ':BufferGoto 7<CR>', opts)
  map('n', '<A-8>', ':BufferGoto 8<CR>', opts)
  map('n', '<A-9>', ':BufferGoto 9<CR>', opts)
  map('n', '<A-0>', ':BufferLast<CR>', opts)
  -- Close buffer
  map('n', '<A-c>', ':BufferClose<CR>', opts)
  -- Wipeout buffer
  --                 :BufferWipeout<CR>
  -- Close commands
  --                 :BufferCloseAllButCurrent<CR>
  --                 :BufferCloseBuffersLeft<CR>
  --                 :BufferCloseBuffersRight<CR>
  -- Magic buffer-picking mode
  map('n', '<C-p>', ':BufferPick<CR>', opts)
  -- Sort automatically by...
  map('n', '<Space>bb', ':BufferOrderByBufferNumber<CR>', opts)
  map('n', '<Space>bd', ':BufferOrderByDirectory<CR>', opts)
  map('n', '<Space>bl', ':BufferOrderByLanguage<CR>', opts)

  vim.g.bufferline = {
    animation = false,
    auto_hide = true,
    tabpages = true,
    closable = true,
    clickable = true,

    -- Excludes buffers from the tabline
    exclude_ft = {'javascript'},
    exclude_name = {'package.json'},

    icons = 'numbers',
    icon_close_tab = 'X',

    insert_at_end = false,
    insert_at_start = false,

    maximum_padding = 1,
    maximum_length = 50,

    semantic_letters = true,
    letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

    no_name_title = nil,
  }
end
setupBarbar()


-- CtrlP
---------

vim.g['ctrlp_map'] = '<c-p>'
vim.g['ctrlp_cmd'] = 'CtrlP'
