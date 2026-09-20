"vimplug stuff
call plug#begin()
Plug 'flazz/vim-colorschemes'
Plug 'felixhummel/setcolors.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'jiangmiao/auto-pairs'
Plug 'chriskempson/base16-vim'
Plug '~/.config/nvim/plugged/scrollcolor'
Plug 'mhinz/vim-startify'
Plug 'XadillaX/vim-mir2-colorscheme'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'
Plug 'noahfrederick/vim-noctu'
call plug#end()


set nonu
set rnu 
"set termguicolors
set t_Co=16
"colorscheme developer
"colorscheme inori "!
" colorscheme kalahari
" colorscheme kolor
" colorscheme lxvc
" colorscheme mango "!
" colorscheme monokain
" colorscheme pleasant 
" colorscheme satori "!!
" colorscheme sorcerer "!
"colorscheme firewatch "!
"colorscheme fahrenheit
" colorscheme twilight256 "!
"colorscheme LightDefault "!!
"colorscheme SlateDark "!!!
"colorscheme adventurous "!?
"colorscheme enzyme
" colorscheme whitebox
"colorscheme vimbrains
"colorscheme wargrey
colorscheme void
" colorscheme delek
"colorscheme noctu
"colorscheme vimbrains


hi CursorLine ctermbg=black
hi Cursorline cterm=none
hi Cursorline gui=none
hi CursorLineNr term=bold cterm=bold ctermbg=black ctermfg=darkmagenta
hi Pmenu ctermbg=black ctermfg=lightgrey
hi PmenuSel ctermfg=black ctermbg=lightgrey
set t_Co=16
"set bg&


" Styled and colored underline support
let &t_AU = "\e[58:5:%dm"
let &t_8u = "\e[58:2:%lu:%lu:%lum"
let &t_Us = "\e[4:2m"
let &t_Cs = "\e[4:3m"
let &t_ds = "\e[4:4m"
let &t_Ds = "\e[4:5m"
let &t_Ce = "\e[4:0m"
" Strikethrough
let &t_Ts = "\e[9m"
let &t_Te = "\e[29m"
" Truecolor support
let &t_8f = "\e[38:2:%lu:%lu:%lum"
let &t_8b = "\e[48:2:%lu:%lu:%lum"
let &t_RF = "\e]10;?\e\\"
let &t_RB = "\e]11;?\e\\"
" Bracketed paste
let &t_BE = "\e[?2004h"
let &t_BD = "\e[?2004l"
let &t_PS = "\e[200~"
let &t_PE = "\e[201~"
" Cursor control
let &t_RC = "\e[?12$p"
let &t_SH = "\e[%d q"
let &t_RS = "\eP$q q\e\\"
let &t_SI = "\e[5 q"
let &t_SR = "\e[3 q"
let &t_EI = "\e[1 q"
let &t_VS = "\e[?12l"
" Focus tracking
let &t_fe = "\e[?1004h"
let &t_fd = "\e[?1004l"
" Window title
let &t_ST = "\e[22;2t"
let &t_RT = "\e[23;2t"

" vim hardcodes background color erase even if the terminfo file does
" not contain bce. This causes incorrect background rendering when
" using a color theme with a background color in terminals such as
" kitty that do not support background color erase.
let &t_ut=''


"caps to esc
"actually no, esta en la config global

"coc, spacing
set shiftwidth=2
set tabstop=2
set expandtab
set signcolumn=number
set cursorline
let g:coc_disable_startup_warning = 1
let g:coc_node_path='/usr/bin/node'
let g:coc_npm_path='/usr/bin/npm'
nnoremap <C-s> :w<CR>
nnoremap k gk
nnoremap j gj
nmap <silent> <c-k> :m .-2<CR>
nmap <silent> <c-j> :m .+1<CR>

"startify 
let g:startify_update_oldfiles = 1
let g:startify_session_autoload = 1
let g:startify_padding_left = 10
let g:startify_session_number = 3

"airline
let g:airline_powerline_fonts = 1
let g:airline_theme = 'apprentice'
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#coc#error_symbol = ' '
let g:airline#extensions#coc#warning_symbol= ' '
let g:airline#extensions#coc#stl_format_err = '%C (%L)'
let g:airline#extensions#coc#stl_format_warn = '%C (%L)'
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif
let g:airline_symbols.colnr = ' 易'
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ' 李'
let g:airline_symbols.maxlinenr = ' '

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_close_button = 0

set showtabline=1

"NERDTree
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Toggle
nnoremap <silent> <C-b> :NERDTreeToggle<cr>

" Close terminal if only buffer
autocmd bufenter * if (winnr("$") == 1 && &buftype == 'terminal') | q | endif

" map key to complete suggestion
inoremap <silent><expr> <tab> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" open new split panes to right and below
set splitright
set splitbelow

" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>
"close terminal
tnoremap <silent> <C-d> <C-\><C-n>:bd!<CR>

"tabs
nnoremap <A-tab> :tabn<CR>
nnoremap <S-tab> :tabp<CR>
nnoremap <A-t> :tabe<CR>:NERDTreeFocus<CR>

set softtabstop=4 
set expandtab
set shiftwidth=4 smarttab

" start terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | endif
" open terminal on ctrl+n
function! OpenTerminal()
  split term://bash
  resize 10
endfunction
nnoremap <c-n> :call OpenTerminal()<CR>

" no highlights
nnoremap <silent> <CR> :noh<CR><CR>

" use alt+hjkl to move between split/vsplit panels
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" make file remaps

nnoremap <F9> :make! <CR>
nnoremap <F10> :make! run <CR>

" autopairs
let g:AutoPairsShortcutFastWrap = '<C-e>'

