"        _                    
"       (_)                   
" __   ___ _ __ ___  _ __ ___ 
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__ 
"   \_/ |_|_| |_| |_|_|  \___|
"
" vundle {{{
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'rafaqz/ranger.vim'
Plugin 'burnt43/test_plugin.vim'
Plugin 'burnt43/git.vim'
Plugin 'burnt43/statusline.vim'
Plugin 'burnt43/align.vim'
Plugin 'burnt43/asterisk.vim'
Plugin 'burnt43/haskell.vim'
Plugin 'burnt43/comments.vim'
Plugin 'burnt43/rails.vim'
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
hi Search cterm=NONE ctermfg=16 ctermbg=39
" }}}
" functions {{{
function! s:SaveSurroundMark()
  execute "normal! mz"
endfunction

function! s:RestoreSurroundMark()
  execute "normal! `z"
endfunction

function! s:SetSurroundType(type)
  let g:surround_type = a:type
endfunction

function! s:Surround(type)
  let saved_unamed_register = @@

  let left_char  = ''
  let right_char = ''

  if g:surround_type ==# '"'
    let left_char  = '"'
    let right_char = '"'
  elseif g:surround_type ==# '('
    let left_char  = '('
    let right_char = ')'
  endif

  if a:type ==# 'v'
    execute "normal! `<v`>di" . left_char . "\<esc>pa" . right_char . "\<esc>:call <SID>RestoreSurroundMark()\<cr>"
  elseif a:type ==# 'char'
    execute "normal! `[v`]di" . left_char . "\<esc>pa" . right_char . "\<esc>:call <SID>RestoreSurroundMark()\<cr>"
  endif

  let @@ = saved_unamed_register
endfunction
" }}}
" global key mappings {{{
" set leader
let mapleader="\\"
let maplocalleader="\\"

" .vimrc
nnoremap <leader>ev :tabe $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" vundle
nnoremap <leader>pu :PluginUpdate<cr>:qall<cr>

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

" etc
inoremap jk <esc>
inoremap <esc> <nop>

" surrounds
nnoremap <leader>s" 
  \ :call <SID>SaveSurroundMark()<cr>
  \ :call <SID>SetSurroundType('"')<cr>
  \ :set operatorfunc=<SID>Surround<cr>g@
vnoremap <leader>s"
  \ :<c-u>call <SID>SaveSurroundMark()<cr>
  \ :<c-u>call <SID>SetSurroundType('"')<cr>
  \ :<c-u>call <SID>Surround(visualmode())<cr>

nnoremap <leader>s(
  \ :call <SID>SaveSurroundMark()<cr>
  \ :call <SID>SetSurroundType('(')<cr>
  \ :set operatorfunc=<SID>Surround<cr>g@
vnoremap <leader>s(
  \ :<c-u>call <SID>SaveSurroundMark()<cr>
  \ :<c-u>call <SID>SetSurroundType('(')<cr>
  \ :<c-u>call <SID>Surround(visualmode())<cr>

" un-surrounds
nnoremap <leader>S" mzF"xf"x`z
nnoremap <leader>S( mzF(xf)x`z

" clipboard
nnoremap <leader>cbc :let @x=@@<cr>
nnoremap <leader>cbp "xp
nnoremap <leader>cbP "xP

" Plugin burnt43/align.vim
nnoremap <leader>al=
  \ :call align#SetAlignPattern('\v\s\zs\=\ze\s')<cr>
  \ :set operatorfunc=align#AlignChar<cr>g@
vnoremap <leader>al=
  \ :<c-u>call align#SetAlignPattern('\v\s\zs\=\ze\s')<cr>
  \ :<c-u>call align#AlignChar(visualmode())<cr>

nnoremap <leader>ala:
  \ :call align#SetAlignPattern('\v\w:\s*\zs\w\ze')<cr>
  \ :set operatorfunc=align#AlignChar<cr>g@
vnoremap <leader>ala:
  \ :<c-u>call align#SetAlignPattern('\v\w:\s*\zs\w\ze')<cr>
  \ :<c-u>call align#AlignChar(visualmode())<cr>

" Plugin burnt43/comments.vim
nnoremap <leader>c :set operatorfunc=comments#AddCommentOperator<cr>g@
vnoremap <leader>c :<c-u>call comments#AddCommentOperator(visualmode())<cr>
nnoremap <leader>C :set operatorfunc=comments#RemoveCommentOperator<cr>g@
vnoremap <leader>C :<c-u>call comments#RemoveCommentOperator(visualmode())<cr>

" Plugin 'burnt43/git.vim'
nnoremap <leader>gr :call git#GitRefresh()<cr>
nnoremap <leader>gs :call git#GitStatus()<cr>
nnoremap <leader>gdf :call git#GitDiff('file')<cr>
nnoremap <leader>gcf :call git#GitCommit('file')<cr>
nnoremap <leader>gda :call git#GitDiff('all')<cr>
nnoremap <leader>gca :call git#GitCommit('all')<cr>

" Plugin 'rafaqz/ranger.vim'
noremap <leader>rr :RangerEdit<cr>
noremap <leader>rt :RangerTab<cr>

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
" global abbreviations {{{
cabbrev help tab help
" }}}
" augroups {{{
" astdpcap {{{
augroup filetype_astdpcap
  autocmd!
  autocmd FileType astdpcap nnoremap <buffer> <localleader>cu :call asterisk#dialplan#capture#CleanUp()<cr>
augroup END
" }}}
" conf {{{
augroup filetype_conf
  autocmd!
  autocmd FileType conf setlocal foldmethod=marker
augroup END
" }}}
" haskell {{{
augroup filetype_haskell
  autocmd!
  autocmd FileType haskell nnoremap <buffer> <localleader>rp :call haskell#CompileAndRun()<cr>
augroup END
" }}}
" javascript {{{
augroup filetype_javascript
  autocmd!
  autocmd FileType javascript iabbrev <buffer> functionn function () {<left><left><left>
augroup END
" }}}
" rails {{{
augroup file_in_rails
  autocmd!
  autocmd User RailsLoaded nnoremap <buffer> <localleader>rga :set operatorfunc=rails#GrepAll<cr>g@
  autocmd User RailsLoaded vnoremap <buffer> <localleader>rga :<c-u>call rails#GrepAll(visualmode())<cr>

  autocmd User RailsLoaded nnoremap <buffer> <localleader>rgd :set operatorfunc=rails#GrepMethodDefOperator<cr>g@
  autocmd User RailsLoaded vnoremap <buffer> <localleader>rgd :<c-u>call rails#GrepMethodDefOperator(visualmode())<cr>

  autocmd User RailsLoaded nnoremap <buffer> <localleader>rgi :set operatorfunc=rails#GrepModuleInclude<cr>g@
  autocmd User RailsLoaded vnoremap <buffer> <localleader>rgi :<c-u>call rails#GrepModuleInclude(visualmode())<cr>
augroup end
" }}}
" ruby {{{
augroup filetype_ruby
  autocmd!
  " change method name
  autocmd FileType ruby onoremap <buffer> <localleader>mn :<c-u>execute "normal! ?^\\s*def\\s\\+\r:nohlsearch\r^wve"<cr>
  " change class name
  autocmd FileType ruby onoremap <buffer> <localleader>cn :<c-u>execute "normal! ?^\\s*class\\s\\+\r:nohlsearch\r^wve"<cr>
  " change method arguments
  autocmd FileType ruby onoremap <buffer> <localleader>ma :<c-u>execute "normal! ?^\\s*def\\s\\+\r:nohlsearch\rf(lvi("<cr>
augroup END
" }}}
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
" zsh {{{
augroup filetype_zsh
  autocmd!
  autocmd FileType zsh setlocal foldmethod=marker
augroup END
" }}}
" }}}
