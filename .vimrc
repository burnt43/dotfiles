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

if $USER ==# 'jcarson'
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
  Plugin 'burnt43/ruby.vim'
  call vundle#end()
end

filetype plugin on
" }}}
" basic settings {{{
set ts=2 sw=2 ai
set expandtab
set nowrap

if exists("+relativenumber")
  set number relativenumber
else
  set number
endif

set hlsearch

" I don't know who to write a conditional to see if newtab is a valid option
if v:version >= 800
  set switchbuf+=usetab,newtab
else
  set switchbuf+=usetab
endif
" }}}
" colors {{{
colorscheme molokai
syn on
highlight Search cterm=NONE ctermfg=16 ctermbg=173
highlight Folded cterm=NONE ctermfg=245 ctermbg=233
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

" fold
nnoremap <leader>zf :set foldcolumn=4<cr>
nnoremap <leader>zF :set foldcolumn=0<cr>
" fold(z).(o)nly.(c)urrent
nnoremap <leader>zoc zMzv

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
nnoremap <leader>v :set paste<cr>
nnoremap <leader>V :set nopaste<cr>

" (c)lip(b)oard (c)opy
nnoremap <leader>cbc :let @x=@@<cr>
" (c)lip(b)oard (p)aste
nnoremap <leader>cbp "xp
" (c)lip(b)oard (P)aste
nnoremap <leader>cbP "xP

" quickfix
nnoremap <leader>Q :cclose<cr>

" highlight
nnoremap <leader>H :nohl<cr>
nnoremap <leader>s :syn on<cr>
nnoremap <leader>S :syn off<cr>

" misc
" (i)nsert (b)uffer (n)ame
nnoremap <leader>ibn :execute "normal! i" . fnamemodify(bufname("%"), ':t:r')<cr>

" Plugin burnt43/align.vim

" (al)ign (=)equals
nnoremap <leader>al=
  \ :call align#SetAlignPattern('\v\s\zs\=\ze\s')<cr>
  \ :set operatorfunc=align#AlignChar<cr>g@
" (al)ign (=)equals
vnoremap <leader>al=
  \ :<c-u>call align#SetAlignPattern('\v\s\zs\=\ze\s')<cr>
  \ :<c-u>call align#AlignChar(visualmode())<cr>

" (al)ign (a)fter (:)colon
nnoremap <leader>ala:
  \ :call align#SetAlignPattern('\v\w:\s*\zs\w\ze')<cr>
  \ :set operatorfunc=align#AlignChar<cr>g@
" (al)ign (a)fter (:)colon
vnoremap <leader>ala:
  \ :<c-u>call align#SetAlignPattern('\v\w:\s*\zs\w\ze')<cr>
  \ :<c-u>call align#AlignChar(visualmode())<cr>

" Plugin burnt43/comments.vim
nnoremap <leader>c :set operatorfunc=comments#AddCommentOperator<cr>g@
vnoremap <leader>c :<c-u>call comments#AddCommentOperator(visualmode())<cr>
nnoremap <leader>C :set operatorfunc=comments#RemoveCommentOperator<cr>g@
vnoremap <leader>C :<c-u>call comments#RemoveCommentOperator(visualmode())<cr>

" Plugin 'burnt43/git.vim'
" (g)it (r)refresh
nnoremap <leader>gr :call git#GitRefresh()<cr>
" (g)it (s)tatus
nnoremap <leader>gs :call git#GitStatus()<cr>
" (g)it (d)iff (b)uffer
nnoremap <leader>gdb :call git#GitDiff('file')<cr>
" (g)it (c)ommit (b)uffer
nnoremap <leader>gcb :call git#GitCommit('file')<cr>
" (g)it (d)iff (a)ll
nnoremap <leader>gda :call git#GitDiff('all')<cr>
" (g)it (c)ommit (a)ll
nnoremap <leader>gca :call git#GitCommit('all')<cr>

" Plugin 'rafaqz/ranger.vim'
noremap <leader>rr :RangerEdit<cr>
noremap <leader>rt :RangerTab<cr>

" disable keys i want to stop using
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
" }}}
" global abbreviations {{{
cabbrev help tab help
" }}}
" augroups {{{
" astdpcap {{{
augroup filetype_astdpcap
  autocmd!
  autocmd FileType astdpcap nnoremap <buffer> <leader>cu :call asterisk#dialplan#capture#CleanUp()<cr>
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
  autocmd FileType haskell let maplocalleader="\\h"

  " (r)un.(p)rogram
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
  autocmd User RailsLoaded nnoremap <buffer> <leader>rga :set operatorfunc=rails#GrepAll<cr>g@
  autocmd User RailsLoaded vnoremap <buffer> <leader>rga :<c-u>call rails#GrepAll(visualmode())<cr>

  autocmd User RailsLoaded nnoremap <buffer> <leader>rgd :set operatorfunc=rails#GrepMethodDefOperator<cr>g@
  autocmd User RailsLoaded vnoremap <buffer> <leader>rgd :<c-u>call rails#GrepMethodDefOperator(visualmode())<cr>

  autocmd User RailsLoaded nnoremap <buffer> <leader>rgi :set operatorfunc=rails#GrepModuleInclude<cr>g@
  autocmd User RailsLoaded vnoremap <buffer> <leader>rgi :<c-u>call rails#GrepModuleInclude(visualmode())<cr>
augroup end
" }}}
" rubocopoutput {{{
augroup filetype_rubocopoutput
  autocmd!
  autocmd FileType rubocopoutput setlocal wrap
augroup END
" }}}
" ruby {{{
augroup filetype_ruby
  autocmd!
  autocmd FileType ruby let maplocalleader="\\r"

  " change method name
  autocmd FileType ruby onoremap <buffer> <localleader>mn :<c-u>execute "normal! ?^\\s*def\\s\\+\r:nohlsearch\r^wve"<cr>
  " change class name
  autocmd FileType ruby onoremap <buffer> <localleader>cn :<c-u>execute "normal! ?^\\s*class\\s\\+\r:nohlsearch\r^wve"<cr>
  " change method arguments
  autocmd FileType ruby onoremap <buffer> <localleader>ma :<c-u>execute "normal! ?^\\s*def\\s\\+\r:nohlsearch\rf(lvi("<cr>

  " match
  autocmd FileType ruby nnoremap <buffer> <localleader>w :match Error /\v.{80}\zs.+\ze/<cr>
  autocmd FileType ruby nnoremap <buffer> <localleader>W :match none<cr>

  " ruby.vim

  " rubo(c)op.(l)ines
  "   analyze visually selected lines
  autocmd FileType ruby vnoremap <buffer> <localleader>cl :<c-u>call ruby#rubocop#AnalyzeLines(visualmode())<cr>

  " rubo(c)op.(b)uffer
  "   analyze the buffer 
  autocmd FileType ruby nnoremap <buffer> <localleader>cb :<c-u>call ruby#rubocop#AnalyzeBuffer()<cr>

  " (i)nsert.(t)housand_separators
  "   changes 1000000 to 1_000_000
  autocmd FileType ruby vnoremap <buffer> <localleader>it :<c-u>call ruby#InsertThousandSeparators(visualmode())<cr>
  autocmd FileType ruby nnoremap <buffer> <localleader>it :set operatorfunc=ruby#InsertThousandSeparators<cr>g@

  " e(x)change.(")double_quote
  "   changes " to '
  autocmd FileType ruby vnoremap <buffer> <localleader>x"
    \ :<c-u>call ruby#ChangeDoubleQuoteToSingleQuote(visualmode())<cr>
  autocmd FileType ruby nnoremap <buffer> <localleader>x"
    \ :set operatorfunc=ruby#ChangeDoubleQuoteToSingleQuote<cr>g@
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
