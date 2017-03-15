" Only do this when not done yet for this buffer
if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

" Local settings
setlocal comments=nb:# commentstring=#%s

" Set compiler
nnoremap <buffer> <silent> <F8> :w !perl<CR>
vnoremap <buffer> <silent> <F8> :w !perl<CR>
inoremap <buffer> <silent> <F8> <C-o>:w !perl<CR>
cnoremap <buffer> <silent> <F8> <C-c>:w !perl<CR>
onoremap <buffer> <silent> <F8> <C-c>:w !perl<CR>

" Set comment toggle
nnoremap <buffer> <silent> <F5> :call keny#ToggleComments()<CR>
vnoremap <buffer> <silent> <F5> :call keny#ToggleComments()<CR>
inoremap <buffer> <silent> <F5> <C-o>:call keny#ToggleComments()<CR>
cnoremap <buffer> <silent> <F5> <C-c>:call keny#ToggleComments()<CR>
onoremap <buffer> <silent> <F5> <C-c>:call keny#ToggleComments()<CR>

let &cpo = s:cpo_save
unlet s:cpo_save
