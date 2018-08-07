" Only do this when not yet done for this buffer
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

" Local settings
setlocal softtabstop=2 shiftwidth=2 expandtab
setlocal iskeyword=@,48-57,_,.
setlocal formatoptions-=t
setlocal commentstring=#\ %s
setlocal comments=:#',:###,:##,:#

" Change the browse dialog on Win32 to show mainly R-related files
if has("gui_win32") && !exists("b:browsefilter")
  let b:browsefilter = "R Source Files (*.R)\t*.R\n" .
        \ "Files that include R (*.Rnw *.Rd *.Rmd *.Rrst)\t*.Rnw;*.Rd;*.Rmd;*.Rrst\n" .
        \ "All Files (*.*)\t*.*\n"
endif

let b:undo_ftplugin = "setl cms< com< fo< isk< | unlet! b:browsefilter"

" Set kep mappings
nnoremap <buffer> <silent> <F2> :call <SID>SwitchRBuffer('R', 1)<CR>
vnoremap <buffer> <silent> <F2> <C-c>:call <SID>SwitchRBuffer('R', 1)<CR>
inoremap <buffer> <silent> <F2> <Esc>:call <SID>SwitchRBuffer('R', 1)<CR>

nnoremap <buffer> <silent> <F4> :call <SID>SwitchRBuffer('Rout', 0)<CR>
vnoremap <buffer> <silent> <F4> <C-c>:call <SID>SwitchRBuffer('Rout', 0)<CR>
inoremap <buffer> <silent> <F4> <Esc>:call <SID>SwitchRBuffer('Rout', 0)<CR>

nnoremap <buffer> <silent> <F8> :w !R CMD BATCH --no-restore --no-save --slave %<CR>
vnoremap <buffer> <silent> <F8> :w !R CMD BATCH --no-restore --no-save --slave %<CR>
inoremap <buffer> <silent> <F8> <C-o>:w !R CMD BATCH --no-restore --no-save --slave %<CR>
cnoremap <buffer> <silent> <F8> <C-c>:w !R CMD BATCH --no-restore --no-save --slave %<CR>
onoremap <buffer> <silent> <F8> <C-c>:w !R CMD BATCH --no-restore --no-save --slave %<CR>

nnoremap <buffer> <silent> <S-F8> :w !Rscript %<CR>
vnoremap <buffer> <silent> <S-F8> :w !Rscript %<CR>
inoremap <buffer> <silent> <S-F8> <C-o>:w !Rscript %<CR>
cnoremap <buffer> <silent> <S-F8> <C-c>:w !Rscript %<CR>
onoremap <buffer> <silent> <S-F8> <C-c>:w !Rscript %<CR>

" Set comment toggle
nnoremap <buffer> <silent> <F5> :call keny#ToggleComments()<CR>
vnoremap <buffer> <silent> <F5> :call keny#ToggleComments()<CR>
inoremap <buffer> <silent> <F5> <C-o>:call keny#ToggleComments()<CR>
cnoremap <buffer> <silent> <F5> <C-c>:call keny#ToggleComments()<CR>
onoremap <buffer> <silent> <F5> <C-c>:call keny#ToggleComments()<CR>

" Local function
function! s:SwitchRBuffer(dest, rw)
  if expand('%:e') ==# a:dest | return | endif
  let to_buffer = substitute(bufname('%'), expand('%:e') . '$', a:dest, '')
  if bufnr(to_buffer) >= 0
    silent execute 'hide buffer' bufnr(to_buffer)
  elseif filereadable(expand('%<') . '.' . a:dest)
    silent execute (a:rw ? 'hide edit' : 'hide view') fnameescape(expand('%<') . '.' . a:dest)
  endif
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
