nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>

augroup grep_operator_filetype_ruby
  autocmd!
  autocmd FileType ruby nnoremap <buffer> <localleader>rga :set operatorfunc=<SID>RailsGrepAll<cr>g@
  autocmd FileType ruby vnoremap <buffer> <localleader>rga :<c-u>call <SID>RailsGrepAll(visualmode())<cr>

  autocmd FileType ruby nnoremap <buffer> <localleader>rgd :set operatorfunc=<SID>RailsGrepMethodDefOperator<cr>g@
  autocmd FileType ruby vnoremap <buffer> <localleader>rgd :<c-u>call <SID>RailsGrepMethodDefOperator(visualmode())<cr>

  autocmd FileType ruby nnoremap <buffer> <localleader>rgi :set operatorfunc=<SID>RailsGrepModuleInclude<cr>g@
  autocmd FileType ruby vnoremap <buffer> <localleader>rgi :<c-u>call <SID>RailsGrepModuleInclude(visualmode())<cr>
augroup END

function! s:YankTextToGrep(type)
  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    execute "normal! `[v`]y"
  else
    return 1
  endif
endfunction

function! s:GrepOperator(type)
  let saved_unamed_register = @@

  if <SID>YankTextToGrep(a:type) ==# 0
    silent execute "grep! -R -E " . shellescape(@@) . " ."
    copen
    redraw!
  end

  let @@ = saved_unamed_register
endfunction

function! s:RailsGrepMethodDefOperator(type)
  let saved_unamed_register = @@

  if <SID>YankTextToGrep(a:type) ==# 0
    silent execute "grep! -R -E " . shellescape('^\s*def\s+(\w+\.)?' . @@ . '(\s*\()?\b') . " ./app ./lib"
    copen
    redraw!
  end

  let @@ = saved_unamed_register
endfunction

function! s:RailsGrepModuleInclude(type)
  let saved_unamed_register = @@

  if <SID>YankTextToGrep(a:type) ==# 0
    silent execute "grep! -R -E " . shellescape( '^\s*include\s*(\(\s*)?' . @@ ) . " ./app ./lib"
    copen
    redraw!
  end

  let @@ = saved_unamed_register
endfunction

function! s:RailsGrepAll(type)
  let saved_unamed_register = @@

  if <SID>YankTextToGrep(a:type) ==# 0
    silent execute "grep! -R -E " . shellescape( @@ ) . " ./app ./lib"
    copen
    redraw!
  end

  let @@ = saved_unamed_register
endfunction


