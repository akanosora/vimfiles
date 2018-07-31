" Vim indent file
" Language:     SAS
" Maintainer:   Zhen-Huan Hu <wildkeny@gmail.com>
" Version:      3.0.6
" Last Change:  2018-07-30

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetSASIndent()
setlocal indentkeys+=;,=~data,=~proc

if exists("*GetSASIndent")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" List of procs supporting run-processing
let s:run_processing_procs = [
      \ 'catalog', 'chart', 'datasets', 'document', 'ds2', 'plot', 'sql',
      \ 'gareabar', 'gbarline', 'gchart', 'gkpi', 'gmap', 'gplot', 'gradar', 'greplay', 'gslide', 'gtile',
      \ 'anova', 'arima', 'catmod', 'factex', 'glm', 'model', 'optex', 'plan', 'reg',
      \ 'iml',
      \ ]

" Regex that captures the start of a data/proc section
let s:section_str = '\v%(^|;)\s*%(data|proc)>'
" Regex that captures the start of a data/proc section that supports run-processing
let s:section_rpp_str = '\v%(^|;)\s*proc\s+%(' . join(s:run_processing_procs, '|') . ')>'
" Regex that captures the end of a data/proc section
let s:section_run = '\v%(^|;)\s*run\s*;'
" Regex that captures the end of a data/proc section that supports run-processing
let s:section_end = '\v%(^|;)\s*%(quit|enddata)\s*;'

" Regex that captures the start of a control block within data section
let s:block_str = '\v<%(do>%([^;]+<%(to|over|while)>[^;]+)=|select%(\s+\([^;]+\))=)\s*;'
" Regex that captures the start of a control block within proc section
let s:block_proc_str = '\v%(^|;)\s*%(begingraph|compute|define|edit|layout|method)>'
" Regex that captures the end of a control block
let s:block_end = '\v<%(end|endcomp|endlayout|endgraph)\s*;'

" Regex that captures the start of a submit block
let s:submit_str = '\v%(^|;)\s*submit>'
" Regex that captures the end of a submit block
let s:submit_end = '\v%(^|;)\s*endsubmit\s*;'

" Regex that captures the start of a macro definition
let s:macro_str = '\v%(^|;)\s*\%macro>'
" Regex that captures the end of a macro definition
let s:macro_end = '\v%(^|;)\s*\%mend\s*;'

" Regex that defines the end of the program
let s:program_end = '\v%(^|;)\s*endsas\s*;'

" Find the line number of previous keyword defined by the regex
function! s:PrevMatch(lnum, regex)
  let skip_line = '\v%(^|;)\s*\%=\*'
  let prev_lnum = prevnonblank(a:lnum - 1)
  while prev_lnum > 0
    let prev_line = getline(prev_lnum)
    if prev_line =~? a:regex && prev_line !~? skip_line
      break
    else
      let prev_lnum = prevnonblank(prev_lnum - 1)
    endif
  endwhile
  return prev_lnum
endfunction

" Main function
function! GetSASIndent()
  let prev_lnum = prevnonblank(v:lnum - 1)
  if prev_lnum ==# 0
    " Leave the indentation of the first line unchanged
    return indent(1)
  else
    let prev_line = getline(prev_lnum)
    " Previous non-blank line contains the start of a macro/section/block
    " while not the end of a macro/section/block (at the same line)
    if (prev_line =~? s:section_str && prev_line !~? s:section_run && prev_line !~? s:section_end) ||
          \ (prev_line =~? s:block_str && prev_line !~? s:block_end) ||
          \ (prev_line =~? s:block_proc_str && prev_line !~? s:block_end) ||
          \ (prev_line =~? s:submit_str && prev_line !~? s:submit_end) ||
          \ (prev_line =~? s:macro_str && prev_line !~? s:macro_end)
      let ind = indent(prev_lnum) + shiftwidth()
    elseif prev_line =~? s:section_run && prev_line !~? s:section_end
      let prev_section_str_lnum = s:PrevMatch(v:lnum, s:section_str)
      let prev_section_end_lnum = max([
            \ s:PrevMatch(v:lnum, s:section_end),
            \ s:PrevMatch(v:lnum, s:submit_str ),
            \ s:PrevMatch(v:lnum, s:submit_end ),
            \ s:PrevMatch(v:lnum, s:macro_str  ),
            \ s:PrevMatch(v:lnum, s:macro_end  ),
            \ s:PrevMatch(v:lnum, s:program_end)])
      " Check if the previous section supports run-processing
      if prev_section_end_lnum < prev_section_str_lnum &&
            \ getline(prev_section_str_lnum) =~? s:section_rpp_str
        let ind = indent(prev_lnum) + shiftwidth()
      else
        let ind = indent(prev_lnum)
      endif
    else
      let ind = indent(prev_lnum)
    endif
  endif
  " Re-adjustments based on the inputs of the current line
  let curr_line = getline(v:lnum)
  if curr_line =~? s:program_end
    " End of the program
    let prev_macro_str_lnum = s:PrevMatch(v:lnum, s:macro_str)
    let prev_macro_end_lnum = s:PrevMatch(v:lnum, s:macro_end)
    if prev_macro_end_lnum < prev_macro_str_lnum
      " Same indentation as the first non-blank line within the macro definition
      return indent(nextnonblank(prev_macro_str_lnum + 1))
    else
      " Same indentation as the first non-blank line
      return indent(nextnonblank(1))
    endif
  elseif curr_line =~? s:macro_end && curr_line !~? s:macro_str
    " Current line is the end of a macro
    " Match the indentation of the start of the macro
    return indent(s:PrevMatch(v:lnum, s:macro_str))
  elseif curr_line =~? s:section_end
    " Current line is the end of a run-processing section
    " Match the indentation of the start of the run-processing section
    let prev_section_rpp_str_lnum = s:PrevMatch(v:lnum, s:section_rpp_str)
    let prev_section_end_lnum = max([
          \ s:PrevMatch(v:lnum, s:section_end),
          \ s:PrevMatch(v:lnum, s:macro_str  ),
          \ s:PrevMatch(v:lnum, s:macro_end  ),
          \ s:PrevMatch(v:lnum, s:program_end)])
    if prev_section_end_lnum < prev_section_rpp_str_lnum
      return indent(prev_section_rpp_str_lnum)
    endif
  elseif curr_line =~? s:section_str || curr_line =~? s:section_run
    " Re-adjust if current line is the start/end of a section
    " since the end of the previous section could be inexplicit
    let prev_section_str_lnum = s:PrevMatch(v:lnum, s:section_str)
    let prev_section_end_lnum = max([
          \ s:PrevMatch(v:lnum, s:section_end),
          \ s:PrevMatch(v:lnum, s:submit_str ),
          \ s:PrevMatch(v:lnum, s:submit_end ),
          \ s:PrevMatch(v:lnum, s:macro_str  ),
          \ s:PrevMatch(v:lnum, s:macro_end  ),
          \ s:PrevMatch(v:lnum, s:program_end)])
    if prev_section_end_lnum < prev_section_str_lnum
      return indent(prev_section_str_lnum)
    endif
  elseif curr_line =~? s:submit_end && curr_line !~? s:submit_str
    " Current line is the end of a submit block
    " Match the indentation of the start of the submit block
    return indent(s:PrevMatch(v:lnum, s:submit_str))
  elseif curr_line =~? s:block_end && curr_line !~? s:block_str && curr_line !~? s:block_proc_str
    " Re-adjust if current line is the end of a block
    " while not the beginning of a block (at the same line)
    " Returning the indent of previous block start directly
    " would not work due to nesting
    let ind = ind - shiftwidth()
  endif
  return ind
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
