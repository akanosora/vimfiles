" Maintainer: Zhenhuan Hu <zhu@mcw.edu>
" Version: May 24, 2017

" User Interface {{{
set guioptions-=T guioptions-=e
set lines=60 columns=150

" Set fonts
if has('gui_macvim')
  set guifont=Source\ Code\ Pro:h14
elseif has('gui_win32')
  set guifont=Consolas:h11:cANSI
  if version > 704
    set renderoptions=type:directx,level:0.75,gamma:1.25,contrast:0.25,geom:1,renmode:5,taamode:1
  endif
  set linespace=2
endif

augroup UserInterface
  autocmd!
  autocmd VimResized * exe "normal \<C-w>="
augroup END
" }}}

" Key Mappings {{{
" Searching
xnoremap <C-f> y:promptfind <C-r>"<CR>
xnoremap <C-h> y:promptrepl <C-r>"<CR>

" Navigation
nnoremap <S-Up> {zz
vnoremap <S-Up> <C-c>{zz
inoremap <S-Up> <C-o>{<C-o>zz
nnoremap <S-Down> }zz
vnoremap <S-Down> <C-c>}zz
inoremap <S-Down> <C-o>}<C-o>zz

nnoremap <C-S-Up> 1<C-u>
nnoremap <C-S-Down> 1<C-d>

" Switch buffers
nnoremap <silent> <S-Tab> :bn<CR>
vnoremap <silent> <S-Tab> <C-c>:bn<CR>
inoremap <silent> <S-Tab> <C-o>:bn<CR>

" Switch tabs
nnoremap <silent> <C-Tab> :tabnext<CR>
vnoremap <silent> <C-Tab> <C-c>:tabnext<CR>
inoremap <silent> <C-Tab> <C-o>:tabnext<CR>

" Switch windows
nnoremap <C-S-Tab> <C-w>w
vnoremap <C-S-Tab> <C-c><C-w>w
inoremap <C-S-Tab> <C-o><C-w>w

nnoremap <C-Up> <C-w>k
vnoremap <C-Up> <C-c><C-w>k
inoremap <C-Up> <C-o><C-w>k
nnoremap <C-Down> <C-w>j
vnoremap <C-Down> <C-c><C-w>j
inoremap <C-Down> <C-o><C-w>j
nnoremap <C-Left> <C-w>h
vnoremap <C-Left> <C-c><C-w>h
inoremap <C-Left> <C-o><C-w>h
nnoremap <C-Right> <C-w>l
vnoremap <C-Right> <C-c><C-w>l
inoremap <C-Right> <C-o><C-w>l

" Move lines
nnoremap <silent> <M-Up> mz:m-2<CR>`z
vnoremap <silent> <M-Up> :m'<-2<CR>`>v`<
inoremap <silent> <M-Up> <C-\><C-o>mz<C-o>:m-2<CR><C-o>`z
nnoremap <silent> <M-Down> mz:m+<CR>`z
vnoremap <silent> <M-Down> :m'>+<CR>`<v`>
inoremap <silent> <M-Down> <C-\><C-o>mz<C-o>:m+<CR><C-o>`z

vnoremap <silent> <M-Left> <`>$v`<0
nnoremap <silent> <M-Left> :call keny#ShiftLineLeftRight(-1)<CR>
inoremap <silent> <M-Left> <C-o>:call keny#ShiftLineLeftRight(-1)<CR>
vnoremap <silent> <M-Right> >`<0v`>$
nnoremap <silent> <M-Right> :call keny#ShiftLineLeftRight(1)<CR>
inoremap <silent> <M-Right> <C-o>:call keny#ShiftLineLeftRight(1)<CR>

if has('macunix')
  nmap <D-Up> <M-Up>
  vmap <D-Up> <M-Up>
  imap <D-Up> <M-Up>
  nmap <D-Down> <M-Down>
  vmap <D-Down> <M-Down>
  imap <D-Down> <M-Down>
  nmap <D-Left> <M-Left>
  vmap <D-Left> <M-Left>
  imap <D-Left> <M-Left>
  nmap <D-Right> <M-Right>
  vmap <D-Right> <M-Right>
  imap <D-Right> <M-Right>
endif
" }}}

" Menus {{{
" Main menu: File
if has('gui_macvim')
  an 10.326 File.-KSEP1-                                  <Nop>
  an 10.327 File.Reopen\ Using\ Encoding.Unicode\ (UTF-8) :conf e ++enc=utf-8<CR>
elseif has('gui_win32')
  an 10.329 File.Browse\ Recent\ Files                    :browse oldfiles<CR>
  an 10.331 File.-KSEP1-                                  <Nop>
  an 10.332 File.Reopen\ Using\ Encoding.Unicode\ (UTF-8) :conf e ++enc=utf-8<CR>
endif
an File.Reopen\ Using\ Encoding.Unicode\ (UTF-16)         :conf e ++enc=utf-16<CR>
an File.Reopen\ Using\ Encoding.-KSEP1-                   <Nop>
an File.Reopen\ Using\ Encoding.Chinese\ (GB18030)        :conf e ++enc=gb18030<CR>
an File.Reopen\ Using\ Encoding.Chinese\ (GBK)            :conf e ++enc=gbk<CR>
an File.Reopen\ Using\ Encoding.Chinese\ (Big-5)          :conf e ++enc=big5<CR>
an File.Reopen\ Using\ Encoding.Japanese\ (Shift-JIS)     :conf e ++enc=sjis<CR>
an File.Reopen\ Using\ Encoding.Japanese\ (ISO-2022-JP)   :conf e ++enc=iso-2022-jp<CR>
an File.Reopen\ Using\ Encoding.Japanese\ (EUC-JP)        :conf e ++enc=euc-jp<CR>
an File.Reopen\ Using\ Encoding.Western\ (Latin-1)        :conf e ++enc=latin1<CR>

" Main menu: Edit
an 20.421 Edit.-KSEP1-                                    <Nop>
nnoreme <silent> 20.422 Edit.Insert.File\ Path\.\.\.      "=browse(0, 'Insert File Path', expand('%:p:h'), '')<CR>P
inoreme <silent> Edit.Insert.File\ Path\.\.\.             <C-r>=browse(0, 'Insert File Path', expand('%:p:h'), '')<CR>
nnoreme <silent> Edit.Insert.Folder\ Path\.\.\.           "=browsedir('Insert Folder Path', expand('%:p:h'))<CR>P
inoreme <silent> Edit.Insert.Folder\ Path\.\.\.           <C-r>=browsedir('Insert Folder Path', expand('%:p:h'))<CR>
an Edit.Insert.-KSEP1-                                    <Nop>
nnoreme <silent> Edit.Insert.Current\ Filename            "=expand('%')<CR>P
inoreme <silent> Edit.Insert.Current\ Filename            <C-r>=expand('%')<CR>
nnoreme <silent> Edit.Insert.Current\ Filename\ &&\ Path  "=expand('%:p')<CR>P
inoreme <silent> Edit.Insert.Current\ Filename\ &&\ Path  <C-r>=expand('%:p')<CR>
nnoreme <silent> Edit.Insert.Current\ Working\ Path       "=expand('%:p:h')<CR>P
inoreme <silent> Edit.Insert.Current\ Working\ Path       <C-r>=expand('%:p:h')<CR>
an Edit.Insert.-KSEP2-                                    <Nop>
nnoreme <silent> Edit.Insert.Time\ Stamp                  "=strftime('%c')<CR>P
inoreme <silent> Edit.Insert.Time\ Stamp                  <C-r>=strftime('%c')<CR>
nnoreme <silent> Edit.Insert.Today                        "=strftime('%b %d, %Y')<CR>P
inoreme <silent> Edit.Insert.Today                        <C-r>=strftime('%b %d, %Y')<CR>
nnoreme <silent> Edit.Insert.Today\ (mm/dd/yy)            "=strftime('%m/%d/%y')<CR>P
inoreme <silent> Edit.Insert.Today\ (mm/dd/yy)            <C-r>=strftime('%m/%d/%y')<CR>
nnoreme <silent> Edit.Insert.Today\ (yyyy-mm-dd)          "=strftime('%Y-%m-%d')<CR>P
inoreme <silent> Edit.Insert.Today\ (yyyy-mm-dd)          <C-r>=strftime('%Y-%m-%d')<CR>

vnoreme <silent> 20.423 Edit.Convert.Make\ Uppercase      Ugv
vnoreme <silent> Edit.Convert.Make\ Lowercase             ugv
vnoreme <silent> Edit.Convert.Toggle\ Case                ~gv
an Edit.Convert.-KSEP1-                                   <Nop>
vnoreme <silent> Edit.Convert.Toggle\ Comments            :call keny#ToggleComments()<CR>
an Edit.Convert.-KSEP2-                                   <Nop>
vnoreme <silent> Edit.Convert.Align\ Text\ Left           :left<CR>`>$v`<0
vnoreme <silent> Edit.Convert.Center\ Text                :center<CR>`<0v`>$
vnoreme <silent> Edit.Convert.Align\ Text\ Right          :right<CR>`<0v`>$
an Edit.Convert.-KSEP3-                                   <Nop>
vnoreme <silent> Edit.Convert.Shift\ Selection\ Up        :m'<-2<CR>`>v`<
vnoreme <silent> Edit.Convert.Shift\ Selection\ Down      :m'>+<CR>`<v`>
vnoreme <silent> Edit.Convert.Shift\ Selection\ to\ Left  <`>$v`<0
vnoreme <silent> Edit.Convert.Shift\ Selection\ to\ Right >`<0v`>$
an Edit.Convert.-KSEP4-                                   <Nop>
vnoreme <silent> Edit.Convert.Join\ Lines                 Jgv
vnoreme <silent> Edit.Convert.Split\ Lines                :call keny#SplitLinesNicely()<CR>
vnoreme <silent> Edit.Convert.Duplicate\ Lines            Y`>]pgv
vnoreme <silent> Edit.Convert.Delete\ Lines               D
vnoreme <silent> Edit.Convert.Wrap\ Lines                 gqgv
vnoreme <silent> Edit.Convert.Sort\ Lines.Ascending       :sort i<CR>
vnoreme <silent> Edit.Convert.Sort\ Lines.Descending      :sort! i<CR>
vnoreme <silent> Edit.Convert.Merge\ Blank\ Lines         :call keny#MergeBlankLines()<CR>
vnoreme <silent> Edit.Convert.Strip\ Trailing\ Blanks     :call keny#StripTrailingWhiteSpaces()<CR>
an Edit.Convert.-KSEP5-                                   <Nop>
an <silent> Edit.Convert.Change\ Line\ Endings\ To.MS-Win :setlocal ff=dos<CR>
an <silent> Edit.Convert.Change\ Line\ Endings\ To.UNIX   :setlocal ff=unix<CR>
an <silent> Edit.Convert.Change\ Line\ Endings\ To.Mac    :setlocal ff=mac<CR>
an Edit.Convert.-KSEP6-                                   <Nop>
an <silent> Edit.Convert.Convert\ Encoding\ to\ UTF-8     :setlocal fenc=utf-8<CR>
an <silent> Edit.Convert.Convert\ Encoding\ to\ UTF-16    :setlocal fenc=utf-16<CR>

" Popup menu
an PopUp.-KSEP0-                                          <Nop>
if has('gui_macvim')
  an <silent> PopUp.Open\ Containing\ Folder              :if expand('%:p:h') != '' \| silent exec '!start open' expand('%:p:h:S') \| endif<CR>
elseif has('gui_win32')
  an <silent> PopUp.Open\ Containing\ Folder              :if expand('%:p:h') != '' \| silent exec '!start explorer.exe' expand('%:p:h:S') \| endif<CR>
endif
an <silent> PopUp.Copy\ Current\ Path\ to\ Clipboard      :let @+ = expand('%:p')<CR>

nnoremenu PopUp.-KSEP1-                                   <Nop>
nnoremenu <silent> PopUp.Current\ Filename                "=expand('%')<CR>P
nnoremenu <silent> PopUp.Current\ Filename\ &&\ Path      "=expand('%:p')<CR>P
nnoremenu <silent> PopUp.Current\ Working\ Path           "=expand('%:p:h')<CR>P
nnoremenu PopUp.-KSEP2-                                   <Nop>
nnoremenu <silent> PopUp.Time\ Stamp                      "=strftime('%c')<CR>P
nnoremenu <silent> PopUp.Today                            "=strftime('%b %d, %Y')<CR>P
nnoremenu <silent> PopUp.Today\ (mm/dd/yy)                "=strftime('%m/%d/%y')<CR>P
nnoremenu <silent> PopUp.Today\ (yyyy-mm-dd)              "=strftime('%Y-%m-%d')<CR>P

inoremenu PopUp.-KSEP1-                                   <Nop>
inoremenu <silent> PopUp.Current\ Filename                <C-r>=expand('%')<CR>
inoremenu <silent> PopUp.Current\ Filename\ &&\ Path      <C-r>=expand('%:p')<CR>
inoremenu <silent> PopUp.Current\ Working\ Path           <C-r>=expand('%:p:h')<CR>
inoremenu PopUp.-KSEP2-                                   <Nop>
inoremenu <silent> PopUp.Time\ Stamp                      <C-r>=strftime('%c')<CR>
inoremenu <silent> PopUp.Today                            <C-r>=strftime('%b %d, %Y')<CR>
inoremenu <silent> PopUp.Today\ (mm/dd/yy)                <C-r>=strftime('%m/%d/%y')<CR>
inoremenu <silent> PopUp.Today\ (yyyy-mm-dd)              <C-r>=strftime('%Y-%m-%d')<CR>

vnoremenu PopUp.-KSEP1-                                   <Nop>
vnoremenu <silent> PopUp.Make\ Uppercase                  Ugv
vnoremenu <silent> PopUp.Make\ Lowercase                  ugv
vnoremenu <silent> PopUp.Toggle\ Case                     ~gv
vnoremenu PopUp.-KSEP2-                                   <Nop>
vnoremenu <silent> PopUp.Toggle\ Comments                 :call keny#ToggleComments()<CR>
vnoremenu PopUp.-KSEP3-                                   <Nop>
vnoremenu <silent> PopUp.Align\ Text\ Left                :left<CR>`>$v`<0
vnoremenu <silent> PopUp.Center\ Text                     :center<CR>`<0v`>$
vnoremenu <silent> PopUp.Align\ Text\ Right               :right<CR>`<0v`>$
vnoremenu PopUp.-KSEP4-                                   <Nop>
vnoremenu <silent> PopUp.Shift\ Selection\ Up             :m'<-2<CR>`>v`<
vnoremenu <silent> PopUp.Shift\ Selection\ Down           :m'>+<CR>`<v`>
vnoremenu <silent> PopUp.Shift\ Selection\ to\ Left       <`>$v`<0
vnoremenu <silent> PopUp.Shift\ Selection\ to\ Right      >`<0v`>$
vnoremenu PopUp.-KSEP5-                                   <Nop>
vnoremenu <silent> PopUp.Join\ Lines                      Jgv
vnoremenu <silent> PopUp.Split\ Lines                     :call keny#SplitLinesNicely()<CR>
vnoremenu <silent> PopUp.Duplicate\ Lines                 Y`>]pgv
vnoremenu <silent> PopUp.Delete\ Lines                    D
vnoremenu <silent> PopUp.Wrap\ Lines                      gqgv
vnoremenu <silent> PopUp.Sort\ Lines.Ascending            :sort i<CR>
vnoremenu <silent> PopUp.Sort\ Lines.Descending           :sort! i<CR>
vnoremenu <silent> PopUp.Merge\ Blank\ Lines              :call keny#MergeBlankLines()<CR>
vnoremenu <silent> PopUp.Strip\ Trailing\ Blanks          :call keny#StripTrailingWhiteSpaces()<CR>
" }}}

" vim:foldmethod=marker:foldlevel=0
