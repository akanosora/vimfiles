" Only do this when not done yet for this buffer
if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

" Local settings
setlocal softtabstop=4 shiftwidth=4 expandtab
setlocal textwidth=80 colorcolumn=81
setlocal comments=nb:#,fb:- commentstring=#%s
setlocal omnifunc=pythoncomplete#Complete

" Set compiler
setlocal makeprg=python
setlocal efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

nnoremap <buffer> <silent> <F8> :w !python<CR>
vnoremap <buffer> <silent> <F8> :w !python<CR>
inoremap <buffer> <silent> <F8> <C-o>:w !python<CR>
cnoremap <buffer> <silent> <F8> <C-c>:w !python<CR>
onoremap <buffer> <silent> <F8> <C-c>:w !python<CR>

nnoremap <buffer> <silent> <S-F8> :w !python3<CR>
vnoremap <buffer> <silent> <S-F8> :w !python3<CR>
inoremap <buffer> <silent> <S-F8> <C-o>:w !python3<CR>
cnoremap <buffer> <silent> <S-F8> <C-c>:w !python3<CR>
onoremap <buffer> <silent> <S-F8> <C-c>:w !python3<CR>

" Set comment toggle
nnoremap <buffer> <silent> <F5> :call keny#ToggleComments()<CR>
vnoremap <buffer> <silent> <F5> :call keny#ToggleComments()<CR>
inoremap <buffer> <silent> <F5> <C-o>:call keny#ToggleComments()<CR>
cnoremap <buffer> <silent> <F5> <C-c>:call keny#ToggleComments()<CR>
onoremap <buffer> <silent> <F5> <C-c>:call keny#ToggleComments()<CR>

let &cpo = s:cpo_save
unlet s:cpo_save
