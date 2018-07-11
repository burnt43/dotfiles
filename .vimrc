set ts=2 sw=2 ai
set expandtab
set nowrap
set number
set hlsearch
colorscheme default
syn on
hi Search cterm=NONE ctermfg=black ctermbg=red

" Disable Arrow keys in Escape mode
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
map <Home> <nop>
map <End> <nop>
map <Insert> <nop>
map <Delete> <nop>
map <PageDown> <nop>
map <PageUp> <nop>

" Disable Arrow keys in Insert mode
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>
imap <Home> <nop>
imap <End> <nop>
imap <PageDown> <nop>
imap <PageUp> <nop>

" Disable Ctrl+hjkl for insert mode movement
inoremap <C-k> <nop>
inoremap <C-h> <nop>
inoremap <C-l> <nop>
inoremap <C-j> <nop>

" Other
inoremap jj <Esc>
