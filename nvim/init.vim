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

call plug#begin(stdpath('data') . '/plugged')
""""
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'lifepillar/vim-solarized8'
Plug 'chaoren/vim-wordmotion'
Plug 'ciaranm/detectindent'
Plug 'tpope/vim-eunuch'
"" Multiple cursors, with ctrl+n
Plug 'terryma/vim-multiple-cursors'
"" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
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
set nohlsearch		" Disable highlight of results
set incsearch		" Incremental search
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set colorcolumn=80
set textwidth=0
autocmd FileType {c,cpp,go,java,python,rust,sh,tex} set textwidth=79
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
autocmd FileType python setlocal omnifunc=python3complete#Complete
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


" DetectIndent
""""""""""""""""
let g:detectindent_preferred_expandtab = 1
let g:detectindent_preferred_indent = 4

" Makefile
"" Make vim turn *off* expandtab for files named Makefile or makefile
"" We need the tab literal
autocmd FileType make let g:detectindent_preferred_expandtab = 1


" Solarized
""""""""""""
map <F10> :let &background = ( &background == "dark"? "light" : "dark" )<CR>


    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""" SOURCE SYSTEM CONFIG """""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif
