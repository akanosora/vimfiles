function! s:DetectNode()
  if len(findfile(expand('%<') . '.sas', '.')) > 0
    set filetype=sas-log
  endif
endfunction

au BufNewFile,BufRead *.log call s:DetectNode()
