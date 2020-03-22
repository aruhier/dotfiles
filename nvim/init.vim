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
    """"""""""""""""""""""""""" VIM-PLUG """""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.vim/plugged')
""""
Plug 'majutsushi/tagbar'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'lifepillar/vim-solarized8'
Plug 'chaoren/vim-wordmotion'
Plug 'dhruvasagar/vim-table-mode'
Plug 'ciaranm/detectindent'
Plug 'rhysd/vim-grammarous'
Plug 'tpope/vim-eunuch'
Plug 'Shougo/echodoc.vim'
"" Print syntax errors
Plug 'w0rp/ale'
"" Unit tests
Plug 'janko-m/vim-test'
Plug 'alfredodeza/coveragepy.vim', { 'for': 'python' }
"""" C/C++
Plug 'jsfaint/gen_tags.vim'
""""
"""" LaTeX
Plug 'lervag/vimtex', { 'for': 'tex' }
""""
"""" Python
" Requires python rope
Plug 'python-rope/ropevim', { 'for': 'python' }
Plug 'psf/black', { 'for': 'python', 'tag': 'stable' }
""""
"""" Rust
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
""""
"""" XML
Plug 'sukima/xmledit', { 'for': 'xml' }
""""
"""" Autocomplete code tricks
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
""""
"" Multiple cursors, with ctrl+n
Plug 'terryma/vim-multiple-cursors'
"" Autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-rls', {'do': 'yarn install --frozen-lockfile'}
Plug 'clangd/coc-clangd', {'do': 'yarn install --frozen-lockfile'}
"" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"""" Git support
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'rhysd/git-messenger.vim'
""""
"" For notes management
Plug 'xolox/vim-notes'
"""" Depends
Plug 'xolox/vim-misc'
""""
call plug#end()
filetype on


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """""""""""""""""""" GENERAL CONFIGURATION """""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
syntax on

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
let g:solarized_statusline = 'flat'
set background=dark
colorscheme solarized8
set termguicolors

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"if has("autocmd")
"  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

"set autowrite		" Automatically save before commands like :next and :make
set hidden         " Hide buffers when they are abandoned
set mouse=a	    	" Enable mouse usage (all modes)
"set showmatch		" Show matching brackets.
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
set colorcolumn=120
set textwidth=0
autocmd FileType {c,sh} set textwidth=79
autocmd FileType python set textwidth=88 colorcolumn=89
autocmd FileType {go,rust} set textwidth=119 colorcolumn=120
set encoding=utf-8
set guioptions-=m   " Remove menubar in gvim
set guioptions-=T   " Remove toolbar in gvim
set shell=sh

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

" Syntax
"" automatic recognition of filetype
filetype plugin indent on
filetype plugin on
syntax on
syntax sync fromstart

" Autocompletion
set wildmenu
set wildmode=list:longest,full
set wildignore+=*.pyc,*.o,*.aux,*.toc,*.dvi    " ignored on autocomplete
set completeopt=longest,menu,menuone,preview    " cool completion view
set complete=.,w,b,u,U,t,i      " mega tab completion
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif

" Python
autocmd FileType python nmap <F5> :!python %<CR>

" Cpp
"" Autgen skeleton from header
noremap \PP :! stubgen -n %<CR>

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


" Airline
""""""""""
"" Need to install ttf-powerline-fonts-git in AUR
let g:airline_powerline_fonts = 1


" ALE (Asynchronous Lint Engine)
""""""""""""""""""""""""""""""""
nmap <silent> <F7> <Plug>(ale_previous)
nmap <silent> <F8> <Plug>(ale_next)
let g:ale_python_flake8_options = '--ignore=C0111,E501'
let g:ale_python_pylint_options = '--disable=C0111,E501'


" Black
"""""""
nnoremap <F9> :Black<CR>


" COC
"""""

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" Prefer getting them from vim plug when possible
let g:coc_global_extensions = ["coc-neosnippet", ]

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>


" CtrlP
""""""""
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'


" DetectIndent
""""""""""""""""
let g:detectindent_preferred_expandtab = 1
let g:detectindent_preferred_indent = 4

" Makefile
"" Make vim turn *off* expandtab for files named Makefile or makefile
"" We need the tab literal
autocmd FileType make let g:detectindent_preferred_expandtab = 1


" EchoDoc
"""""""""
set noshowmode
let g:echodoc#enable_at_startup = 1


" Gen-tags
""""""""
let g:gen_tags#ctags_auto_gen = 1
let g:loaded_gentags#gtags = 1


" Neosnippet
"""""""""""""
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)


" Ropevim
""""""""""""
" Add ropevim in path
let $PYTHONPATH .= ':'.$HOME.'/.vim/plugged/ropevim'


" Rust
""""""
let g:rustfmt_autosave = 1


" Solarized
""""""""""""
map <F10> :let &background = ( &background == "dark"? "light" : "dark" )<CR>


" Tagbar
"""""""""
let g:tagbar_left = 1
cnoreabbrev tb Tagbar


" Test
"""""""
let g:test#strategy = "neovim"


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""" SOURCE SYSTEM CONFIG """""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif
