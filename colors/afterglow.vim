" Author: Zhenhuan Hu <zhu@mcw.edu>
" Date: 2017-02-01
" License: GPL
" Note: Based on Danilo Augusto's Afterglow theme

" Initialization {{{
if version > 580
  hi clear
  if exists("syntax_on")
    syntax reset
  endif
endif

let g:colors_name="afterglow"

if !has('gui_running') && &t_Co != 256
  finish
endif

let s:bgsetting = &background
" }}}

" Functions {{{
let s:palette_mapping_cache = {}

fu! s:SetColor(name, fg, bg, ...)
  if type(a:fg) == 1 && !has_key(s:palette_mapping_cache, a:fg)
    let s:palette_mapping_cache[a:fg] = (&t_Co == 256 ?
          \ color#HexToShort(a:fg) : '')
  endif
  if type(a:bg) == 1 && !has_key(s:palette_mapping_cache, a:bg)
    let s:palette_mapping_cache[a:bg] = (&t_Co == 256 ?
          \ color#HexToShort(a:bg) : '')
  endif
  let fg = (type(a:fg) == 3 ? a:fg : [a:fg, s:palette_mapping_cache[a:fg]])
  let bg = (type(a:bg) == 3 ? a:bg : [a:bg, s:palette_mapping_cache[a:bg]])
  execute "hi" a:name
        \ "guifg=" . fg[0]
        \ "guibg=" . bg[0]
        \ "gui=" . (a:0 > 0 ? a:1 : "NONE")
  if &t_Co == 256
    execute "hi" a:name
          \ "ctermfg=" . fg[1]
          \ "ctermbg=" . bg[1]
  endif
endf

fu! s:SetFgColor(name, fg, ...)
  if type(a:fg) == 1 && !has_key(s:palette_mapping_cache, a:fg)
    let s:palette_mapping_cache[a:fg] = (&t_Co == 256 ?
          \ color#HexToShort(a:fg) : '')
  endif
  let fg = (type(a:fg) == 3 ? a:fg : [a:fg, s:palette_mapping_cache[a:fg]])
  execute "hi" a:name
        \ "guifg=" . fg[0]
        \ "gui=" . (a:0 > 0 ? a:1 : "NONE")
  if &t_Co == 256
    execute "hi" a:name
          \ "ctermfg=" . fg[1]
  endif
endf

fu! s:SetBgColor(name, bg, ...)
  if type(a:bg) == 1 && !has_key(s:palette_mapping_cache, a:bg)
    let s:palette_mapping_cache[a:bg] = (&t_Co == 256 ?
          \ color#HexToShort(a:bg) : '')
  endif
  let bg = (type(a:bg) == 3 ? a:bg : [a:bg, s:palette_mapping_cache[a:bg]])
  execute "hi" a:name
        \ "guibg=" . bg[0]
        \ "gui=" . (a:0 > 0 ? a:1 : "NONE")
  if &t_Co == 256
    execute "hi" a:name
          \ "ctermbg=" . bg[1]
  endif
endf

fu! s:SetSpColor(name, sp)
  if type(a:sp) == 1 && !has_key(s:palette_mapping_cache, a:sp)
    let s:palette_mapping_cache[a:sp] = (&t_Co == 256 ?
          \ color#HexToShort(a:sp) : '')
  endif
  let sp = (type(a:sp) == 3 ? a:sp : [a:sp, s:palette_mapping_cache[a:sp]])
  execute "hi" a:name
        \ "guisp=" . sp[0]
        \ "gui=undercurl"
  if &t_Co == 256
    execute "hi" a:name
          \ "ctermfg=bg"
          \ "ctermbg=" . sp[1]
  endif
endf
" }}}

" Palette
let s:uih = 220 " Hue
let s:uis = 13  " Saturation
let s:uil = {'dark': 18, 'light': 66} " Lightness

let s:lt = color#HSLtoHex(s:uih, s:uis, s:uil.light) " #9da5b4
let s:dk = color#HSLtoHex(s:uih, s:uis, s:uil.dark ) " #282c34

" s:ltpalette = ['#d1d5dc', '#abb2bf', '#9da5b4', '#6a768a', '#4b5362']
let s:ltpalette = [
      \ color#Lighten(s:lt, 28),
      \ color#Lighten(s:lt, 8 ),
      \ s:lt,
      \ color#Darken( s:lt, 28),
      \ color#Darken( s:lt, 48),
      \ ]
" s:dkpalette = ['#3c424e', '#333842', '#282c34', '#21252b', '#181b20']
let s:dkpalette = [
      \ color#Lighten(s:dk, 48),
      \ color#Lighten(s:dk, 28),
      \ s:dk,
      \ color#Darken( s:dk, 16),
      \ color#Darken( s:dk, 40),
      \ ]

if s:bgsetting ==# 'dark'
  let s:fgpalette = s:ltpalette
  let s:bgpalette = s:dkpalette
else
  let s:fgpalette = s:dkpalette
  let s:bgpalette = s:ltpalette
end

let s:pink     = '#b05279'
let s:orange   = '#e87d3e'
let s:yellow   = '#e5b567'
let s:green    = '#b4c973'
let s:cyan     = '#6c99bb'
let s:lavender = '#9e86c8'
let s:ash      = '#6a717c'

let s:bgpink   = color#HSLtoHex(color#HexToHSL(s:pink  )[0], s:uis, s:uil.dark)
let s:bgorange = color#HSLtoHex(color#HexToHSL(s:orange)[0], s:uis, s:uil.dark)
let s:bgyellow = color#HSLtoHex(color#HexToHSL(s:yellow)[0], s:uis, s:uil.dark)
let s:bggreen  = color#HSLtoHex(color#HexToHSL(s:green )[0], s:uis, s:uil.dark)

call s:SetColor("Normal", s:fgpalette[0], s:bgpalette[2])
call s:SetColor("Cursor", s:bgpalette[4], s:fgpalette[0])
call s:SetBgColor("CursorLine", s:bgpalette[1])
call s:SetBgColor("CursorColumn", s:bgpalette[1])
call s:SetBgColor("Visual", s:bgpalette[0])
call s:SetBgColor("VisualNOS", s:bgpalette[0])
call s:SetBgColor("ColorColumn", s:bgpalette[3])
call s:SetColor("SignColumn", s:green, s:bgpalette[3])
call s:SetColor("LineNr", s:fgpalette[4], s:bgpalette[3])
call s:SetFgColor("CursorLineNr", s:pink)
call s:SetColor("VertSplit", s:fgpalette[4], s:bgpalette[3])
call s:SetColor("FoldColumn", s:pink, s:bgpalette[3])
call s:SetColor("Folded", s:fgpalette[2], s:bgpalette[4])
call s:SetColor("Conceal", s:fgpalette[2], s:bgpalette[4])
call s:SetColor("MatchParen", s:bgpalette[4], s:orange, "bold")
call s:SetColor("Pmenu", s:bgpalette[4], s:fgpalette[2])
call s:SetColor("PmenuSel", s:bgpalette[4], s:cyan)
call s:SetBgColor("PmenuSbar", s:bgpalette[3])
call s:SetFgColor("PmenuThumb", s:cyan)
call s:SetColor("TabLine", s:fgpalette[2], s:bgpalette[4])
call s:SetColor("TabLineFill", s:bgpalette[4], s:bgpalette[4])
call s:SetColor("TabLineSel", s:bgpalette[4], s:fgpalette[2])
call s:SetColor("StatusLine", s:bgpalette[4], s:fgpalette[2])
call s:SetColor("StatusLineNC", s:fgpalette[2], s:bgpalette[4])
call s:SetColor("WildMenu", s:bgpalette[4], s:cyan)
call s:SetColor("IncSearch", s:bgpalette[4], s:cyan)
call s:SetColor("Search", s:bgpalette[4], s:orange)
call s:SetFgColor("NonText", s:fgpalette[4])
call s:SetFgColor("SpecialKey", s:fgpalette[4], "italic")
call s:SetFgColor("Title", s:green, "underline")
call s:SetFgColor("Directory", s:green, "bold")
call s:SetFgColor("Question", s:cyan, "bold")
call s:SetColor("ErrorMsg", s:pink, s:bgpalette[2], "bold")
call s:SetFgColor("ModeMsg", s:yellow, "bold")
call s:SetFgColor("MoreMsg", s:yellow, "bold")
call s:SetColor("WarningMsg", s:orange, s:bgpalette[2], "bold")
call s:SetColor("DiffAdd", s:fgpalette[2], s:bggreen)
call s:SetColor("DiffDelete", s:fgpalette[2], s:bgpink)
call s:SetColor("DiffChange", s:fgpalette[2], s:bgyellow)
call s:SetColor("DiffText", s:orange, s:bgyellow)

if has("spell")
  call s:SetSpColor("SpellBad", s:pink)
  call s:SetSpColor("SpellCap", s:lavender)
  call s:SetSpColor("SpellLocal", s:lavender)
  call s:SetSpColor("SpellRare", s:fgpalette[0])
endif

" Comment
call s:SetFgColor("Comment", s:ash, "italic")
" Constant
call s:SetFgColor("Constant", s:lavender)
call s:SetFgColor("String", s:yellow)
call s:SetFgColor("Character", s:yellow)
call s:SetFgColor("Number", s:lavender)
call s:SetFgColor("Boolean", s:lavender)
call s:SetFgColor("Float", s:lavender)
" Identifier
call s:SetFgColor("Identifier", s:orange)
call s:SetFgColor("Function", s:green)
" Statement
call s:SetFgColor("Statement", s:green, 'bold')
call s:SetFgColor("Keyword", s:pink, "bold")
call s:SetFgColor("Conditional", s:pink, "bold")
call s:SetFgColor("Repeat", s:pink, "bold")
call s:SetFgColor("Exception", s:pink, "bold")
call s:SetFgColor("Label", s:pink, "italic")
call s:SetFgColor("Operator", s:pink)
" Preprocessor
call s:SetFgColor("PreProc", s:cyan, "bold")
call s:SetFgColor("Define", s:cyan, "italic")
call s:SetFgColor("Include", s:cyan, "italic")
call s:SetFgColor("Macro", s:cyan, "italic")
call s:SetFgColor("PreCondit", s:cyan, "italic")
" Type
call s:SetFgColor("Type", s:orange, "italic")
call s:SetFgColor("StorageClass", s:orange, "italic")
call s:SetFgColor("Structure", s:orange, "italic")
call s:SetFgColor("Typedef", s:orange, "italic")
" Special
call s:SetFgColor("Special", s:lavender, "italic")
call s:SetFgColor("SpecialChar", s:lavender, "italic")
call s:SetFgColor("Delimiter", s:orange, "italic")
call s:SetFgColor("Tag", s:pink, "italic")
call s:SetFgColor("SpecialComment", s:ash, "italic,undercurl")
call s:SetFgColor("Debug", s:green, "italic")
" Other
call s:SetColor("Error", s:pink, s:bgpalette[2], "undercurl")
call s:SetFgColor("Ignore", s:bgpalette[2])
call s:SetFgColor("Todo", s:ash, "bold,italic")
call s:SetColor("Underlined", s:fgpalette[0], s:bgpalette[2], "underline")

" Must be at the end, because of ctermbg=234 bug.
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
let &background = s:bgsetting

" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fdl=0:
