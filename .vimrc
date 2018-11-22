set nocompatible

" dein
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shugo/dein.vim'

" isntall dein.vim
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#add('Shougo/dein.vim')

  call dein#add('editorconfig/editorconfig-vim')
  call dein#add('itchyny/lightline.vim')
  call dein#add('scrooloose/nerdtree')
  call dein#add('scrooloose/syntastic')
  call dein#add('fatih/vim-go')

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

filetype plugin indent on

" encoding
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,p932,euc-jp,default,latin

" base
set t_Co=256
set showcmd
set showmode
set nobackup
set number
set showmatch
set cursorline
set wrapscan
set ignorecase
set smartcase
set incsearch
set hlsearch
"set autoindent
"set smartindent
"set cindent
set list
set listchars=tab:>-,trail:-,nbsp:%
set expandtab
set shiftwidth=4
set tabstop=4
set backspace=indent,eol,start
set wildmenu
set wildmode=full
set tags+=./tags
set tags+=.git/tags
set laststatus=2

" nerdtree
let NERDTreeShowHidden=1

" git
function! Ggrep(arg)
  setlocal grepprg=git\ grep\ --recurse-submodules\ --no-color\ -n\ $*
  silent execute ':grep '.a:arg
  silent cwin
  redraw!
endfunction

command! -nargs=1 -complete=buffer Gg call Ggrep(<q-args>)
command! -nargs=1 -complete=buffer Ggrep call Ggrep(<q-args>)
noremap <unique> gG :exec ':silent Ggrep ' . expand('<cword>')<CR>

syntax on
