let mapleader='\'
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-ruby/vim-ruby'
"Plugin 'burnt43/vim-haml'
Plugin 'rafaqz/ranger.vim'
call vundle#end()
" do not turn on indent!
filetype plugin on

let ruby_fold=1
let ruby_foldable_groups="class module def"

set ts=2 sw=2 ai
set expandtab
set nowrap
set number
set hlsearch
colorscheme default
syn on
hi Search cterm=NONE ctermfg=black ctermbg=red
hi Folded cterm=NONE ctermfg=white ctermbg=black

" disable arrow keys
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

" tab navigation (can't use Ctrl+l from some reason i think its because of urxvt) 
map <S-tab> :tabprevious<CR>
map <tab> :tabnext<CR>

" disable arrow keys
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>
imap <Home> <nop>
imap <End> <nop>
imap <PageDown> <nop>
imap <PageUp> <nop>

" disable ctrl+hjkl (I think I added these, but wanted to unbind them)
inoremap <C-k> <nop>
inoremap <C-h> <nop>
inoremap <C-l> <nop>
inoremap <C-j> <nop>

" etc
inoremap jj <Esc>

" ranger
map <leader>rr :RangerEdit<cr>
map <leader>rv :RangerVSplit<cr>
map <leader>rs :RangerSplit<cr>
map <leader>rt :RangerTab<cr>
map <leader>ri :RangerInsert<cr>
map <leader>ra :RangerAppend<cr>
map <leader>rc :set operatorfunc=RangerChangeOperator<cr>g@
