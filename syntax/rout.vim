" Vim syntax file
" Language:    R output
" Maintainer:  Jakson Aquino <jalvesaq@gmail.com>
" Last Change: 2018-08-09

" For version 5.x: Clear all syntax items
" For version 6.x and 7.x: Quit when a syntax file was already loaded
if version < 600 
  syntax clear
elseif exists('b:current_syntax')
  finish
endif 

let s:cpo_save = &cpo
set cpo&vim

syn iskeyword @,48-57,_,.

syn case match

" Strings
syn region routString start=/"/ skip=/\\\\\|\\"/ end=/"/ end=/$/

" Constants
syn keyword rConstant NULL
syn keyword rBoolean FALSE TRUE
syn keyword rNumber NA Inf NaN 

" Integer
syn match rInteger /\<\d\+L/
syn match rInteger /\<0x\([0-9]\|[a-f]\|[A-F]\)\+L/
syn match rInteger /\<\d\+[Ee]+\=\d\+L/

" Number with no fractional part or exponent
syn match rNumber /\<\d\+\>/
" Hexadecimal number 
syn match rNumber /\<0x\([0-9]\|[a-f]\|[A-F]\)\+/

" Floating point number with integer and fractional parts and optional exponent
syn match rFloat /\<\d\+\.\d*\([Ee][-+]\=\d\+\)\=/
" Floating point number with no integer part and optional exponent
syn match rFloat /\<\.\d\+\([Ee][-+]\=\d\+\)\=/
" Floating point number with no fractional part and optional exponent
syn match rFloat /\<\d\+[Ee][-+]\=\d\+/

" Complex number
syn match rComplex /\<\d\+i/
syn match rComplex /\<\d\++\d\+i/
syn match rComplex /\<0x\([0-9]\|[a-f]\|[A-F]\)\+i/
syn match rComplex /\<\d\+\.\d*\([Ee][-+]\=\d\+\)\=i/
syn match rComplex /\<\.\d\+\([Ee][-+]\=\d\+\)\=i/
syn match rComplex /\<\d\+[Ee][-+]\=\d\+i/

if !exists('g:vimrplugin_routmorecolors')
  let g:vimrplugin_routmorecolors = 0
endif

if g:vimrplugin_routmorecolors == 1
  syn include @routR syntax/r.vim
  syn region routColoredR start=/^> / end=/$/ contains=@routR keepend
  syn region routColoredR start=/^+ / end=/$/ contains=@routR keepend
else
  " Comment
  syn match routComment /^> .*/
  syn match routComment /^+ .*/
endif

" Index of vectors
syn match routIndex /^\s*\[\d\+\]/

" Errors and warnings
syn match routError /^Error.*/
syn match routWarn /^Warning.*/

" Define the default highlighting
if g:vimrplugin_routmorecolors == 0
  hi def link routComment Comment
endif
hi def link rNumber Number
hi def link rComplex Number
hi def link rInteger Number
hi def link rBoolean Boolean
hi def link rConstant Constant
hi def link rFloat Float
hi def link routString String
hi def link routError Error
hi def link routWarn WarningMsg
hi def link routIndex Special

let b:current_syntax = 'rout'

let &cpo = s:cpo_save
unlet s:cpo_save
