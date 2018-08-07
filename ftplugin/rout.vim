" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

" Local settings
setlocal nowrap cursorline
setlocal iskeyword=@,48-57,_,.

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

" Local functions
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
