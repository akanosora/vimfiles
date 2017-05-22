" Filename: autoload/lightline/colorscheme/afterglow.vim
" Author: Zhen-Huan Hu <wildkeny@gmail.com>
" License: MIT License
" Last Change: May 19, 2017

" Internal function
fu! s:ColorExpand(color)
  let color256 = color#HexToShort(a:color)
  return [a:color, color256]
endf

" Palette
let s:black     = s:ColorExpand('#21252b')
let s:gray      = s:ColorExpand('#4b5362')
let s:white     = s:ColorExpand('#d1d5dc')
let s:cyan      = s:ColorExpand('#6c99bb')
let s:green     = s:ColorExpand('#b4c973')
let s:orange    = s:ColorExpand('#e87d3e')
let s:lavender  = s:ColorExpand('#9e86c8')
let s:pink      = s:ColorExpand('#b05279')
let s:yellow    = s:ColorExpand('#e5b567')

let s:p = {
      \ 'normal': {},
      \ 'inactive': {},
      \ 'insert': {},
      \ 'replace': {},
      \ 'visual': {},
      \ 'tabline': {}
      \ }
let s:p.normal = {
      \ 'left': [ [ s:black, s:cyan ], [ s:cyan, s:black ] ],
      \ 'middle': [ [ s:white, s:black ] ],
      \ 'right': [ [ s:white, s:gray ], [ s:gray, s:white ] ],
      \ 'error': [ [ s:lavender, s:black ] ],
      \ 'warning': [ [ s:yellow, s:black ] ]
      \ }
let s:p.insert = {
      \ 'left': [ [ s:black, s:green ], [ s:green, s:black ] ]
      \ }
let s:p.visual = {
      \ 'left': [ [ s:black, s:yellow ], [ s:yellow, s:black ] ]
      \ }
let s:p.replace = {
      \ 'left': [ [ s:black, s:pink ], [ s:pink, s:black ] ]
      \ }
let s:p.inactive = {
      \ 'left': [ [ s:gray, s:white ], [ s:white, s:gray ] ],
      \ 'middle': [ [ s:white, s:black ] ],
      \ 'right': [ [ s:white, s:gray ], [ s:gray, s:white ] ]
      \ }
let s:p.tabline = {
      \ 'left': [ [ s:lavender, s:black ] ],
      \ 'middle': [ [ s:white, s:black ] ],
      \ 'right': [ [ s:white, s:gray ], [ s:gray, s:white ] ],
      \ 'tabsel': [ [ s:black, s:lavender ] ]
      \ }

let g:lightline#colorscheme#afterglow#palette = lightline#colorscheme#flatten(s:p)
