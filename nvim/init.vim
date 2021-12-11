" All system-wide defaults are set in $VIMRUNTIME/archlinux.vim (usually just
" /usr/share/vim/vimfiles/archlinux.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vimrc), since archlinux.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing archlinux.vim since it alters the value of the
" 'compatible' option.

set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages.
runtime! archlinux.vim debian.vim

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""" SOURCE SYSTEM CONFIG """""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""" VIM-PLUG """""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin(stdpath('data') . '/plugged')
""""
Plug 'liuchengxu/vista.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'windwp/nvim-autopairs'
Plug 'tpope/vim-surround'
Plug 'sainnhe/everforest'
Plug 'chaoren/vim-wordmotion'
Plug 'dhruvasagar/vim-table-mode'
Plug 'tpope/vim-sleuth'
Plug 'rhysd/vim-grammarous'
"" Unit tests
Plug 'janko-m/vim-test'
Plug 'alfredodeza/coveragepy.vim', { 'for': 'python' }
""""
"""" LaTeX
Plug 'lervag/vimtex', { 'for': 'tex' }
""""
"""" Python
Plug 'psf/black', { 'for': 'python', 'tag': 'stable' }
""""
"""" Rust
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
""""
"""" XML
Plug 'sukima/xmledit', { 'for': 'xml' }
""""
"" Multiple cursors, with ctrl+n
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
"" Autocomplete
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'williamboman/nvim-lsp-installer'
"" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"" Code diagnostic
Plug 'folke/trouble.nvim'
"" Status line
Plug 'nvim-lualine/lualine.nvim'
"""" Git support
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'
Plug 'rhysd/git-messenger.vim'
""""
"" For notes management
Plug 'xolox/vim-notes'
"""" Depends
Plug 'xolox/vim-misc'
" Dependency of trouble.nvim and lualine.nvim
Plug 'kyazdani42/nvim-web-devicons'
""""
call plug#end()


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """""""""""""""""""" GENERAL CONFIGURATION """""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syntax on

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"if has("autocmd")
"  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

set nu		    	" Line numbers
set laststatus=2	" Enable status
set statusline=%<%f%h%m%r%=%l,%c\ %P
set noerrorbells	" No beep
autocmd BufWritePre * :%s/\s\+$//e	" Delete whitespace at the endline
set tabstop=4          " Ident of 4 whitespaces
set shiftwidth=4
set expandtab
set autoindent		" Text indenting
set softtabstop=4
set scrolloff=10	" 10 lines before and after the cursor position
set nohlsearch		" Disable highlight of results
set incsearch		" Incremental search
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set colorcolumn=120 textwidth=119 fo-=t  " Disable autowrapping
autocmd FileType {c,sh} set textwidth=79 colorcolumn=80 fo+=t
autocmd FileType python set textwidth=88 colorcolumn=89 fo+=t
autocmd FileType {go,rust} set textwidth=119 colorcolumn=120 fo+=t
set encoding=utf-8
set guioptions-=m   " Remove menubar in gvim
set guioptions-=T   " Remove toolbar in gvim

" Remapping
noremap tt :tabprevious<CR>
noremap ty :tabnext<CR>
noremap <F4> :set hlsearch! hlsearch?<CR>
"" Avoid <Esc>
inoremap jk <Esc>
cnoremap jk <C-c>
onoremap jk <Esc>
vnoremap ii <Esc>
"" M for Macros
noremap Mse :set spell spelllang=en<CR>
noremap Msf :set spell spelllang=fr<CR>

" Command alias
cnoreabbrev t tabnew

" Autocompletion
set completeopt=menu,menuone,noselect

" Makefile
"" Make vim turn *off* expandtab for files named Makefile or makefile
"" We need the tab literal
autocmd FileType make set noexpandtab

" Spell Check
set spelllang=fr
" Spell Check for *.txt and *.tex :
autocmd FileType {text,tex} set spell spelllang=fr


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """""""""""""""""""""""""" EXTENSIONS """"""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Solarized
""""""""""""
set termguicolors
map <F10> :let &background = ( &background == "dark"? "light" : "dark" )<CR>
set background=dark
let g:everforest_background = 'medium'
let g:everforest_ui_contrast = 'high'
let g:everforest_better_performance = 1
colorscheme everforest


" Status line
"""""""""""""
lua << END
solarized_dark = require'lualine.themes.solarized_dark'
solarized_dark.normal.b.bg = '#808e8e'
solarized_dark.inactive.b.bg = '#808e8e'
solarized_dark.insert.a.bg = '#b58900'
solarized_light = require'lualine.themes.solarized_light'
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
END


" nvim-lsp
""""""""""

lua << EOF
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
    diagnostic_message = diagnostic_message .. " […]"
  end

  local chunks = {{ kind .. ':', hlgroup }, { ' ' .. diagnostic_message }}
  print(chunks)
  vim.api.nvim_echo(chunks, false, {})
end

vim.cmd [[ autocmd CursorHold * lua PrintDiagnostics() ]]
EOF


" nvim-cmp
""""""""""

set updatetime=300
lua <<EOF
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  local cmp = require'cmp'
  cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
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
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
EOF


" nvim-lsp-installer
""""""""""""""""""""

lua <<EOF
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

  local lsp_installer = require("nvim-lsp-installer")

  local servers = {"rust_analyzer", "clangd", "gopls", "pyright"}

  for _, s in ipairs(servers) do
    local ok, server = lsp_installer.get_server(s)
    if ok then
      if not server:is_installed() then
        server:install()
      end
    end
  end

  lsp_installer.on_server_ready(function(server)
      local opts = {on_attach=on_attach}
      server:setup(opts)
  end)
EOF


" Black
"""""""
nnoremap <F9> :Black<CR>


" CtrlP
""""""""
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'


" Gitsigns
""""""""""

lua << EOF
require('gitsigns').setup()
EOF


" Rust
""""""
let g:rustfmt_autosave = 1


" Treesitter
""""""""""""
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  ignore_install = {},
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false,
  },
}
EOF


" Trouble
"""""""""

lua << EOF
  require("trouble").setup {}
EOF
nnoremap <leader>xx <cmd>TroubleToggle<cr>
nnoremap <leader>xw <cmd>TroubleToggle lsp_workspace_diagnostics<cr>
nnoremap <leader>xd <cmd>TroubleToggle lsp_document_diagnostics<cr>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
nnoremap gR <cmd>TroubleToggle lsp_references<cr>


" Vista
"""""""

" Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
let g:vista#renderer#enable_icon = 0
let g:vista_sidebar_position = 'vertical topleft'
let g:vista_sidebar_width = 60


" Test
"""""""
let g:test#strategy = "neovim"
