"
" Setup vim plugins
" :PlugInstall installs plugins
" Specify directory for plugins
call plug#begin('~/.local/share/nvim/plugged')

" Make sure you use single quotes
" Shorthand notation;
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'Raimondi/delimitMate'
Plug 'terryma/vim-expand-region'
Plug 'godlygeek/tabular'
Plug 'chip/vim-fat-finger'
Plug 'iCyMind/NeoSolarized'

Plug 'Valloric/YouCompleteMe'
"Plug 'itchyny/vim-cursorword'

Plug 'scrooloose/nerdtree'
"Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'

Plug 'Chiel92/vim-autoformat'

" On demand loading
Plug 'shime/vim-livedown', { 'for': 'markdown'}

Plug 'davidhalter/jedi-vim', { 'for': 'python'}

" Initialize plugin system
call plug#end()

"  ----------------------------------------------------------------------------
" To be sorted {{{1
"  ----------------------------------------------------------------------------
set title " Set title of window to file name
set cursorline          " highlight current line

set showmatch           " highlight matching [{()}]


" Solarized settings
colorscheme NeoSolarized
set termguicolors
set background=dark

" NERDTree Settings
" Open nerdtree automatically
" open NERDTree with F2
map <F2> :NERDTreeToggle<CR>

" Close vim even if NERDTree is the only window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Resize splits when window is resized
au VimResized * exe "normal \<c-w>="

" Vim jumps to the last position when  reopening a file
if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Show context when scrolling vertically.
set scrolloff=5

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
if has('persistent_undo')
        silent !mkdir ~/.vim/backups > /dev/null 2>&1
        set undodir=~/.vim/backups
        set undofile
endif

" Spelling
set spell               " Spelling always on
set spelllang=en        " Spelling language is English

" Shortcuts using <leader>
" TODO: Is this useful?
map <leader>ss ]s
map <leader>sb [s
map <leader>sa zg
map <leader>s? z=

" Tabs
set expandtab           " tabs are spaces
set tabstop=2           " number of visual spaces per TAB
set softtabstop=4       " number of spaces in tab when editing


" Search
set ignorecase          " Ignore case when searching
set smartcase           " ...Unless we use a capital
set hlsearch            " Highlight search results
set incsearch           " Search acts like search in modern browsers

" Filetype Specific
autocmd Filetype c   setlocal ts=4 sts=4 sw=4
autocmd Filetype cpp setlocal ts=2 sts=2 sw=2

" Whitespace
autocmd BufWritePre * :%s/\s\+$//e

" Changes how line numbers are displayed depending upon mode.
set relativenumber
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

au FocusLost * :wa      " Save when focus is lost
set noswapfile

" ============== Mappings ===============
" NOTE : Comments cannot be made in the same line as mappings!

"Map leader to spacebar
let mapleader="\<Space>"

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" Go to beginning and end of line
noremap H ^
noremap L g_

" Matching is done with tabs. Doesn't conflict with usage in insert mode
map <tab> %

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>


" Mark the 80th column in editor
if (exists('+colorcolumn'))
        set colorcolumn=80
        highlight ColorColumn ctermbg=8
endif

" Backspace works in insert
set backspace=indent,eol,start

" Par formatting
" Select in visual mode, then hit F6
map <F6> {!}par

" ========== Learning Zone ====================
" Copy and paste to system keyboard with <Leader>y and <Leader>p
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" Use region expanding
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" Enter Visual mode with <Leader><Leader>
" nmap <Leader><Leader> V


" Spelling
" find next misspelled word
nnoremap <leader>s [sz=
" autocomplete words by pressing <C-n> or <C-p>
set complete+=kspell

" Replacing Variables
" Substitute all occurrences of word under cursor
" type the replacement word, then hit enter
" Will confirm each word before replacing
nnoremap <Leader>r :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>


" Window splitting
" TODO: learn this!
" Open new split panes to right and bottom
set splitbelow
set splitright

" Navigate splits with arrow keys
nnoremap <Right> <C-w>l
nnoremap <Left> <C-w>h
nnoremap <Up> <C-w>k
nnoremap <Down> <C-w>j


" ============== Plugins ==============
" Autoformat
au BufWrite * :Autoformat
let g:formatter_yapf_style = 'pep8'

" Tabularize
" TODO: Tabularize has a lot more capabilities
" will call the :Tabularize command each time you insert a | character.
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

" Align Tables. Calls Tabularize on use of pipe character.
function! s:align()
        let p = '^\s*|\s.*\s|\s*$'
        if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
                let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
                let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
                Tabularize/|/l1
                normal! 0
                call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
        endif
endfunction


" Jedi
" If set to '', they are not assigned
let g:jedi#goto_command = ""
let g:jedi#goto_assignments_command = ""
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "<leader>d"
let g:jedi#usages_command = ""
let g:jedi#completions_command = ""
let g:jedi#rename_command = ""

" ============== Arduino ==============
autocmd BufNewFile,BufReadPost *.ino,*.pde set filetype=cpp

" ============== Markdown ==============
" Force vim to read .mkd as markdown.
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" ============== Par ==============
" Used to reformat text
" run with command 'gq'
" set line width to 72
set formatprg=par\ -72w

" Livedown
" should markdown preview get shown automatically upon opening markdown buffer
let g:livedown_autorun = 0

" should the browser window pop-up upon previewing
let g:livedown_open = 1

" the port on which Livedown server will run
let g:livedown_port = 1337

nmap <leader>md :LivedownToggle<CR>

