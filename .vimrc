" vundle {{{
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'rafaqz/ranger.vim'
Plugin 'chrisbra/unicode.vim'
call vundle#end()
filetype plugin on
" }}}

" basic settings {{{
set ts=2 sw=2 ai
set expandtab
set nowrap
set number relativenumber
set hlsearch
" }}}

" colors {{{
colorscheme badwolf
syn on
" hi Search cterm=NONE ctermfg=black ctermbg=red
" hi Folded cterm=NONE ctermfg=white ctermbg=black
" }}}

" statusline {{{
set laststatus=2
set statusline=%f       " filename
set statusline+=\ %m    " modified flag
set statusline+=%=      " move to right side
set statusline+=%y      " filetype
set statusline+=\ %4l  " current line
set statusline+=\/%-4L  " total lines
set statusline+=\ %3p%% " percentage
set statusline+=\ %3c    " column number
" }}}

" key mappings {{{
" set leader
let mapleader="\\"
let maplocalleader="\\"

" .vimrc
nnoremap <leader>ev :tabe $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" automatically append \v when searching
nnoremap / /\v
nnoremap ? ?\v

" tab navigation
noremap <S-tab> :tabprevious<cr>
noremap <tab> :tabnext<cr>

" navigation
nnoremap H 0
nnoremap L $

" match
nnoremap <leader>w :match Error /\v\s+$/<cr>
nnoremap <leader>W :match none<cr>

" surround in double quotes
nnoremap <leader>s" mzviw<esc>a"<esc>bi"<esc>`z

" etc
inoremap jk <esc>
inoremap <esc> <nop>

" ranger
noremap <leader>rr :RangerEdit<cr>
"noremap <leader>rv :RangerVSplit<cr>
"noremap <leader>rs :RangerSplit<cr>
noremap <leader>rt :RangerTab<cr>
"noremap <leader>ri :RangerInsert<cr>
"noremap <leader>ra :RangerAppend<cr>
"noremap <leader>rc :set operatorfunc=RangerChangeOperator<cr>g@

"nnoremap <leader>g :execute "grep! -R " . shellescape(expand("<cword>")) . " ."<cr>:copen<cr>

" disable keys i want to stop using
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
" }}}

" abbreviations {{{
cabbrev help tab help
" }}}

" augroup {{{
" vim {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" xdefaults {{{
augroup filetype_xdefaults
  autocmd!
  autocmd FileType xdefaults setlocal foldmethod=marker
augroup END
" }}}

" conf {{{
augroup filetype_conf
  autocmd!
  autocmd FileType conf setlocal foldmethod=marker
augroup END
" }}}

" ruby {{{
augroup filetype_ruby
  autocmd!
  autocmd FileType ruby nnoremap <buffer> <localleader>c ^i# <esc>
  " change method name
  autocmd FileType ruby onoremap <buffer> <localleader>mn :<c-u>execute "normal! ?^\\s*def\\s\\+\r:nohlsearch\r^wve"<cr>
  " change class name
  autocmd FileType ruby onoremap <buffer> <localleader>cn :<c-u>execute "normal! ?^\\s*class\\s\\+\r:nohlsearch\r^wve"<cr>
  " change method arguments
  autocmd FileType ruby onoremap <buffer> <localleader>ma :<c-u>execute "normal! ?^\\s*def\\s\\+\r:nohlsearch\rf(lvi("<cr>
augroup END
" }}}

" javascript {{{
augroup filetype_javascript
  autocmd!
  autocmd FileType javascript iabbrev <buffer> functionn function () {<left><left><left>
augroup END
" }}}
" }}}
