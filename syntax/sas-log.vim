" Vim syntax file
" Language:     SAS log file
" Maintainer:   Zhenhuan Hu <zhu@mcw.edu>
" Last Change:  2017-01-23

" Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn case match

" Numbers
syn match saslogNumber "\v<\-=%(\d+\.=\d*|\.\d+)%(e\-=\d+)=>" display contained

" Notes
syn keyword saslogSpecialKwd uninitialized contained
syn region saslogNote        matchgroup=saslogKeyword  start=/^NOTE:/         skip=/\n \{6}/  end=/$/ contains=saslogSpecialKwd
syn region saslogError       matchgroup=saslogKeyword  start=/^ERROR:/        skip=/\n \{7}/  end=/$/ contains=saslogSpecialKwd
syn region saslogWarning     matchgroup=saslogKeyword  start=/^WARNING:/      skip=/\n \{6}/  end=/$/ contains=saslogSpecialKwd

" Macro notes
syn region saslogMacroSource matchgroup=saslogMacroKwd start=/^MPRINT(\w\+):/ end=/$/ contains=saslogNumber
syn region saslogMacroLogic  matchgroup=saslogMacroKwd start=/^MLOGIC(\w\+):/ skip=/\n \{6}/  end=/$/
syn region saslogSymbolGen   matchgroup=saslogMacroKwd start=/^SYMBOLGEN:/    skip=/\n \{11}/ end=/$/

" The default highlighting.
hi def link saslogNote Comment
hi def link saslogSymbolGen Comment
hi def link saslogMacroLogic ModeMsg
hi def link saslogError ErrorMsg
hi def link saslogWarning WarningMsg
hi def link saslogNumber Number
hi def link saslogKeyword Special
hi def link saslogMacroKwd Macro
hi def link saslogSpecialKwd SpecialComment

" Syncronize from beginning to keep large blocks from losing
" syntax coloring while moving through code.
syn sync fromstart

let b:current_syntax = "sas-log"

let &cpo = s:cpo_save
unlet s:cpo_save
