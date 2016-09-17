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

call plug#begin('~/.vim/plugged')
""""
Plug 'Tagbar'
Plug 'ctrlp.vim'
Plug 'auto-pairs'
Plug 'tpope/vim-surround'
Plug 'altercation/vim-colors-solarized'
Plug 'chaoren/vim-wordmotion'
"" Print syntax errors
Plug 'Syntastic'
"" Unit tests
Plug 'janko-m/vim-test'
Plug 'alfredodeza/coveragepy.vim'
"""" C/C++
Plug 'Rip-Rip/clang_complete', { 'for': ['c', 'cpp'] }
Plug 'xolox/vim-easytags'
""""
"""" Java
Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
""""
"""" LaTeX
Plug 'LaTeX-Box', { 'for': 'tex' }
Plug 'vim-latex/vim-latex', { 'for': 'tex' }
Plug 'gvim-pdfsync', { 'for': 'tex' }
""""
"""" Python
Plug 'zchee/deoplete-jedi', { 'for': 'python' }
""""
"""" Rust
Plug 'rust-lang/rust.vim'
" Enable it if you have racer installed
Plug 'racer-rust/vim-racer'
""""
"""" XML
Plug 'xmledit', { 'for': 'xml' }
""""
"""" Autocomplete code tricks
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'
""""
"" Multiple cursors, with ctrl+n
Plug 'terryma/vim-multiple-cursors'
"" Autocomplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
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
filetype on


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
set hidden         " Hide buffers when they are abandoned
set mouse=a	    	" Enable mouse usage (all modes)
"set showmatch		" Show matching brackets.
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


" Easytags
""""""""""
let g:easytags_async = 1
let g:easytags_include_members = 1


" Deoplete
""""""""""
let g:deoplete#disable_auto_complete = 1
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})
let g:deoplete#omni#input_patterns.php =
    \ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
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


" Clang_Complete
""""""""""""""""
" Already done with syntastic
let g:clang_hl_errors = 0
nmap <F5> :CopyDefinition<CR>
nmap <F6> :ImplementDefinition<CR>
command! CopyDefinition :call s:GetDefinitionInfo()
command! ImplementDefinition :call s:ImplementDefinition()
function! s:GetDefinitionInfo()
  exe 'normal ma'
  " Get class
  call search('^\s*\<class\>', 'b')
  exe 'normal ^w"ayw'
  let s:class = @a
  let l:ns = search('^\s*\<namespace\>', 'b')
  " Get namespace
  if l:ns != 0
    exe 'normal ^w"ayw'
    let s:namespace = @a
  else
    let s:namespace = ''
  endif
  " Go back to definition
  exe 'normal `a'
  exe 'normal "aY'
  let s:defline = substitute(@a, ';\n', '', '')
endfunction

function! s:ImplementDefinition()
  call append('.', s:defline)
  exe 'normal j'
  " Remove keywords
  s/\<virtual\>\s*//e
  s/\<static\>\s*//e
  if s:namespace == ''
    let l:classString = s:class . "::"
  else
    let l:classString = s:namespace . "::" . s:class . "::"
  endif
  " Remove default parameters
  s/\s\{-}=\s\{-}[^,)]\{1,}//e
  " Add class qualifier
  exe 'normal ^f(bi' . l:classString
  " Add brackets
  exe "normal $o{\<CR>\<TAB>\<CR>}\<CR>\<ESC>kkkk"
  " Fix indentation
  exe 'normal =4j^'
endfunction

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


" Solarized
""""""""""""
call togglebg#map("<F10>")


" Syntastic
""""""""""""
let g:syntastic_check_on_open = 1
let g:syntastic_c_compiler = 'clang'
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_c_compiler_options = ' -Wall -Wextra -Werror -pedantic -std=c11'
let g:syntastic_cpp_compiler_options = ' -Wall -Wextra -Werror -pedantic -std=c++11'
let g:syntastic_rst_checkers = ['rstcheck']
noremap <F7> :Errors<CR>


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
