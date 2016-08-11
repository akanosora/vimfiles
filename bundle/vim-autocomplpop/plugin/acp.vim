"=============================================================================
" Copyright (c) 2007-2009 Takeshi NISHIDA
"
" GetLatestVimScripts: 1879 1 :AutoInstall: AutoComplPop
"=============================================================================
" LOAD GUARD {{{1

if exists('g:loaded_acp')
  finish
elseif v:version < 702
  echoerr 'AutoComplPop does not support this version of vim (' . v:version . ').'
  finish
endif
let g:loaded_acp = 1

" }}}1
"=============================================================================
" FUNCTION: {{{1

"
function s:defineVariableDefault(name, default)
  if !exists(a:name)
    let {a:name} = a:default
  endif
endfunction

"
function s:makeDefaultBehavior()
  let behavs = {
        \   '*'      : [],
        \   'ruby'   : [],
        \   'python' : [],
        \   'perl'   : [],
        \   'xml'    : [],
        \   'html'   : [],
        \   'xhtml'  : [],
        \   'css'    : [],
        \ }
  "---------------------------------------------------------------------------
  if !empty(g:acp_behaviorUserDefinedFunction) &&
        \ !empty(g:acp_behaviorUserDefinedMeets)
    for key in keys(behavs)
      call add(behavs[key], {
            \   'command'      : "\<C-x>\<C-u>",
            \   'completefunc' : g:acp_behaviorUserDefinedFunction,
            \   'meets'        : g:acp_behaviorUserDefinedMeets,
            \   'repeat'       : 0,
            \ })
    endfor
  endif
  "---------------------------------------------------------------------------
  for key in keys(behavs)
    call add(behavs[key], {
          \   'command'      : "\<C-x>\<C-u>",
          \   'completefunc' : 's:completeSnipmate',
          \   'meets'        : 's:meetsForSnipmate',
          \   'onPopupClose' : 's:onPopupCloseSnipmate',
          \   'repeat'       : 0,
          \ })
  endfor
  "---------------------------------------------------------------------------
  for key in keys(behavs)
    call add(behavs[key], {
          \   'command' : g:acp_behaviorKeywordCommand,
          \   'meets'   : 's:meetsForKeyword',
          \   'repeat'  : 0,
          \ })
  endfor
  "---------------------------------------------------------------------------
  for key in keys(behavs)
    call add(behavs[key], {
          \   'command' : "\<C-x>\<C-f>",
          \   'meets'   : 's:meetsForFile',
          \   'repeat'  : 1,
          \ })
  endfor
  "---------------------------------------------------------------------------
  call add(behavs.ruby, {
        \   'command' : "\<C-x>\<C-o>",
        \   'meets'   : 's:meetsForRubyOmni',
        \   'repeat'  : 0,
        \ })
  "---------------------------------------------------------------------------
  call add(behavs.python, {
        \   'command' : "\<C-x>\<C-o>",
        \   'meets'   : 's:meetsForPythonOmni',
        \   'repeat'  : 0,
        \ })
  "---------------------------------------------------------------------------
  call add(behavs.perl, {
        \   'command' : "\<C-x>\<C-o>",
        \   'meets'   : 's:meetsForPerlOmni',
        \   'repeat'  : 0,
        \ })
  "---------------------------------------------------------------------------
  call add(behavs.xml, {
        \   'command' : "\<C-x>\<C-o>",
        \   'meets'   : 's:meetsForXmlOmni',
        \   'repeat'  : 1,
        \ })
  "---------------------------------------------------------------------------
  call add(behavs.html, {
        \   'command' : "\<C-x>\<C-o>",
        \   'meets'   : 's:meetsForHtmlOmni',
        \   'repeat'  : 1,
        \ })
  "---------------------------------------------------------------------------
  call add(behavs.xhtml, {
        \   'command' : "\<C-x>\<C-o>",
        \   'meets'   : 's:meetsForHtmlOmni',
        \   'repeat'  : 1,
        \ })
  "---------------------------------------------------------------------------
  call add(behavs.css, {
        \   'command' : "\<C-x>\<C-o>",
        \   'meets'   : 's:meetsForCssOmni',
        \   'repeat'  : 0,
        \ })
  "---------------------------------------------------------------------------
  return behavs
endfunction

" }}}1
"=============================================================================
" INITIALIZATION {{{1

"-----------------------------------------------------------------------------
call s:defineVariableDefault('g:acp_enableAtStartup', 1)
call s:defineVariableDefault('g:acp_mappingDriven', 0)
call s:defineVariableDefault('g:acp_ignorecaseOption', 1)
call s:defineVariableDefault('g:acp_completeOption', '.,w,b,k')
call s:defineVariableDefault('g:acp_completeoptPreview', 0)
call s:defineVariableDefault('g:acp_behaviorUserDefinedFunction', '')
call s:defineVariableDefault('g:acp_behaviorUserDefinedMeets', '')
call s:defineVariableDefault('g:acp_behaviorSnipmateLength', -1)
call s:defineVariableDefault('g:acp_behaviorKeywordCommand', "\<C-n>")
call s:defineVariableDefault('g:acp_behaviorKeywordLength', 2)
call s:defineVariableDefault('g:acp_behaviorKeywordIgnores', [])
call s:defineVariableDefault('g:acp_behaviorFileLength', 0)
call s:defineVariableDefault('g:acp_behaviorRubyOmniMethodLength', 0)
call s:defineVariableDefault('g:acp_behaviorRubyOmniSymbolLength', 1)
call s:defineVariableDefault('g:acp_behaviorPythonOmniLength', 0)
call s:defineVariableDefault('g:acp_behaviorPerlOmniLength', -1)
call s:defineVariableDefault('g:acp_behaviorXmlOmniLength', 0)
call s:defineVariableDefault('g:acp_behaviorHtmlOmniLength', 0)
call s:defineVariableDefault('g:acp_behaviorCssOmniPropertyLength', 1)
call s:defineVariableDefault('g:acp_behaviorCssOmniValueLength', 0)
call s:defineVariableDefault('g:acp_behavior', {})
"-----------------------------------------------------------------------------
call extend(g:acp_behavior, s:makeDefaultBehavior(), 'keep')
"-----------------------------------------------------------------------------
command! -bar -narg=0 AcpEnable  call acp#enable()
command! -bar -narg=0 AcpDisable call acp#disable()
command! -bar -narg=0 AcpLock    call acp#lock()
command! -bar -narg=0 AcpUnlock  call acp#unlock()
"-----------------------------------------------------------------------------
" legacy commands
command! -bar -narg=0 AutoComplPopEnable  AcpEnable
command! -bar -narg=0 AutoComplPopDisable AcpDisable
command! -bar -narg=0 AutoComplPopLock    AcpLock
command! -bar -narg=0 AutoComplPopUnlock  AcpUnlock
"-----------------------------------------------------------------------------
if g:acp_enableAtStartup
  AcpEnable
endif
"-----------------------------------------------------------------------------

" }}}1
"=============================================================================
" vim: set fdm=marker:
