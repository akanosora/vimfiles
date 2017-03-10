" Internal function
fu! s:ColorExpand(fg, bg)
  let fg256 = (len(a:fg) > 0 && &t_Co == 256 ? color#HexToShort(a:fg) : '')
  let bg256 = (len(a:bg) > 0 && &t_Co == 256 ? color#HexToShort(a:bg) : '')
  return [a:fg, a:bg, fg256, bg256]
endf

" Palette
let s:pink     = '#b05279'
let s:orange   = '#e87d3e'
let s:yellow   = '#e5b567'
let s:green    = '#b4c973'
let s:cyan     = '#6c99bb'
let s:lavender = '#9e86c8'
let s:ash      = '#6a717c'

" First, let's define an empty dictionary and assign it to the "palette"
" variable. The # is a separator that maps with the directory structure. If
" you get this wrong, Vim will complain loudly.
let g:airline#themes#afterglow#palette = {}

" Normal mode
" First let's define some arrays. The s: is just a VimL thing for scoping the
" variables to the current script. Without this, these variables would be
" declared globally. Now let's declare some colors for normal mode and add it
" to the dictionary. The array is in the format:
" [ guifg, guibg, ctermfg, ctermbg, opts ]. See "help attr-list" for valid
" values for the "opt" value.
let s:N1 = s:ColorExpand('#181b20', s:cyan   ) " Mode
let s:N2 = s:ColorExpand('#d1d5dc', '#4b5362') " Info
let s:N3 = s:ColorExpand('#d1d5dc', '#21252b') " Statusline

let g:airline#themes#afterglow#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#afterglow#palette.normal_modified = {
      \ 'airline_c': s:ColorExpand(s:cyan, '#21252b'),
      \ }

" Insert mode
let s:I1 = s:ColorExpand('#181b20', s:green  )
let s:I2 = s:ColorExpand('#d1d5dc', '#4b5362')
let s:I3 = s:ColorExpand('#d1d5dc', '#21252b')

let g:airline#themes#afterglow#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#afterglow#palette.insert_modified = {
      \ 'airline_c': s:ColorExpand(s:green, '#21252b'),
      \ }

" Replace mode
let g:airline#themes#afterglow#palette.replace = copy(g:airline#themes#afterglow#palette.insert)
let g:airline#themes#afterglow#palette.replace.airline_a = s:ColorExpand(s:I1[0], s:pink)
let g:airline#themes#afterglow#palette.replace_modified = {
      \ 'airline_c': s:ColorExpand(s:pink, '#21252b'),
      \ }

" Visual mode
let s:V1 = s:ColorExpand('#181b20', s:orange )
let s:V2 = s:ColorExpand('#d1d5dc', '#4b5362')
let s:V3 = s:ColorExpand('#d1d5dc', '#21252b')

let g:airline#themes#afterglow#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#afterglow#palette.visual_modified = {
      \ 'airline_c': s:ColorExpand(s:orange, '#21252b'),
      \ }

" Inactive
let s:IA = s:ColorExpand('#181b20', '#4b5362')
let g:airline#themes#afterglow#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
let g:airline#themes#afterglow#palette.inactive_modified = {
      \ 'airline_c': s:ColorExpand('#d1d5dc', ''),
      \ }

" Accents are used to give parts within a section a slightly different look or
" color. Here we are defining a "red" accent, which is used by the 'readonly'
" part by default. Only the foreground colors are specified, so the background
" colors are automatically extracted from the underlying section colors. What
" this means is that regardless of which section the part is defined in, it
" will be red instead of the section's foreground color. You can also have
" multiple parts with accents within a section.
let g:airline#themes#afterglow#palette.accents = {
      \ 'red': s:ColorExpand(s:pink, ''),
      \ }

" CtrlP
" Here we define the color map for ctrlp. We check for the g:loaded_ctrlp
" variable so that related functionality is loaded iff the user is using
" ctrlp. Note that this is optional, and if you do not define ctrlp colors
" they will be chosen automatically from the existing palette.
if !get(g:, 'loaded_ctrlp', 0)
  finish
endif
let g:airline#themes#afterglow#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
      \ s:ColorExpand('#d1d5dc', '#4b5362'),
      \ s:ColorExpand('#d1d5dc', '#21252b'),
      \ s:ColorExpand('#181b20', s:lavender) + ['bold'])
