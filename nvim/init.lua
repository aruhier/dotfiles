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

  use 'liuchengxu/vista.vim'
  use 'ctrlpvim/ctrlp.vim'
  use 'windwp/nvim-autopairs'
  use 'tpope/vim-surround'
  use 'sainnhe/everforest'
  use 'chaoren/vim-wordmotion'
  use 'dhruvasagar/vim-table-mode'
  use 'tpope/vim-sleuth'
  use 'rhysd/vim-grammarous'

  -- Multiple cursors, with ctrl+n
  use {'mg979/vim-visual-multi', branch = 'master'}

  ---- Autocomplete
  use 'neovim/nvim-lspconfig'
  use {'hrsh7th/nvim-cmp', requires={
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/vim-vsnip',
  }}
  use {'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim', requires={'neovim/nvim-lspconfig'}}

  ---- Treesitter
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  ---- Code diagnostic
  use {'folke/trouble.nvim', requires={'kyazdani42/nvim-web-devicons'}}
  ---- Status line
  use {'nvim-lualine/lualine.nvim', requires={'kyazdani42/nvim-web-devicons', 'arkav/lualine-lsp-progress'}}
  use {'romgrk/barbar.nvim', requires = {'kyazdani42/nvim-web-devicons'}}
  ---- Unit tests
  use 'janko-m/vim-test'
  use {'alfredodeza/coveragepy.vim', ft = {'python'}}
  ---- LaTeX
  use {'lervag/vimtex', ft = {'tex'}}
  ---- Python
  use {'psf/black', ft = {'python'}}
  ---- Rust
  use {'rust-lang/rust.vim', ft = {'rust'}}
  ---- XML
  use {'sukima/xmledit', ft = {'xml'}}

  ---- Git support
  use {'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' }}
  use 'tpope/vim-fugitive'
  use 'rhysd/git-messenger.vim'

  ---- For notes management
  use {'xolox/vim-notes', requires={'xolox/vim-misc'}}
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
--  if has('autocmd')
--    au BufReadPost * if line('"\"') > 1 && line('"\"') <= line('$') | exe 'normal! g"\"' | endif
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
      lualine_c = {'filename', 'lsp_progress'},
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


-- nvim-lsp
------------

vim.diagnostic.config({virtual_text = false})

-- Print LSP diagnostic in the message bar.
-- Only prints the first error, and adds […] to indicate that more are present.
function PrintDiagnostics(opts, bufnr, line_nr, client_id)
  local warning_hlgroup = 'WarningMsg'
  local error_hlgroup = 'ErrorMsg'

  opts = opts or {}

  bufnr = bufnr or 0
  line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)

  local line_diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr, line_nr, opts, client_id)
  if vim.tbl_isempty(line_diagnostics) then return end

  local diagnostic = line_diagnostics[1]
  local kind = 'warning'
  local hlgroup = warning_hlgroup

  if diagnostic.severity == vim.lsp.protocol.DiagnosticSeverity.Error then
    kind = 'error'
    hlgroup = error_hlgroup
  end

  local diagnostic_message = diagnostic.message
  if table.getn(line_diagnostics) > 1 then
    diagnostic_message = diagnostic_message .. ' […]'
  end

  local chunks = {{ kind .. ':', hlgroup }, { ' ' .. diagnostic_message }}
  print(chunks)
  vim.api.nvim_echo(chunks, false, {})
end
vim.cmd [[ autocmd CursorHold * lua PrintDiagnostics() ]]


-- nvim-cmp
------------

local function setupNvimCMP()
  vim.opt.updatetime = 300

  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  local cmp = require'cmp'
  cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn['vsnip#anonymous'](args.body)
      end,
    },
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
end
setupNvimCMP()


-- Mason LSP
------------

local function setupLSPInstaller()
  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end

  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = {'rust_analyzer', 'clangd', 'gopls', 'pyright'},
  })

  require("mason-lspconfig").setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function (server_name) -- default handler (optional)
      require("lspconfig")[server_name].setup {on_attach=on_attach}
    end,
  }
end
setupLSPInstaller()


-- Black
---------

map('n', '<F9>', ':Black<CR>', {noremap = true})


-- CtrlP
---------

vim.g['ctrlp_map'] = '<c-p>'
vim.g['ctrlp_cmd'] = 'CtrlP'


-- Gitsigns
------------

require('gitsigns').setup()


-- Rust
--------

vim.g['rustfmt_autosave'] = 1


-- Treesitter
--------------

require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  ignore_install = {},
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false,
  },
}


-- Trouble
-----------

require('trouble').setup()
map('n', '<leader>xx', '<cmd>Trouble<cr>', {silent = true, noremap = true})
map('n', '<leader>xw', '<cmd>Trouble workspace_diagnostics<cr>', {silent = true, noremap = true})
map('n', '<leader>xd', '<cmd>Trouble document_diagnostics<cr>', {silent = true, noremap = true})
map('n', '<leader>xl', '<cmd>Trouble loclist<cr>', {silent = true, noremap = true})
map('n', '<leader>xq', '<cmd>Trouble quickfix<cr>', {silent = true, noremap = true})
map('n', 'gR', '<cmd>Trouble lsp_references<cr>', {silent = true, noremap = true})


-- Vista
---------

vim.g['vista#renderer#enable_icon'] = 0
vim.g['vista_sidebar_position'] = 'vertical topleft'
vim.g['vista_sidebar_width'] = 60


-- Test
--------

vim.g['test#strategy'] = 'neovim'
