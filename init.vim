""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set showtabline=0               "Hide top tab bar" 
set guioptions-=r               "Hide right scrollbar" 
set guioptions-=L               "Hide left scrollbar"
set guioptions-=b               "Hide bottom scrollbar"
set cursorline
" set cursorcolumn
" set langmenu=zh_CN.UTF-8

" Prevent quitting vim
cabbrev q <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'close' : 'q')<CR>

inoremap jk <esc>

let mapleader="\<Space>"
let maplocalleader="\\"

" Sets how many lines of history VIM has to remember
" set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,gbk,latin1

" Use Unix as the standard file type
set fileformats=unix,dos,mac

set ttyfast
set ignorecase
set smartcase

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Set 7 lines to the cursor - when moving vertically using j/k
set scrolloff=7

" Turn on the Wild menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"Always show current position
set ruler

set autoindent             " Indent according to previous line
set smartindent        " Smart Indent
set expandtab              " Use spaces instead of tabs
set softtabstop =4         " Tab key indents by 4 spaces
set shiftwidth  =4         " >> indents by 4 spaces
set shiftround             " >> indents to next multiple of 'shiftwidth'

" Linebreak on 500 characters
set linebreak
set textwidth=500
set wrap

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Switch between buffers without having to save first.
set hidden

" Height of the command bar
set cmdheight=2

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch 

" Don't redraw while executing macros (good performance config)
set lazyredraw 

" Show matching brackets when text indicator is over them
set showmatch 
" How many tenths of a second to blink when matching brackets
set matchtime=2

" Add a bit extra margin to the left
" set foldcolumn=1

" No annoying sound on errors
set noerrorbells
set novisualbell

" <Leader>r -- Cycle through relativenumber + number, number (only), and no
" numbering (mnemonic: relative).
nnoremap <silent> <Leader>r :call Cycle_numbering()<CR>

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""

" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowritebackup
set noswapfile

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Smart way to move between windows
" map <C-j> <C-W>j
" map <C-k> <C-W>k
" map <C-h> <C-W>h
" map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 
map <leader>t<leader> :tabnext 

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()


" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" delete marks on current line
nnoremap <silent> dm :<c-u>call Delmarks()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

function! Cycle_numbering() abort
  if exists('+relativenumber')
    execute {
          \ '00': 'set relativenumber   | set number',
          \ '01': 'set norelativenumber | set number',
          \ '10': 'set norelativenumber | set nonumber',
          \ '11': 'set norelativenumber | set number' }[&number . &relativenumber]
  else
    " No relative numbering, just toggle numbers on and off.
    set number!<CR>
  endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction 

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
function! Delmarks()
    let l:m = join(filter(
       \ map(range(char2nr('a'), char2nr('z')), 'nr2char(v:val)'),
       \ 'line("''".v:val) == line(".")'))
    if !empty(l:m)
        exe 'delmarks' l:m
    endif
endfunction

""""""""""""""""""""""""""""""
" => JavaScript section
"""""""""""""""""""""""""""""""

au FileType javascript call JavaScriptFold()
au FileType javascript setl fen
au FileType javascript setl nocindent
au FileType javascript setl nowrap

au FileType javascript imap <c-t> $log();<esc>hi
au FileType javascript imap <c-a> alert();<esc>hi

au FileType javascript inoremap <buffer> $r return 
au FileType javascript inoremap <buffer> $f // --- PH<esc>FP2xi

function! JavaScriptFold() 
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
        return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction

""""""""""""""""""""""""""""""
" => TypeScript section
"""""""""""""""""""""""""""""""
" autocmd BufEnter *.tsx set filetype=typescript
au FileType typescript call TypeScriptFold()
au FileType typescript setl fen
au FileType typescript setl nocindent
au FileType typescript setl nowrap

au FileType typescript imap <c-t> $log();<esc>hi
au FileType typescript imap <c-a> alert();<esc>hi

au FileType typescript inoremap <buffer> $r return 
au FileType typescript inoremap <buffer> $f // --- PH<esc>FP2xi

au FileType typescript.tsx call TypeScriptFold()
au FileType typescript.tsx setl fen
au FileType typescript.tsx setl nocindent
au FileType typescript.tsx setl nowrap

au FileType typescript.tsx imap <c-t> $log();<esc>hi
au FileType typescript.tsx imap <c-a> alert();<esc>hi

au FileType typescript.tsx inoremap <buffer> $r return 
au FileType typescript.tsx inoremap <buffer> $f // --- PH<esc>FP2xi

function! TypeScriptFold() 
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
        return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction

""""""""""""""""""""""""""""""
" => Python section
""""""""""""""""""""""""""""""

let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

au FileType python map <buffer> F :set foldmethod=indent<cr>

au FileType python inoremap <buffer> $r return 
au FileType python inoremap <buffer> $i import 
au FileType python inoremap <buffer> $p print 
au FileType python inoremap <buffer> $f # --- <esc>a
au FileType python map <buffer> <leader>1 /class 
au FileType python map <buffer> <leader>2 /def 
au FileType python map <buffer> <leader>C ?class 
au FileType python map <buffer> <leader>D ?def 
au FileType python set cindent
au FileType python set cinkeys-=0#
au FileType python set indentkeys-=0#

""""""""""""""""""""""""""""""
" => vim-plug 
""""""""""""""""""""""""""""""

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')
" Declare the list of plugins.

Plug 'kaicataldo/material.vim' "Theme
Plug 'itchyny/lightline.vim' "Status bar
Plug 'sheerun/vim-polyglot' " Syntax highlight

Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-commentary' " gc comment
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat' " enable repeating supported plugin maps with .
Plug 'tpope/vim-fugitive' " Status bar git branch name
Plug 'vim-scripts/TaskList.vim'
Plug 'vim-scripts/bufexplorer.zip'
Plug 'vim-scripts/YankRing.vim' "Maintains a history of previous yanks, changes and deletes
Plug 'vim-scripts/CmdlineComplete' "Ctrl-P or Ctrl-N to complete cmd

Plug 'tmhedberg/matchit' "extended % matching for html, latex, and many other languages
Plug 'kshenoy/vim-signature' " display and navigate marks
Plug 'airblade/vim-gitgutter' "git diff
Plug 'majutsushi/tagbar' "tag outline
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dyng/ctrlsf.vim'                               "search and view tool

Plug 'jiangmiao/auto-pairs'
Plug 'Yggdroot/indentLine'
Plug 'luochen1990/rainbow' "Rainbow Parentheses

" list ends here. plugins become visible to vim after this call.
call plug#end()

""""""""""""""""""""""""""""""
" => theme 
""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable 
set background=dark

if (has('nvim'))
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

if has("termguicolors")
    set termguicolors
endif

let &t_ZH="\<Esc>[3m"
let &t_ZR="\<Esc>[23m"
let g:material_terminal_italics = 1

let g:material_theme_style = 'palenight'
colorscheme material
" highlight Normal ctermbg=None

let g:lightline = { 'colorscheme': 'material_vim' }

""""""""""""""""""""""""""""""
" => vim-polyglot
"""""""""""""""""""""""""""""
" This line prevents polyglot from loading markdown packages.
" let g:polyglot_disabled = ['md', 'markdown']

""""""""""""""""""""""""""""""
" => bufExplorer plugin
""""""""""""""""""""""""""""""

let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=0
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'
map <leader>o :BufExplorer<cr>

""""""""""""""""""""""""""""""
" => ctrlp
""""""""""""""""""""""""""""""

"let g:ctrlp_working_path_mode = 0
let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git'

""""""""""""""""""""""""""""""
" => indentLine
""""""""""""""""""""""""""""""
let g:indentLine_enabled=1
let g:indentLine_char='¦'
let g:indent_guides_start_level=1

""""""""""""""""""""""""""""""
" => vim-gitgutter
""""""""""""""""""""""""""""""
" let g:gitgutter_highlight_lines = 1

""""""""""""""""""""""""""""""
"=> Rainbow
""""""""""""""""""""""""""""""
let g:rainbow_active = 1
let g:rainbow_conf = {
    \ 'separately': {
    \    'nerdtree': 0,
    \  }
    \}

""""""""""""""""""""""""""""""
"=> tagbar
""""""""""""""""""""""""""""""
nmap <leader>tt :TagbarToggle<CR>
let g:tagbar_autofocus = 1

""""""""""""""""""""""""""""""
"=> ctrlsf
""""""""""""""""""""""""""""""
nmap     <C-F>f <Plug>CtrlSFPrompt
vmap     <C-F>f <Plug>CtrlSFVwordPath
vmap     <C-F>F <Plug>CtrlSFVwordExec
nmap     <C-F>n <Plug>CtrlSFCwordPath
nmap     <C-F>p <Plug>CtrlSFPwordPath
nnoremap <C-F>o :CtrlSFOpen<CR>
nnoremap <C-F>t :CtrlSFToggle<CR>
inoremap <C-F>t <Esc>:CtrlSFToggle<CR>

""""""""""""""""""""""""""""""
"=> YankRing
""""""""""""""""""""""""""""""
nnoremap <silent> <leader>ys :YRShow<CR>
nnoremap <silent> <leader>yc :YRClear<CR>
let g:yankring_replace_n_pkey = ''

