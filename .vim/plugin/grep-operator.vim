nnoremap <leader>g :set operatorfunc=GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call GrepOperator(visualmode())<cr>

augroup grep_operator_filetype_ruby
  autocmd!
  autocmd FileType ruby nnoremap <buffer> <localleader>rgd :set operatorfunc=RailsGrepMethodDefOperator<cr>g@
  autocmd FileType ruby vnoremap <buffer> <localleader>rgd :<c-u>call RailsGrepMethodDefOperator(visualmode())<cr>

  autocmd FileType ruby nnoremap <buffer> <localleader>rgi :set operatorfunc=RailsGrepModuleInclude<cr>g@
  autocmd FileType ruby vnoremap <buffer> <localleader>rgi :<c-u>call RailsGrepModuleInclude(visualmode())<cr>
augroup END

function! YankTextToGrep(type)
  if a:type ==# 'v'
    execute "normal! `<v`>y"
  elseif a:type ==# 'char'
    execute "normal! `[v`]y"
  else
    return 1
  endif
endfunction

function! GrepOperator(type)
  if YankTextToGrep(a:type) ==# 0
    silent execute "grep! -R -E " . shellescape(@@) . " ."
    copen
    redraw!
  end
endfunction

function! RailsGrepMethodDefOperator(type)
  if YankTextToGrep(a:type) ==# 0
    silent execute "grep! -R -E " . shellescape('^\s*def\s+(\w+\.)?' . @@ . '(\s*\()?\b') . " ./app ./lib"
    copen
    redraw!
  end
endfunction

function! RailsGrepModuleInclude(type)
  if YankTextToGrep(a:type) ==# 0
    silent execute "grep! -R -E " . shellescape( '^\s*include\s*(\(\s*)?' . @@ ) . " ./app ./lib"
    copen
    redraw!
  end
endfunction
