"=============================================================================
" Copyright (c) 2007-2009 Takeshi NISHIDA
" Copyright (c) 2016-2017 Zhen-Huan Hu
"
"=============================================================================
" LOAD GUARD {{{1

if exists('g:loaded_autoload_acp') || v:version < 800
  finish
endif
let g:loaded_autoload_acp = 1

" }}}1
"=============================================================================
" GLOBAL FUNCTIONS: {{{1

" Enable auto-popup
function acp#Enable()
  inoremap <Plug>AcpFeedPopup <C-r>=<SID>FeedPopup()<CR>
  augroup AcpGlobalAutoCommand
    autocmd!
    autocmd InsertEnter  * call s:ResetLastCursorPosition()
    autocmd TextChangedI * call s:InitPopup()
    autocmd CompleteDone * call s:ResetLastCursorPosition()
    autocmd InsertLeave  * call s:FinishPopup(1)
  augroup END
endfunction

" Disable auto-popup
function acp#Disable()
  iunmap <Plug>AcpFeedPopup
  augroup AcpGlobalAutoCommand
    autocmd!
  augroup END
endfunction

" Suspend auto-popup
function acp#Lock()
  let s:lock_count = exists(s:lock_count) ?
        \ s:lock_count + 1 : 1
endfunction

" Release auto-popup from suspension
function acp#Unlock()
  let s:lock_count = exists(s:lock_count) ?
        \ s:lock_count - 1 :
        \ throw "AutoComplPop: Not locked"
  if s:lock_count < 1
    unlet s:lock_count
  endif
endfunction

" }}}1
"=============================================================================
" LOCAL FUNCTIONS: {{{1

"
function s:MakeSnipmateItem(key, snip)
  if type(a:snip) == type([])
    let descriptions = map(copy(a:snip), 'v:val[0]')
    let formatted_snip = '[MULTI] ' . join(descriptions, ', ')
  else
    let formatted_snip = substitute(a:snip, '\(\n\|\s\)\+', ' ', 'g')
  endif
  return {
        \ 'word': a:key,
        \ 'menu': strpart(formatted_snip, 0, 80),
        \ }
endfunction

"
function s:GetMatchingSnipItems(base)
  let key = a:base . "\n"
  if !exists('s:snip_items[key]')
    let s:snip_items[key] = items(GetSnipsInCurrentScope())
    call filter(s:snip_items[key], 'strpart(v:val[0], 0, len(a:base)) ==? a:base')
    call map(s:snip_items[key], 's:MakeSnipmateItem(v:val[0], v:val[1])')
  endif
  return s:snip_items[key]
endfunction

" Default completion function for snipMate
function s:CompleteFuncForSnipmate(findstart, base)
  if a:findstart
    let s:snip_completion_pos = len(matchstr(s:GetCurrentText(), '.*\U'))
    return s:snip_completion_pos
  endif
  let base_len = len(a:base)
  let items = filter(GetSnipsInCurrentScope(),
        \            'strpart(v:key, 0, base_len) ==? a:base')
  return map(sort(items(items)), 's:MakeSnipmateItem(v:val[0], v:val[1])')
endfunction

" Default close function for snipMate
function s:CloseFuncForSnipmate()
  let word = s:GetCurrentText()[s:snip_completion_pos :]
  for trigger in keys(GetSnipsInCurrentScope())
    if word ==# trigger
      call feedkeys("\<C-r>=TriggerSnippet()\<CR>", "n")
      return 1
    endif
  endfor
  return 0
endfunction

" Default 'meets' function for snipMate
" to determine whether to attempt a completion
function s:MeetsForSnipmate(context, ...)
  if g:acp_snipmate_length < 0
    return 0
  endif
  let matches = matchlist(a:context, '\(^\|\s\|\<\)\(\u\{' .
        \                            g:acp_snipmate_length . ',}\)$')
  return !empty(matches) && !empty(s:GetMatchingSnipItems(matches[2]))
endfunction

" Default 'meets' function for anything that is a keyword
" to determine whether to attempt a completion
function s:MeetsForKeyword(context, ...)
  if g:acp_keyword_length < 0
    return 0
  endif
  let matches = matchlist(a:context, '\k\{' . g:acp_keyword_length . ',}$')
  if empty(matches)
    return 0
  endif
  for ignore in g:acp_keyword_ignored
    if stridx(ignore, matches[1]) == 0
      " Do not attempt completion
      " if the start of a match occurs in 'ignore'
      return 0
    endif
  endfor
  return 1
endfunction

" Default 'meets' function for file names
" to determine whether to attempt a completion
function s:MeetsForFile(context, ...)
  if g:acp_file_length < 0
    return 0
  endif
  let separator = (has('win32') || has('win64')) ? '[/\\]' : '\/'
  if a:0 > 0 ?
        \ a:context !~ '\f' . separator . '\f\{' . a:1 . '}$' :
        \ a:context !~ '\f' . separator . '\f\{' . g:acp_file_length . ',}$'
    return 0
  endif
  return a:context !~ '[*/\\][/\\]\f*$\|[^[:print:]]\f*$'
endfunction

" Default 'meets' function for VimScript
" to determine whether to attempt a completion
function s:MeetsForVimScript(context, ...)
  return g:acp_vimscript_length >= 0 &&
        \ a:context =~ '\k\{' . g:acp_vimscript_length . ',}$'
endfunction

" Default 'meets' function for Ruby
" to determine whether to attempt a completion
function s:MeetsForRubyOmni(context, ...)
  return has('ruby') &&
        \ (g:acp_ruby_omni_method_length >= 0 &&
        \ a:context =~ '\k\(\.\|::\)\k\{' . g:acp_ruby_omni_method_length . ',}$') ||
        \ (g:acp_ruby_omni_symbol_length >= 0 &&
        \ a:context =~ '\(^\|[^:]\):\k\{' . g:acp_ruby_omni_symbol_length . ',}$')
endfunction

" Default 'meets' function for Python
" to determine whether to attempt a completion
function s:MeetsForPythonOmni(context, ...)
  return has('python') && g:acp_python_omni_length >= 0 &&
        \ a:0 > 0 ?
        \ a:context =~ '\k\.\k\{' . a:1 . '}$' :
        \ a:context =~ '\k\.\k\{' . g:acp_python_omni_length . ',}$'
endfunction

" Default 'meets' function for Perl
" to determine whether to attempt a completion
function s:MeetsForPerlOmni(context, ...)
  return has('perl') && g:acp_perl_omni_length >= 0 &&
        \ a:context =~ '\w->\k\{' . g:acp_perl_omni_length . ',}$'
endfunction

" Default 'meets' function for Xml
" to determine whether to attempt a completion
function s:MeetsForXmlOmni(context, ...)
  return g:acp_xml_omni_length >= 0 &&
        \ a:context =~ '<\(\/\=\|[^>]\+ \)\k\{' . g:acp_xml_omni_length . ',}$'
endfunction

" Default 'meets' function for Html
" to determine whether to attempt a completion
function s:MeetsForHtmlOmni(context, ...)
  return g:acp_html_omni_length >= 0 &&
        \ a:context =~ '<\(\/\=\|[^>]\+ \)\k\{' . g:acp_html_omni_length . ',}$'
endfunction

" Default 'meets' function for Css
" to determine whether to attempt a completion
function s:MeetsForCssOmni(context, ...)
  return (g:acp_css_omni_property_length >= 0 &&
        \ a:context =~ '\(^\|[;{]\)\s*\k\{' . g:acp_css_omni_property_length . ',}$') ||
        \ (g:acp_css_omni_value_length >= 0 &&
        \ a:context =~ '[:@!]\s*\k\{' . g:acp_css_omni_value_length . ',}$')
endfunction

" Default 'meets' function for JavaScript
" to determine whether to attempt a completion
function s:MeetsForJavaScriptOmni(context, ...)
  return g:acp_javascript_omni_length >= 0 &&
        \ a:context =~ '\k\.\k\{' . g:acp_javascript_omni_length . ',}$'
endfunction

" Default 'meets' function for Php
" to determine whether to attempt a completion
function s:MeetsForPhpOmni(context, ...)
  return g:acp_php_omni_length >= 0 &&
        \ a:context =~ '\w\(->\|::\)\k\{' . g:acp_php_omni_length . ',}$'
endfunction

" Default 'meets' function for SAS
" to determine whether to attempt a completion
function s:MeetsForSASOmni(context, ...)
  return g:acp_sas_omni_length >= 0 &&
        \ a:context =~ '\<proc\s\+\k\{' . g:acp_sas_omni_length . ',}$'
endfunction

" Set variable with temporary value
function s:SetTempOption(group, name, value)
  if !exists('s:orig_map[a:group]')
    let s:orig_map[a:group] = {}
  endif
  if !exists('s:orig_map[a:group][a:name]')
    let s:orig_map[a:group][a:name] = eval(a:name)
  endif
  execute 'let' a:name '= a:value'
endfunction

" Restore original value to variable and clean up
function s:RestoreTempOptions(group)
  if !exists('s:orig_map[a:group]')
    return
  endif
  for [name, value] in items(s:orig_map[a:group])
    execute 'let' name '= value'
    unlet value " to avoid E706
  endfor
  unlet s:orig_map[a:group]
endfunction

" Retrieve contents at current line before cursor
function s:GetCurrentText()
  return strpart(getline('.'), 0, col('.') - 1)
endfunction

" Retrieve current word at cursor
" At a non-keyword character, return empty string
function s:GetCurrentWord()
  return matchstr(s:GetCurrentText(), '\k*$')
endfunction

" Reset the last cursor position
function s:ResetLastCursorPosition()
  let s:pos_last = getpos('.')
endfunction

" Check if the cursor only moved a single position
function s:CursorMovedSinglePosition()
  if exists('s:pos_last')
    let pos_prev = s:pos_last
  endif
  call s:ResetLastCursorPosition()
  return pos_prev[1] ==# s:pos_last[1] &&
        \ abs(pos_prev[2] - s:pos_last[2]) == 1
endfunction

" Make current behavior set s:current_behavs
" Return 1 if a new behavior set is created, 0 if otherwise
function s:MakeCurrentBehaviorSet()
  if exists('s:current_behavs[s:behav_idx].closefunc')
        \ && call(s:current_behavs[s:behav_idx].closefunc, [])
    call s:ClearCurrentBehaviorSet()
    return 0
  endif
  if exists('s:current_behavs[s:behav_idx].repeat')
        \ && s:current_behavs[s:behav_idx].repeat
        \ && call(s:current_behavs[s:behav_idx].meets, [s:GetCurrentText(), '0'])
    let s:current_behavs = [ s:current_behavs[s:behav_idx] ]
  elseif s:CursorMovedSinglePosition()
    let s:current_behavs = copy(exists('g:acp_behavior[&filetype]')
          \ ? g:acp_behavior[&filetype]
          \ : g:acp_behavior['*'])
  else
    call s:ClearCurrentBehaviorSet()
    return 0
  endif
  let text = s:GetCurrentText()
  call filter(s:current_behavs, 'call(v:val.meets, [text])')
  " Improve responsiveness by not to attempt another completion
  " after the last attempt failed to find any completion candidate
  if exists('s:last_uncompletable')
    if stridx(s:GetCurrentWord(), s:last_uncompletable.word) == 0 &&
          \ map(copy(s:current_behavs), 'v:val.command') ==# s:last_uncompletable.commands
      call s:ClearCurrentBehaviorSet()
      return 0
    else
      unlet! s:last_uncompletable
    endif
  endif
  if empty(s:current_behavs) 
    call s:ClearCurrentBehaviorSet()
    return 0
  endif
  let s:behav_idx = -1
  return 1
endfunction

" Clear current behavior set s:current_behavs
function s:ClearCurrentBehaviorSet()
  let s:current_behavs = []
endfunction

" Initialize
function s:InitPopup()
  if (exists(s:lock_count) && s:lock_count > 0) || &paste
    return
  endif
  if s:MakeCurrentBehaviorSet()
    call s:SetTempOption(s:L_0, '&complete', g:acp_set_complete)
    call s:SetTempOption(s:L_0, '&completeopt',
          \ (g:acp_set_completeopt_preview  ? 'preview,'  : '') .
          \ (g:acp_set_completeopt_noselect ? 'noselect,' : '') .
          \ 'menuone,noinsert'
          \ )
    call s:SetTempOption(s:L_0, '&ignorecase', g:acp_set_ignorecase)
    call s:SetTempOption(s:L_0, '&lazyredraw', 1)
    call s:SetTempOption(s:L_0, '&spell', 0)
    call s:SetTempOption(s:L_1, '&textwidth', 0)
    call s:FeedPopup()
    return
  else
    call s:FinishPopup(1)
    return
  endif
endfunction

" Feed keys to trigger popup menu
" Keep it as a local function to avoid users accidentally calling it directly
function s:FeedPopup()
  if empty(s:current_behavs)
    return ''
  endif
  if pumvisible()
    return ''
  endif
  if s:behav_idx < len(s:current_behavs) - 1
    let s:behav_idx += 1
    " Need to update &completefunc each time before a new behavior is tried
    call s:SetTempOption(s:L_0, '&completefunc',
          \ exists('s:current_behavs[s:behav_idx].completefunc') ?
          \ s:current_behavs[s:behav_idx].completefunc :
          \ eval('&completefunc'))
    call feedkeys(s:current_behavs[s:behav_idx].command, 'n')
    call feedkeys("\<Plug>AcpFeedPopup")
    return ''
  endif
  " After all attempts have failed
  let s:last_uncompletable = {
        \ 'word': s:GetCurrentWord(),
        \ 'commands': map(copy(s:current_behavs), 'v:val.command')[1:],
        \ }
  call s:FinishPopup(0)
  return ''
endfunction

" Finish up
function s:FinishPopup(level) 
  if a:level >= 0
    call s:ClearCurrentBehaviorSet()
    call s:RestoreTempOptions(s:L_0)
  endif
  if a:level >= 1
    call s:RestoreTempOptions(s:L_1)
  endif
endfunction

" }}}1
"=============================================================================
" INITIALIZATION {{{1

"-----------------------------------------------------------------------------
let s:L_0 = 0
let s:L_1 = 1
"-----------------------------------------------------------------------------
let s:current_behavs = []
let s:behav_idx = 0
let s:orig_map = {}
let s:snip_items = {}

" }}}1
"=============================================================================
" vim: set fdm=marker:
