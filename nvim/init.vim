" All system-wide defaults are set in $VIMRUNTIME/archlinux.vim (usually just
" /usr/share/vim/vimfiles/archlinux.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vimrc), since archlinux.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing archlinux.vim since it alters the value of the
" 'compatible' option.

set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""" VIM-PLUG """""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype on
call plug#begin('~/.vim/plugged')
""""
Plug 'Tagbar'
Plug 'ctrlp.vim'
Plug 'auto-pairs'
Plug 'altercation/vim-colors-solarized'
"" Print syntax errors
Plug 'Syntastic'
"""" C/C++
Plug 'clang-complete'
Plug 'xolox/vim-easytags'
""""
"""" LaTeX
Plug 'LaTeX-Box'
Plug 'git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex'
Plug 'gvim-pdfsync'
""""
"""" Python
Plug 'davidhalter/jedi-vim'
""""
"""" Rust
Plug 'rust-lang/rust.vim'
""""
"""" XML
Plug 'xmledit'
""""
"""" Autocomplete code tricks
Plug 'Shougo/neosnippet'
""""
"" Multiple cursors, with ctrl+n
Plug 'terryma/vim-multiple-cursors'
"" Autocomplete
Plug 'Shougo/deoplete.nvim'
"" Airline
Plug 'bling/vim-airline'
"""" Git support
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
""""
"" For notes management
Plug 'xolox/vim-notes'
"""" Depends
Plug 'xolox/vim-misc'
Plug 'vim-addon-mw-utils'
Plug 'tlib'
Plug 'Shougo/neosnippet-snippets'
""""
call plug#end()


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """""""""""""""""""" GENERAL CONFIGURATION """""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages.
runtime! archlinux.vim debian.vim

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
syntax on

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark
colorscheme solarized

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"if has("autocmd")
"  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

"set autowrite		" Automatically save before commands like :next and :make
"set hidden         " Hide buffers when they are abandoned
set mouse=a	    	" Enable mouse usage (all modes)
set showmatch		" Show matching brackets.
set nu		    	" Line numbers
set laststatus=2	" Enable status
set statusline=%<%f%h%m%r%=%l,%c\ %P
set noerrorbells	" No beep
autocmd BufWritePre * :%s/\s\+$//e	" Delete whitespace at the endline
set tabstop=4		" Ident of 4 whitespaces
set shiftwidth=4
set expandtab
set autoindent		" Text indenting
set softtabstop=4
set scrolloff=10	" 10 lines before and after the cursor position
set hlsearch		" Highlight of results
set incsearch		" Incremental search
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set t_Co=256		" 256 colors mode
set colorcolumn=80
set textwidth=0
autocmd BufEnter {*.c,*.cpp,*.java,*.py,*.rs,*.sh,*.tex} set textwidth=79
set encoding=utf-8
set guioptions-=m   " Remove menubar in gvim
set guioptions-=T   " Remove toolbar in gvim

" Remapping
noremap tt :tabprevious<CR>
noremap ty :tabnext<CR>
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
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif

" Python
autocmd BufRead *.py nmap <F5> :!python %<CR>

" Cpp
"" Autgen skeleton from header
noremap \PP :! stubgen -n %<CR>

" Makefile
"" Make vim turn *off* expandtab for files named Makefile or makefile
"" We need the tab literal
autocmd BufNewFile,BufRead [Mm]akefile* set noexpandtab

" Spell Check
set spelllang=fr
" Spell Check for *.txt and *.tex :
autocmd BufEnter {*.txt,*.tex} set spell spelllang=fr


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """""""""""""""""""""""""" EXTENSIONS """"""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Airline
""""""""""
"" Need to install ttf-powerline-fonts-git in AUR
let g:airline_powerline_fonts = 1


" Jedi
""""""
"" Disable popup on dot with deoplete
let g:jedi#popup_on_dot = 0


" Deoplete
""""""""""
let g:deoplete#disable_auto_complete = 1
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})
let g:deoplete#omni#input_patterns.php =
    \ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
let g:deoplete#omni#input_patterns.c =
    \ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
let g:deoplete#omni#input_patterns.cpp =
    \ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"
function! s:check_back_space() "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}
inoremap <silent><expr> <Tab>
		\ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
		\ deoplete#mappings#manual_complete()
inoremap <silent><expr> <S-Tab>
		\ pumvisible() ? "\<C-p>" :
        \ <SID>check_back_space() ? "\<S-TAB>" :
		\ deoplete#mappings#manual_complete()

autocmd BufEnter {*.c,*.cpp,*.html,*.js,*.java,*.php,*.py,*.rs,*.sh,*.tex}
            \ let g:deoplete#disable_auto_complete = 0


" CtrlP
""""""""
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'


" Eclim
""""""""
let g:EclimCompletionMethod = 'omnifunc'


" LatexSuite
"""""""""""""
let g:tex_flavor = "latex"
let g:Tex_DefaultTargetFormat = "pdf"
let g:Tex_SmartKeyQuote = 0
let g:Tex_CompileRule_pdf = 'pdflatex -synctex=1 -interaction=nonstopmode $*'
"let g:tex_conceal = ""
""""" Latexsuite, french caracters (éàè, etc...)
""""" CREATE OR EDIT THE FILE ~/.vim/bundle/vim-latex/ftplugin/tex.vim, and
""""" add :
"" imap <C-b> <Plug>Tex_MathBF
"" imap <C-c> <Plug>Tex_MathCal
"" imap <C-l> <Plug>Tex_LeftRight
"" imap <buffer> <leader>it <Plug>Tex_InsertItemOnThisLine


" Neosnippet
"""""""""""""
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

"For snippet_complete marker.
" if has('conceal')
"   set conceallevel=2 concealcursor=i
" endif


" Syntastic
""""""""""""
let g:syntastic_check_on_open = 1
let g:syntastic_c_compiler = 'gcc'
let g:syntastic_cpp_compiler = 'gcc'
let g:syntastic_c_compiler_options = ' -Wall -Wextra -Werror -pedantic -std=c11'
let g:syntastic_cpp_compiler_options = ' -Wall -Wextra -Werror'
let g:syntastic_rst_checkers = ['rstcheck']
noremap <F7> :Errors<CR>


" Tagbar
"""""""""
let g:tagbar_left = 1


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""" SOURCE SYSTEM CONFIG """""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif