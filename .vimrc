set ts=2 sw=2 ai
set expandtab
set nowrap
colorscheme default
syn on

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

" Enable Ctrl+hjkl for insert mode movement
inoremap <C-k> <C-o>gk
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-j> <C-o>gj

" Other
inoremap jj <Esc>
