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

nnoremap <buffer> <silent> <F8> :call <SID>RunR()<CR>
vnoremap <buffer> <silent> <F8> :call <SID>RunR()<CR>
inoremap <buffer> <silent> <F8> <C-o>:call <SID>RunR()<CR>
cnoremap <buffer> <silent> <F8> <C-c>:call <SID>RunR()<CR>
onoremap <buffer> <silent> <F8> <C-c>:call <SID>RunR()<CR>

nnoremap <buffer> <silent> <S-F8> :call <SID>RunRScript()<CR>
vnoremap <buffer> <silent> <S-F8> :call <SID>RunRScript()<CR>
inoremap <buffer> <silent> <S-F8> <C-o>:call <SID>RunRScript()<CR>>
cnoremap <buffer> <silent> <S-F8> <C-c>:call <SID>RunRScript()<CR>
onoremap <buffer> <silent> <S-F8> <C-c>:call <SID>RunRScript()<CR>

nnoremap <buffer> <silent> <F7> :call <SID>ExecuteOneLineR()<CR>
vnoremap <buffer> <silent> <F7> :call <SID>ExecuteOneLineR()<CR>
inoremap <buffer> <silent> <F7> <C-o>:call <SID>ExecuteOneLineR()<CR>
cnoremap <buffer> <silent> <F7> <C-c>:call <SID>ExecuteOneLineR()<CR>
onoremap <buffer> <silent> <F7> <C-c>:call <SID>ExecuteOneLineR()<CR>

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

function! s:RunR()
  update
  call system('R CMD BATCH --no-restore --no-save --quiet ' . shellescape(expand('%:p')))
  if v:shell_error ==# 0
    echo 'All steps terminated normally'
  else
    echo 'Exit status code: ' . v:shell_error
  endif
endfunction

function! s:RunRScript()
  update
  execute '!Rscript ' . shellescape(expand('%:p'))
endfunction

function! s:ExecuteOneLineR()
  call inputsave()
  let rcmd = input('Run R command: ')
  call inputrestore()
  execute '!Rscript -e ' . shellescape(rcmd)
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
