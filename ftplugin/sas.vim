" Vim filetype plugin file
" Language:	SAS
" Maintainer:	Zhen-Huan Hu <wildkeny@gmail.com>
" Last Change:	May 12, 2017

" Only do this when not done yet for this buffer
if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

" Local settings
setlocal softtabstop=2 shiftwidth=2 expandtab
setlocal textwidth=80 formatoptions=croq
setlocal comments=sr:/*,mb:*,ex:*/ commentstring=/*%s*/
setlocal omnifunc=sascomplete#Complete
setlocal makeprg=sas\ -noverbose\ -sysin\ '%:p'

" Find autoexec files from $PATH
for syspath in split(expand('$PATH'), has('win32') ? ';' : ':')
  if filereadable(syspath . '/autoexec.sas')
    let &l:path = &path . ',' . syspath
  endif
endfor

" Change the browse dialog on Win32 to show mainly Perl-related files
if has('gui_win32')
  let b:browsefilter = "SAS Source Files (*.sas)\t*.sas\n" .
        \ "SAS Log Files (*.log)\t*.log\n" .
        \ "SAS Output Files (*.lst)\t*.lst\n" .
        \ "All Files (*.*)\t*.*\n"
endif

" Restore view
" augroup SASView
"   autocmd!
"   au BufWinEnter *.sas silent loadview
"   au BufWritePost,BufLeave,WinLeave *.sas mkview
" augroup END

" Key mappings
nnoremap <buffer> <silent> ]] :call <SID>JumpSASCode('n', '\v%$\|^(data\|proc)>', 'W')<CR>
onoremap <buffer> <silent> ]] :call <SID>JumpSASCode('o', '\v%$\|^(data\|proc)>', 'W')<CR>
xnoremap <buffer> <silent> ]] :call <SID>JumpSASCode('x', '\v%$\|^(data\|proc)>', 'W')<CR>

nnoremap <buffer> <silent> [[ :call <SID>JumpSASCode('n', '\v%^\|^(data\|proc)>', 'Wb')<CR>
onoremap <buffer> <silent> [[ :call <SID>JumpSASCode('o', '\v%^\|^(data\|proc)>', 'Wb')<CR>
xnoremap <buffer> <silent> [[ :call <SID>JumpSASCode('x', '\v%^\|^(data\|proc)>', 'Wb')<CR>

nnoremap <buffer> <silent> <F2> :call <SID>SwitchSASBuffer('sas', 1)<CR>
vnoremap <buffer> <silent> <F2> <C-c>:call <SID>SwitchSASBuffer('sas', 1)<CR>
inoremap <buffer> <silent> <F2> <Esc>:call <SID>SwitchSASBuffer('sas', 1)<CR>

nnoremap <buffer> <silent> <F3> :call <SID>SwitchSASBuffer('log', 0)<CR>
vnoremap <buffer> <silent> <F3> <C-c>:call <SID>SwitchSASBuffer('log', 0)<CR>
inoremap <buffer> <silent> <F3> <Esc>:call <SID>SwitchSASBuffer('log', 0)<CR>

nnoremap <buffer> <silent> <F4> :call <SID>SwitchSASBuffer('lst', 0)<CR>
vnoremap <buffer> <silent> <F4> <C-c>:call <SID>SwitchSASBuffer('lst', 0)<CR>
inoremap <buffer> <silent> <F4> <Esc>:call <SID>SwitchSASBuffer('lst', 0)<CR>

nnoremap <buffer> <silent> <F8> :call <SID>RunSAS()<CR>
vnoremap <buffer> <silent> <F8> :call <SID>RunSAS()<CR>
inoremap <buffer> <silent> <F8> <C-o>:call <SID>RunSAS()<CR>
cnoremap <buffer> <silent> <F8> <C-c>:call <SID>RunSAS()<CR>
onoremap <buffer> <silent> <F8> <C-c>:call <SID>RunSAS()<CR>

" Set comment toggle
nnoremap <buffer> <silent> <F5> :call keny#ToggleComments()<CR>
vnoremap <buffer> <silent> <F5> :call keny#ToggleComments()<CR>
inoremap <buffer> <silent> <F5> <C-o>:call keny#ToggleComments()<CR>
cnoremap <buffer> <silent> <F5> <C-c>:call keny#ToggleComments()<CR>
onoremap <buffer> <silent> <F5> <C-c>:call keny#ToggleComments()<CR>

nnoremap <buffer> <silent> <S-F5> :call <SID>ToggleSASComments()<CR>
vnoremap <buffer> <silent> <S-F5> :call <SID>ToggleSASComments()<CR>
inoremap <buffer> <silent> <S-F5> <C-o>:call <SID>ToggleSASComments()<CR>
cnoremap <buffer> <silent> <S-F5> <C-c>:call <SID>ToggleSASComments()<CR>
onoremap <buffer> <silent> <S-F5> <C-c>:call <SID>ToggleSASComments()<CR>

" Local functions
function! s:ToggleSASComments()
  if getline('.') !~# '^\s*$'
    " Save the value of last search register
    let saved_last_search_pattern = @/
    silent exec 's/;\s\+$/;/e'
    if getline('.') =~# '^\* '
      silent exec 's/\(^\|; \)\* /\1/ge'
    else
      silent exec 's/\(^\|; \)/\1* /ge'
    endif
    " Restore the value of last search register
    " and thus remove highlighting of whitespaces
    let @/ = saved_last_search_pattern
  endif
  " Move cursor to the next line
  silent exec 'normal! +'
endfunction

function! s:JumpSASCode(mode, motion, flags) range
  if a:mode == 'x'
    normal! gv
  endif
  normal! 0
  let cnt = v:count1
  mark '
  while cnt > 0
    call search(a:motion, a:flags)
    let cnt = cnt - 1
  endwhile
  normal! ^
endfunction

function! s:RunSAS()
  update
  silent make
  if v:shell_error ==# 0
    echo 'All steps terminated normally'
  elseif v:shell_error ==# 1 || v:shell_error ==# 2
    if filereadable(expand('%<') . '.log')
      let nw = 0 | let ne = 0
      for logline in readfile(expand('%<') . '.log')
        if logline =~# '^WARNING' | let nw += 1
        elseif logline =~# '^ERROR' | let ne += 1 | endif
      endfor
      if nw > 0 && ne == 0
        echoh WarningMsg | echo 'SAS System issued ' . nw . ' warning(s)' | echoh None
      elseif ne > 0 && nw == 0
        echoh ErrorMsg | echo 'SAS System issued ' . ne . ' error(s)' | echoh None
      elseif ne > 0 && nw > 0
        echoh ErrorMsg | echo 'SAS System issued ' . ne . ' error(s), ' . nw . ' warning(s)' | echoh None
      endif
    elseif v:shell_error ==# 1
      echoh WarningMsg | echo 'SAS System issued warning(s)' | echoh None
    elseif v:shell_error ==# 2
      echoh ErrorMsg | echo 'SAS System issued error(s)' | echoh None
    endif
  elseif v:shell_error ==# 3
    echo 'User issued the ABORT statement'
  elseif v:shell_error ==# 4
    echo 'User issued the ABORT RETURN statement'
  elseif v:shell_error ==# 5
    echo 'User issued the ABORT ABEND statement'
  elseif v:shell_error ==# 6
    echoh ErrorMsg | echo 'SAS internal error' | echoh None
  else
    echo 'Exit status code: ' . v:shell_error
  endif
endfunction

function! s:SwitchSASBuffer(dest, rw)
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
