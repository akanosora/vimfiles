function! s:DetectNode()
  if len(findfile(expand('%<') . '.sql', '.')) > 0
    set filetype=sql-log
  endif
endfunction

au BufNewFile,BufRead *.log call s:DetectNode()
