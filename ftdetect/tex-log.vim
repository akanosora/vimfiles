au BufRead *.log call s:FindTeXLog()

function! s:FindTeXLog()
  if exists("g:filetype_log")
    exe "setfiletype " . g:filetype_log
  elseif getline(1) =~# '^This is \S*TeX[^,]*, Version .\+$'
    setfiletype tex-log
  else
    return
  endif
endfunction
