" Maintainer: Zhenhuan Hu <zhu@mcw.edu>
" Version: 2017-02-03

" General {{{
" Enable filetype plugins
filetype plugin indent on

set nocompatible
set noswapfile nobackup
set autoread

" Addtional paths
if has('unix')
  set runtimepath+=$HOME/.vim/bundle/*,$HOME/.vim/bundle/*/after
  set viewdir=$HOME/.vim/view viewoptions-=options
elseif has('win32')
  set runtimepath+=$HOME/vimfiles/bundle/*,$HOME/vimfiles/bundle/*/after
  set viewdir=$HOME/vimfiles/view viewoptions-=options
endif

" File format options
set fileformats=unix,dos
if has('multi_byte')
  set encoding=utf-8 fileencodings=utf-8,gb18030,big5,sjis,latin1
  if &termencoding ==# '' | let &termencoding = &encoding | endif
endif
" }}}

" User Interface {{{
set number foldcolumn=3 foldlevelstart=3 ruler laststatus=2
set showtabline=2 noshowmode showcmd wildmenu

" Backspace
set backspace=indent,eol,start whichwrap+=<,>,[,]
fixdel

" Indent and wrap
set wrap formatoptions+=cro
set autoindent softtabstop=2 shiftwidth=2 expandtab
let &showbreak = "\u2192"
if version > 704
  set breakindent breakindentopt+=sbr
endif

" Searching behaviors
set hlsearch ignorecase smartcase
"}}}

" Color Scheme {{{
if &term =~ '256color'
  " Disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " See also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif
set background=dark
colorscheme afterglow

" Syntax
if version >= 500
  if !exists('g:syntax_on')
    syntax enable
  endif
  syntax sync fromstart
endif
" }}}

" Key Mappings {{{
let mapleader = ','
nnoremap <leader>, ,
nnoremap <leader>es :vsplit $MYVIMRC<CR>
nnoremap <leader>ss :source $MYVIMRC<CR>
nnoremap <leader>ww :update<CR>
nnoremap <leader>wq :wq<CR>
nnoremap <leader>qq :q<CR>
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>to :tabonly<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>
nnoremap <leader>fi mzgg=G`z
nnoremap <leader>sc :setlocal spell!<CR>
xnoremap <leader>uc Ugv
xnoremap <leader>lc ugv
xnoremap <leader>tc ~gv

" Searching
xnoremap / "+y/<C-r>+
nnoremap <C-l> :nohl<CR><C-l>

" Bracketing
xnoremap ( c(<C-r>")
xnoremap [ c[<C-r>"]
xnoremap { c{<C-r>"}
xnoremap ' c'<C-r>"'
xnoremap " c"<C-r>""

" Navigation
nnoremap gg ggzz
nnoremap G Gzz
nnoremap n nzz
nnoremap N Nzz
nnoremap { {zz
nnoremap } }zz

" Windows shortcuts
if !has('macunix')
  vnoremap <BS> d

  nnoremap <C-z> u
  vnoremap <C-z> <C-c>ugv
  inoremap <C-z> <C-o>u
  cnoremap <C-z> <C-c>u
  onoremap <C-z> <C-c>u

  nnoremap <C-y> <C-r>
  vnoremap <C-y> <C-c><C-r>gv
  inoremap <C-y> <C-o><C-r>
  cnoremap <C-y> <C-c><C-r>
  onoremap <C-y> <C-c><C-r>

  vnoremap <C-x> "+x
  vnoremap <C-c> "+y
  cnoremap <C-c> <C-y>
  nnoremap <C-v> "+gP
  cnoremap <C-v> <C-r>+

  " Pasting blockwise and linewise selections is not possible in Insert and
  " Visual mode without the +virtualedit feature. They are pasted as if they
  " were characterwise instead.
  " Uses the paste.vim autoload script.
  " Use CTRL-G u to have CTRL-Z only undo the paste.
  exec 'vnoremap <script> <C-v>' paste#paste_cmd['v']
  exec 'inoremap <script> <C-v>' '<C-g>u' . paste#paste_cmd['i']

  nnoremap <silent> <C-a> :call keny#SelectAll()<CR>
  vnoremap <silent> <C-a> :call keny#SelectAll()<CR>
  inoremap <silent> <C-a> <C-o>:call keny#SelectAll()<CR>
  cnoremap <silent> <C-a> <C-c>:call keny#SelectAll()<CR>
  onoremap <silent> <C-a> <C-c>:call keny#SelectAll()<CR>
endif
" }}}

" Plugin Configurations {{{
" Configure netrw
let g:netrw_banner = 0
let g:newtw_winsize = 25     " 25% of page size
let g:netrw_browse_split = 4 " Open in prior window
let g:netrw_altv = 1         " Open splits to the right
let g:netrw_liststyle = 3    " Tree view

" Configure vim-airline
let g:airline#extensions#wordcount#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep = ' >>> '
let g:airline_right_sep = ' <<< '

" Configure vim-lightline
let g:lightline = {
      \ 'colorscheme': 'afterglow',
      \ 'enable': { 'statusline': 1, 'tabline': 1 },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \           [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'percent', 'cursorpos' ],
      \            [ 'fileproperty' ],
      \            [ 'filetype' ] ] },
      \ 'inactive': {
      \   'left': [ [ 'filename' ] ],
      \   'right': [ [ 'percent', 'cursorpos' ] ] },
      \ 'tabline': {
      \   'left': [ [ 'tabs' ],
      \           [ 'buffers' ] ],
      \   'right': [ [ 'close' ] ] },
      \ 'tab': {
      \   'active': [ 'tabnum' ],
      \   'inactive': [ 'tabnum' ] },
      \ 'component': {
      \   'cursorpos': '%3l/%L:%-2v',
      \   'fileproperty': '%{&fenc!=#""?&fenc:&enc}[%{&ff}]',
      \   'close': "%999X \u00d7 " },
      \ 'component_expand': { 'buffers': 'lightline#bufferline#buffers' },
      \ 'component_type': { 'buffers': 'tabsel' },
      \ 'separator': { 'left': ' >>> ', 'right': ' <<< ' },
      \ 'tabline_separator': { 'left': '', 'right': ' <<< ' },
      \ 'subseparator': { 'left': '', 'right': '' },
      \ }

let g:lightline#bufferline#unnamed = '[No Name]'

" Configure ctrlp
if has('unix')
  let g:ctrlp_cache_dir = $HOME . '/.ctrlp'
elseif has('win32')
  let g:ctrlp_cache_dir = $HOME . '/_ctrlp'
endif
let g:ctrlp_root_markers = ['vimrc']

" Configure delimitMate
let g:delimitMate_expand_cr = 0

" Configure taglist
let g:tlist_auto_highlight_tag = 1
let g:tlist_auto_update = 1
let g:tlist_show_menu = 1

" Configure dbext
let g:dbext_default_profile_rdb = 'type=ORA:user=zhu:passwd=kenny#418hu:srvname=IBMTPRD'
let g:dbext_default_profile = 'rdb'
if has('unix')
  let g:dbext_default_history_file = $HOME . '/.dbext_hist'
elseif has('win32')
  let g:dbext_default_history_file = $HOME . '/_dbext_hist'
endif

" Configure sqlplus
let g:sqlplus_userid = 'zhu'
let g:sqlplus_passwd = 'kenny#418hu'
let g:sqlplus_db = 'IBMTPRD'
" }}}

" vim:foldmethod=marker:foldlevel=0
