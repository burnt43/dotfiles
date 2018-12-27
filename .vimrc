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
" variables {{{
let g:filetype_to_comment_char = {'javascript': '//', 'ruby': '#', 'vim': '"', 'xdefaults': '!','zsh': '#'}
" }}}
" functions {{{
function! s:SetStatusLine(type)
  if a:type ==# 'normal'
    " badwolf tardis
    hi StatusLine ctermbg=39 ctermfg=16
    set statusline=[NORMAL]
  elseif a:type ==# 'insert'
    " badwolf orange
    hi StatusLine ctermbg=214 ctermfg=16
    set statusline=[INSERT]
  elseif a:type ==# 'command'
    " badwolf lime
    hi StatusLine ctermbg=154 ctermfg=16
    set statusline=[COMMAND]
  end

  set statusline+=\ %f    " filename
  set statusline+=\ %m    " modified flag
  set statusline+=%=      " move to right side
  set statusline+=%y      " filetype
  set statusline+=\ %4l   " current line
  set statusline+=\/%-4L  " total lines
  set statusline+=\ %3p%% " percentage
  set statusline+=\ %3c   " column number
endfunction

function! s:AddCommentOperator(type)
  if has_key(g:filetype_to_comment_char, &filetype)
    if a:type ==# 'V'
      execute "normal! :'<,'>" . 's/^/'. g:filetype_to_comment_char[&filetype] . ' /g' . "\<cr>"
    elseif a:type ==# 'line'
      execute "normal! :'[,']" . 's/^/'. g:filetype_to_comment_char[&filetype] . ' /g' . "\<cr>"
    endif
  endif
endfunction

function! s:RemoveCommentOperator(type)
  if has_key(g:filetype_to_comment_char, &filetype)
    if a:type ==# 'V'
      execute "normal! :'<,'>" . 's/^'. g:filetype_to_comment_char[&filetype] . ' //g' . "\<cr>"
    elseif a:type ==# 'line'
      execute "normal! :'[,']" . 's/^'. g:filetype_to_comment_char[&filetype] . ' //g' . "\<cr>"
    endif
  endif
endfunction
" }}}
" global key mappings {{{
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

" commenting
nnoremap <localleader>c :set operatorfunc=<SID>AddCommentOperator<cr>g@
vnoremap <localleader>c :<c-u>call<SID>AddCommentOperator(visualmode())<cr>
nnoremap <localleader>C :set operatorfunc=<SID>RemoveCommentOperator<cr>g@
vnoremap <localleader>C :<c-u>call<SID>RemoveCommentOperator(visualmode())<cr>

" ranger
noremap <leader>rr :RangerEdit<cr>
"noremap <leader>rv :RangerVSplit<cr>
"noremap <leader>rs :RangerSplit<cr>
noremap <leader>rt :RangerTab<cr>
"noremap <leader>ri :RangerInsert<cr>
"noremap <leader>ra :RangerAppend<cr>
"noremap <leader>rc :set operatorfunc=RangerChangeOperator<cr>g@

" remap : to set the status line, because the CmdLineEnter is whack.
nnoremap : :call <SID>SetStatusLine("command")<cr>:

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
" global operators {{{
onoremap a' :<c-u>execute "normal! F'vf'"<cr>
onoremap a" :<c-u>execute "normal! F\"vf\""<cr>
" }}}
" statusline {{{
set laststatus=2
call <SID>SetStatusLine('normal')
" }}}
" augroups {{{
" conf {{{
augroup filetype_conf
  autocmd!
  autocmd FileType conf setlocal foldmethod=marker
augroup END
" }}}
" javascript {{{
augroup filetype_javascript
  autocmd!
  autocmd FileType javascript iabbrev <buffer> functionn function () {<left><left><left>
augroup END
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
" statusline {{{
augroup statusline_events
  autocmd!
  autocmd InsertLeave * call <SID>SetStatusLine('normal')
  autocmd InsertEnter * call <SID>SetStatusLine('insert')
  autocmd CmdLineLeave * call <SID>SetStatusLine('normal')
augroup END
" }}}
" vim {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
" }}}
" xdefaults {{{
augroup filetype_xdefaults
  autocmd!
  autocmd FileType xdefaults setlocal foldmethod=marker
" }}}
" zsh {{{
augroup filetype_zsh
  autocmd!
  autocmd FileType zsh setlocal foldmethod=marker
" }}}
" }}}
" test area {{{
" }}}
" learn vimscript the hard way area {{{
" nnoremap <leader>f :call FoldColumnToggle()<cr>
" 
" function! FoldColumnToggle()
"   if &foldcolumn
"     setlocal foldcolumn=0
"   else
"     setlocal foldcolumn=4
"   endif
" endfunction
" 
" nnoremap <leader>q :call QuickfixToggle()<cr>
" let g:quickfix_is_open = 0
" 
" function! QuickfixToggle()
"   if g:quickfix_is_open
"     cclose
"     let g:quickfix_is_open = 0
"     execute g:quickfix_return_to_window . "wincmd w"
"   else
"     let g:quickfix_return_to_window = winnr()
"     copen
"     let g:quickfix_is_open = 1
"   endif
" endfunction

" function! Sorted(l)
"   let new_list = deepcopy(a:l)
"   call sort(new_list)
"   return new_list
" endfunction
" 
" function! Reversed(l)
"   let new_list = deepcopy(a:l)
"   call reverse(new_list)
"   return new_list
" endfunction
" 
" function! Append(l, val)
"   let new_list = deepcopy(a:l)
"   call add(new_list, a:val)
"   return new_list
" endfunction
" 
" function! Assoc(l, i, val)
"   let new_list = deepcopy(a:l)
"   let new_list[a:i] = a:val
"   return new_list
" endfunction
" 
" function! Pop(l, i)
"   let new_list = deepcopy(a:l)
"   call remove(new_list, a:i)
"   return new_list
" endfunction
" 
" function! Mapped(fn, l)
"   let new_list = deepcopy(a:l)
"   call map(new_list, string(a:fn) . '(v:val)')
"   return new_list
" endfunction
" 
" function! Filtered(fn, l)
"   let new_list = deepcopy(a:l)
"   call filter(new_list, string(a:fn) . '(v:val)')
"   return new_list
" endfunction
" 
" function! Removed(fn, l)
"   let new_list = deepcopy(a:l)
"   call filter(new_list, '!' . string(a:fn) . '(v:val)')
"   return new_list
" endfunction
" }}}
