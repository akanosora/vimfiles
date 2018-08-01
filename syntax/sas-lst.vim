" Vim syntax file
" Language:    SAS lst file
" Maintainer:  Zhenhuan Hu <zhu@mcw.edu>
" Last Change: Mar 11, 2017

" Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn case match
syn match saslstNumber display /\v<\d+%(\.\d+)=%(>|e[\-+]=\d+>)/
syn match saslstRtfTag display /\\R'\(\\tab\)\+'/

hi def link saslstNumber Number
hi def link saslstRtfTag Ignore

let b:current_syntax = 'sas-lst'

let &cpo = s:cpo_save
unlet s:cpo_save
