"
" VUNDLE
"
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'rafaqz/ranger.vim'
Plugin 'chrisbra/unicode.vim'
call vundle#end()
filetype plugin on

"
" SETTINGS
"
set ts=2 sw=2 ai
set expandtab
set nowrap
set number relativenumber
set hlsearch
colorscheme badwolf
syn on
hi Search cterm=NONE ctermfg=black ctermbg=red
hi Folded cterm=NONE ctermfg=white ctermbg=black

"
" KEY MAPPINGS
"

" set leader
let mapleader='\'

" .vimrc
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" tab navigation
noremap <S-tab> :tabprevious<cr>
noremap <tab> :tabnext<cr>

" etc
inoremap jj <esc>

" ranger
noremap <leader>rr :RangerEdit<cr>
"noremap <leader>rv :RangerVSplit<cr>
"noremap <leader>rs :RangerSplit<cr>
noremap <leader>rt :RangerTab<cr>
"noremap <leader>ri :RangerInsert<cr>
"noremap <leader>ra :RangerAppend<cr>
"noremap <leader>rc :set operatorfunc=RangerChangeOperator<cr>g@

" disable 'noobie' keys
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
noremap <Home> <nop>
noremap <End> <nop>
noremap <Insert> <nop>
noremap <Delete> <nop>
noremap <PageDown> <nop>
noremap <PageUp> <nop>

" autocmd
"   ruby
augroup filetype_ruby
  autocmd!
  autocmd FileType ruby nnoremap <buffer> <localleader>c ^i# <esc>
augroup END

"  javascript
augroup filetype_javascript
  autocmd!
  autocmd FileType javascript iabbrev <buffer> functionn function () {<left><left><left>
augroup END
