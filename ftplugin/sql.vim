" Only do this when not done yet for this buffer
if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

" Local settings
setlocal cms=--%s
setlocal omnifunc=sqlcomplete#Complete

" Set comment toggle
nnoremap <buffer> <silent> <F3> :call <SID>SwitchBuffer('log', 0)<CR>
vnoremap <buffer> <silent> <F3> <C-c>:call <SID>SwitchBuffer('log', 0)<CR>
inoremap <buffer> <silent> <F3> <Esc>:call <SID>SwitchBuffer('log', 0)<CR>

nnoremap <buffer> <silent> <F5> :call keny#ToggleComments()<CR>
vnoremap <buffer> <silent> <F5> :call keny#ToggleComments()<CR>
inoremap <buffer> <silent> <F5> <C-o>:call keny#ToggleComments()<CR>
cnoremap <buffer> <silent> <F5> <C-c>:call keny#ToggleComments()<CR>
onoremap <buffer> <silent> <F5> <C-c>:call keny#ToggleComments()<CR>

nnoremap <buffer> <silent> <F8> :call <SID>ExecQuery()<CR>
vnoremap <buffer> <silent> <F8> :call <SID>ExecQuery()<CR>
inoremap <buffer> <silent> <F8> <C-o>:call <SID>ExecQuery()<CR>
cnoremap <buffer> <silent> <F8> <C-c>:call <SID>ExecQuery()<CR>
onoremap <buffer> <silent> <F8> <C-c>:call <SID>ExecQuery()<CR>

nnoremap <buffer> <silent> <S-F8> :1,$call <SID>ExecQuery()<CR>
vnoremap <buffer> <silent> <S-F8> :1,$call <SID>ExecQuery()<CR>
inoremap <buffer> <silent> <S-F8> <C-o>:1,$call <SID>ExecQuery()<CR>
cnoremap <buffer> <silent> <S-F8> <C-c>:1,$call <SID>ExecQuery()<CR>
onoremap <buffer> <silent> <S-F8> <C-c>:1,$call <SID>ExecQuery()<CR>

" Local functions
let g:sqlplus_userid = get(g:, 'sqlplus_userid', '')
let g:sqlplus_passwd = get(g:, 'sqlplus_passwd', '')
let g:sqlplus_db     = get(g:, 'sqlplus_db', $ORACLE_SID)

function! s:ExecQuery() range
  if g:sqlplus_userid ==# ''
    call s:ResetLogon()
  endif
  silent execute a:firstline . ',' . a:lastline . 'w !sqlplus -s -L ' .
        \ g:sqlplus_userid . '/' . escape(g:sqlplus_passwd, '#') .
        \ '@' . g:sqlplus_db . ' > ' . expand('%<') . '.log'
endfunction

function! s:ResetLogon()
  if g:sqlplus_userid ==# ''
    let userid = has('win32') ? '' : substitute(system('whoami'), "\n", '', 'g')
  else
    let userid = g:sqlplus_userid
  endif
  let g:sqlplus_userid = input('Please enter your SQL*Plus user-id: ', userid)
  let g:sqlplus_passwd = inputsecret('Please enter your SQL*Plus password: ')
  let g:sqlplus_db     = input('Please enter your database name: ', g:sqlplus_db)
endfunction

function! s:SwitchBuffer(dest, rw)
  if expand('%:e') ==# a:dest | return | endif
  let to_buffer = substitute(bufname('%'), expand('%:e') . '$', a:dest, '')
  if bufnr(to_buffer) >= 0
    silent execute 'buffer' bufnr(to_buffer)
  elseif filereadable(expand('%<') . '.' . a:dest)
    silent execute (a:rw ? 'edit' : 'view') fnameescape(expand('%<') . '.' . a:dest)
  endif
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
