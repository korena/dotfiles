set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" vundle plugins follow, you run :PluginInstall to install these packages!
Plugin 'vim-pandoc/vim-pandoc-syntax'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
" Color themes
Plugin 'dracula/vim'
Plugin 'morhetz/gruvbox'
" side VCS thingy
Plugin 'mhinz/vim-signify'
" Fast search
Plugin 'wincent/command-t'
" All of your Plugins must be added before the following line

call vundle#end()            " required
filetype plugin indent on
set nocompatible
set tabstop=2
set smarttab
set shiftwidth=2
set autoindent
set expandtab
set number
set statusline=%f
set backspace=indent,eol,start

" Experiments begin
set guifont=Inconsolata\ for\ Powerline:h24
set cursorline    " highlight the current line
set visualbell    " stop that ANNOYING beeping
set wildmenu
set wildmode=list:longest,full
"Allow usage of mouse in iTerm
set ttyfast
set mouse=a
" Make searching better
" set gdefault      " Never have to type /g at the end of search / replace again
set ignorecase    " case insensitive searching (unless specified)
set smartcase
set hlsearch
" nnoremap <silent> <leader>, :noh<cr> " Stop highlight after searching
set incsearch
set showmatch
set list listchars=tab:»·,trail:·,nbsp:·
" Make it obvious where 100 characters is
set textwidth=100
" set formatoptions=cq
set formatoptions=qrn1
set wrapmargin=0
set colorcolumn=+1
set numberwidth=5
set splitright
"HTML Editing
set matchpairs+=<:>
" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'
set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1
"Toggle relative numbering, and set to absolute on loss of focus or insert mode
set rnu
function! ToggleNumbersOn()
    set nu!
    set rnu
endfunction
function! ToggleRelativeOn()
    set rnu!
    set nu
endfunction
autocmd FocusLost * call ToggleRelativeOn()
autocmd FocusGained * call ToggleRelativeOn()
autocmd InsertEnter * call ToggleRelativeOn()
autocmd InsertLeave * call ToggleRelativeOn()
" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
" Navigate properly when lines are wrapped
nnoremap j gj
nnoremap k gk
nnoremap <tab> %
vnoremap <tab> %
" Always use vertical diffs
set diffopt+=vertical
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

" zoom a vim pane, <C-w>= to re-balance
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

" resize panes
nnoremap <silent> <Right> :vertical resize +5<cr>
nnoremap <silent> <Left> :vertical resize -5<cr>
nnoremap <silent> <Up> :resize +5<cr>
nnoremap <silent> <Down> :resize -5<cr>
  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
" === generate ctags
" call system('ctags -R . ')

" Experiments end

" Color stuff
colorscheme gruvbox
set guifont=Inconsolata\ 10
set fillchars+=vert:\$
set background=dark
" Color stuff end


" Custom key maps
let mapleader = ","
" works in normal mode, press space then type rv, that will reload vim
nnoremap <leader>rv :source $MYVIMRC<CR>
" compile current latex file, then open the resulting pdf 
nnoremap <leader>cl :!pandoc -t latex -o '%:t:r'.pdf % --listings -H ~/.tex/listings-setup.tex<CR> :!open '%:t:r'.pdf<CR><CR>

" Open NerdTree
nnoremap <leader>a :NERDTreeToggle<CR>

let NERDTreeIgnore = ['__pycache__', '\.pyc$', '\.o$', '\.so$', '\.a$', '\.swp', '*\.swp', '\.swo', '\.swn', '\.swh', '\.swm', '\.swl', '\.swk', '\.sw*$', '[a-zA-Z]*egg[a-zA-Z]*', '.DS_Store']
let NERDTreeShowHidden=1
" Open NerdTree by default if no file was specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif



" Signify (the plugin that shows added/modified/deleted lines for VCS)
let g:signify_vcs_list = [ 'git' ]


" Custom shit that should be in a separate  file but I can't figure out how to
" do that.

" This gets rid of the nasty _ italic bug in tpope's vim-markdown
" block $$...$$
syn region math start=/\$\$/ end=/\$\$/
" inline math
syn match math '\$[^$].\{-}\$'
" block \begin{ .. \end{
syn region math start=/\\begin/ end=/\\end{.*}/
" actually highlight the region we defined as "math"
hi link math Statement

" Default to open with nothing folded
set nofoldenable
set foldmethod=syntax
set foldlevel=1


