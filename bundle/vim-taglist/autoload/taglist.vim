" File: taglist.vim
" Maintainer: Zhenhuan Hu (zhu@mcw.edu)
" Original Author: Yegappan Lakshmanan (yegappan AT yahoo DOT com)
" Version: 5.0.0
" Last Modified: Feb 18, 2017
" Copyright: Copyright (C) 2002-2013 Yegappan Lakshmanan
"                          2017      Zhenhuan Hu
"            Permission is hereby granted to use and distribute this code,
"            with or without modifications, provided that this copyright
"            notice is copied with it. Like anything else that is free,
"            this plugin is provided *as is* and comes with no warranty of any
"            kind, either expressed or implied. In no event will the copyright
"            holder be liable for any damages resulting from the use of this
"            software.

" LOAD GUARD: {{{1
if exists('g:loaded_autoload_taglist') ||
      \ v:version < 700 || !exists('*system')
  finish
endif
let g:loaded_autoload_taglist = 1

" }}}1

" Save cpoptions.
let s:cpo_save = &cpo
set cpo&vim

" LANGUAGE SETTINGS: {{{1
"       s:tlist_def_settings
"
" Key         - File type detected by Vim
"
" Value format:
"
"       <ctags_ftype>;<flag>:<name>;<flag>:<name>;...
"
" ctags_ftype - File type supported by exuberant ctags
" flag        - Flag supported by exuberant ctags to generate a tag type
" name        - Name of the tag type used in the taglist window to display the
"               tags of this type

" Default file types supported by exuberant ctags
let s:tlist_def_settings = {
      \ 'ant'       : 'ant;p:projects;t:targets;',
      \ 'asm'       : 'asm;d:define;l:label;m:macro;t:type;',
      \ 'asp'       : 'asp;c:constants;v:variable;f:function;s:subroutine;',
      \ 'aspvbs'    : 'asp;c:constants;v:variable;f:function;s:subroutine;',
      \ 'awk'       : 'awk;f:function;',
      \ 'basic'     : 'basic;c:constant;l:label;g:enum;v:variable;' .
      \               't:type;f:function;',
      \ 'beta'      : 'beta;f:fragment;s:slot;v:pattern;',
      \ 'c'         : 'c;d:macro;g:enum;s:struct;u:union;t:typedef;' .
      \               'v:variable;f:function;',
      \ 'cpp'       : 'c++;n:namespace;v:variable;d:macro;t:typedef;' .
      \               'c:class;g:enum;s:struct;u:union;f:function;',
      \ 'cs'        : 'c#;d:macro;t:typedef;n:namespace;c:class;' .
      \               'E:event;g:enum;s:struct;i:interface;' .
      \               'p:properties;m:method;',
      \ 'cobol'     : 'cobol;d:data;f:file;g:group;p:paragraph;' .
      \               'P:program;s:section;',
      \ 'd'         : 'c++;n:namespace;v:variable;t:typedef;' .
      \               'c:class;g:enum;s:struct;u:union;f:function;',
      \ 'dosbatch'  : 'dosbatch;l:labels;v:variables;',
      \ 'eiffel'    : 'eiffel;c:class;f:feature;',
      \ 'erlang'    : 'erlang;d:macro;r:record;m:module;f:function;',
      \ 'flex'      : 'flex;v:global;c:classes;p:properties;' .
      \               'm:methods;f:functions;x:mxtags;',
      \ 'fortran'   : 'fortran;p:program;b:block data;' .
      \               'c:common;e:entry;i:interface;k:type;l:label;m:module;' .
      \               'n:namelist;t:derived;v:variable;f:function;s:subroutine;',
      \ 'go'        : 'go;f:function;p:package;t:struct;',
      \ 'html'      : 'html;a:anchor;f:function;',
      \ 'java'      : 'java;p:package;c:class;i:interface;g:enum;f:field;m:method;',
      \ 'javascript': 'javascript;c:class;m:method;v:global;f:function;p:properties;',
      \ 'lisp'      : 'lisp;f:function;',
      \ 'lua'       : 'lua;f:function;',
      \ 'make'      : 'make;m:macro;',
      \ 'matlab'    : 'matlab;f:function;',
      \ 'ocamal'    : 'ocamal;M:module;v:global;t:type;' .
      \               'c:class;f:function;m:method;C:constructor;e:exception;',
      \ 'pascal'    : 'pascal;f:function;p:procedure;',
      \ 'perl'      : 'perl;c:constant;l:label;p:package;s:subroutine;',
      \ 'php'       : 'php;c:class;i:interface;d:constant;v:variable;f:function;',
      \ 'python'    : 'python;c:class;m:member;f:function;',
      \ 'pyrex'     : 'python;c:class;m:memder;f:function;',
      \ 'rexx'      : 'rexx;s:subroutine;',
      \ 'ruby'      : 'ruby;c:class;f:method;F:function;m:singleton method;',
      \ 'scheme'    : 'scheme;s:set;f:function;',
      \ 'sh'        : 'sh;f:function;',
      \ 'csh'       : 'sh;f:function;',
      \ 'zsh'       : 'sh;f:function;',
      \ 'slang'     : 'slang;n:namespace;f:function;',
      \ 'sml'       : 'sml;e:exception;c:functor;s:signature;' .
      \               'r:structure;t:type;v:value;c:functor;f:function;',
      \ 'sql'       : 'sql;c:cursor;f:function;F:field;p:procedure;P:package;' .
      \               'r:record;s:subtype;t:table;T:trigger;v:variable;',
      \ 'tcl'       : 'tcl;c:class;f:method;m:method;p:procedure;',
      \ 'expect'    : 'tcl;c:class;f:method;p:procedure;',
      \ 'tex'       : 'tex;c:chapters;s:sections;u:subsections;'.
      \               'b:subsubsections;p:parts;P:paragraphs;G:subparagraphs;',
      \ 'vera'      : 'vera;c:class;d:macro;e:enumerator;' .
      \               'f:function;g:enum;m:member;p:program;' .
      \               'P:prototype;t:task;T:typedef;v:variable;' .
      \               'x:externvar;',
      \ 'verilog'   : 'verilog;m:module;c:constant;P:parameter;' .
      \               'e:event;r:register;t:task;w:write;p:port;v:variable;f:function;',
      \ 'vhdl'      : 'vhdl;c:constant;t:type;T:subtype;r:record;' .
      \               'e:entity;f:function;p:procedure;P:package;',
      \ 'vim'       : 'vim;v:variable;a:autocmds;c:commands;m:map;f:function;',
      \ 'yacc'      : 'yacc;l:label;',
      \ }

" Additional file type settings
let s:tlist_markdown_settings = 'markdown;h:Heading L1;i:Heading L2;k:Heading L3;'
let s:tlist_sas_settings      = 'sas;l:libname;f:filename;' .
      \                         'd:data step;p:procedure;h:hash object;t:format;' .
      \                         'm:macro function;v:macro variable;'
" }}}1

" INITIALIZATION: {{{1
" Taglist debug support
let s:tlist_debug = 0
" File for storing the debug messages
let s:tlist_debug_file = ''
" Vim window size is changed by the taglist plugin or not
let s:tlist_winsize_chgd = -1
" Vim window has been initialized or not
let s:tlist_window_initialized = 0
" Taglist window is maximized or not
let s:tlist_win_maximized = 0
" Are we displaying brief help text
let s:tlist_brief_help = 1
" Taglist menu is empty or not
let s:tlist_menu_empty = 1
" An autocommand is used to refresh the taglist window when entering any
" buffer. We don't want to refresh the taglist window if we are entering the
" file window from one of the taglist functions. The 'tlist_skip_refresh'
" variable is used to skip the refresh of the taglist window and is set
" and cleared appropriately.
let s:tlist_skip_refresh = 0
" Dictionary to store file type settings
let s:tlist_filetype_settings = {}
" File cache to store file information
let s:tlist_file_cache = {}
" Current file displayed in the taglist window
let s:tlist_cur_file = ''
" Last returned file for file lookup.
" Used to speed up file lookup
let s:tlist_lnum_file_cache = ''
" Last returned flag for flag lookup.
" Used to speed up flag lookup
let s:tlist_lnum_flag_cache = ''
" Menu prefix characters for menu items
let s:tlist_menu_prefix_chars =
      \ '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
" }}}1

" GLOBAL FUNCTIONS: {{{1

" Open and refresh the taglist window
function! taglist#WindowOpen()
  call s:LogMsg('WindowOpen()')
  " If the window is open, jump to it
  let tlist_winnr = bufwinnr(g:TagList_title)
  if tlist_winnr != -1 && s:tlist_window_initialized == 1
    " Jump to the existing window
    if winnr() != tlist_winnr
      call s:ExeCmdWithoutAcmds(tlist_winnr . 'wincmd w')
    endif
    return
  endif
  " Mark the current window as the desired window to open a file
  " when a tag is selected.
  call s:WindowMarkFileWindow()
  " Open the taglist window
  call s:WindowCreate()
  " Get the filename and filetype for the specified buffer
  let fname = fnamemodify(bufname('%'), ':p')
  let ftype = s:GetBufferFileType(bufname('%'))
  if g:tlist_show_one_file
    " Add only the current buffer and file
    " If the file doesn't support tag listing, skip it
    if s:SkipFile(fname, ftype)
      return
    endif
    " Refresh the current file in the taglist window
    call s:WindowRefreshFileInDisplay(fname, ftype)
  else
    " Refresh all files in the taglist window
    call s:WindowRefresh()
  endif
  if g:tlist_auto_close_file_fold
    " Open the fold for the current file, as all the folds in
    " the taglist window are closed
    if has_key(s:tlist_file_cache, fname)
      exe 'silent! ' . s:tlist_file_cache[fname].str . ',' .
            \ s:tlist_file_cache[fname].end . 'foldopen!'
    endif
  endif
  " Highlight the current tag
  call s:ExeCmdWithoutAcmds('wincmd p')
  call s:HighlightTag(1, 1)
  if g:tlist_gain_focus_on_open
    " Go back to the taglist window
    call s:GotoTagListWindow()
  endif
endfunction

" Close the taglist window
function! taglist#WindowClose()
  call s:LogMsg('WindowClose()')
  " Make sure the taglist window exists
  let tlist_winnr = bufwinnr(g:TagList_title)
  if tlist_winnr == -1
    call s:WarningMsg('Error: Taglist window is not open')
    return
  endif
  if winnr() == tlist_winnr
    " Already in the taglist window. Close it and return
    if winbufnr(2) != -1
      " If a window other than the taglist window is open,
      " then only close the taglist window.
      close
    endif
  else
    " Goto the taglist window, close it and then come back to the
    " original window
    let save_bufnr = bufnr('%')
    exe tlist_winnr . 'wincmd w'
    close
    " Need to jump back to the original window only if we are not
    " already in that window
    let winnum = bufwinnr(save_bufnr)
    if winnr() != winnum
      exe winnum . 'wincmd w'
    endif
  endif
endfunction

" Open or close a taglist window
function! taglist#WindowToggle()
  call s:LogMsg('WindowToggle()')
  " If taglist window is open then close it.
  let tlist_winnr = bufwinnr(g:TagList_title)
  if tlist_winnr != -1
    call taglist#WindowClose()
    return
  endif
  call taglist#WindowOpen()
  " Update the taglist menu
  if g:tlist_show_menu
    call s:MenuUpdateFile(0)
  endif
endfunction

" Add the specified list of files to the taglist
function! taglist#AddFiles(...)
  let flist = []
  let i = 1
  " Get all the files matching the file patterns supplied as argument
  while i <= a:0
    if v:version >= 704
      let flist += glob(a:{i}, 0, 1)
    else
      let flist += split(glob(a:{i}, 0), "\n")
    endif
    let i += 1
  endwhile
  if empty(flist)
    call s:WarningMsg('Error: No matching files are found')
    return
  endif
  let fcnt = s:BatchProcessFileList(flist)
  echon "Added " . fcnt . " files to the taglist"
endfunction

" Add files recursively from a directory
function! taglist#AddFilesRecursive(dir, ...)
  let dir_name = fnamemodify(a:dir, ':p')
  if !isdirectory(dir_name)
    call s:WarningMsg('Error: ' . dir_name . ' is not a directory')
    return
  endif
  " User specified file pattern if available
  let pat = a:0 == 1 ? a:1 : '*'
  echo 'Processing files in directory ' . fnamemodify(dir_name, ':t')
  let fcnt = s:BatchProcessDir(dir_name, pat)
  echo 'Added ' . fcnt . ' files to the taglist'
endfunction

" Update taglist for the current buffer by regenerating the tag list
" Contributed by WEN Guopeng.
function! taglist#UpdateCurrentFile()
  call s:LogMsg('UpdateCurrentFile()')
  if winnr() == bufwinnr(g:TagList_title)
    " In the taglist window. Update the current file
    call s:WindowUpdateFile()
  else
    " Not in the taglist window. Update the current buffer
    let fname = fnamemodify(bufname('%'), ':p')
    let ftype = s:GetBufferFileType(bufname('%'))
    if has_key(s:tlist_file_cache, fname)
      let s:tlist_file_cache[fname].valid = 0
    endif
    call s:UpdateFile(fname, ftype)
  endif
endfunction

" Get the name for the closest tag on or before
" the current line in the current buffer
function! taglist#GetTagNameByLine()
  let tag = s:GetTagByLine()
  if empty(tag)
    return
  endif
  " Highlight the tag in the taglist window (if opened)
  call s:HighlightTag(2, 1)
  let name = tag.tag_name
  if g:tlist_display_tag_scope
    " Add the scope of the tag
    let tag_scope = tag.tag_scope
    if tag_scope != ''
      let name .= ' [' . tag_scope . ']'
    endif
  endif
  echo name
endfunction

" Get the prototype for the closest tag on or before
" the current line in the current buffer
function! taglist#GetTagPrototypeByLine()
  let tag = s:GetTagByLine()
  if empty(tag)
    return
  endif
  " Highlight the tag in the taglist window (if opened)
  call s:HighlightTag(2, 1)
  echo tag.tag_proto
endfunction

" Jump the cursor to the closest tag on or before
" the current line in the current buffer
function! taglist#JumpToTagByLine()
  " Get the current buffer name and line number
  let fname = fnamemodify(bufname('%'), ':p')
  let lnum = line('.')
  " Verify the file name
  if !has_key(s:tlist_file_cache, fname)
    return
  endif
  " If there are no tags for this file, then no need to proceed further
  if empty(s:tlist_file_cache[fname].flags)
    return
  endif
  " Get the tag text using the line number
  let closest_tag = s:SearchClosestTagIndex(fname, lnum)
  if empty(closest_tag)
    return
  endif
  " Highlight the tag in the taglist window (if opened)
  call s:HighlightTag(2, 1) | echo
  " Jump to the tag
  call call('s:MenuJumpToTag', closest_tag)
endfunction

" Save a taglist session (information about all the displayed files
" and the tags) into the specified file
function! taglist#SessionSave(...)
  if a:0 == 0 || a:1 == ''
    call s:WarningMsg('Usage: SessionSave <filename>')
    return
  endif
  let sessionfile = a:1
  if empty(s:tlist_file_cache)
    call s:WarningMsg('Empty file cache. Nothing to save.')
    return
  endif
  if filereadable(sessionfile)
    let ans = input('Do you want to overwrite ' . sessionfile . ' (Y/N)?')
    if ans !=? 'y'
      return
    endif
  endif
  let old_verbose = &verbose
  set verbose&vim
  exe 'redir! > ' . sessionfile
  silent! echo '" TagList session file. This file is auto-generated.'
  silent! echo '" System time: ' . strftime('%c')
  silent! echo '" Session information:'
  silent! echo 'let tlist_file_cache = ' . string(s:tlist_file_cache)
  silent! echo 'let tlist_filetype_settings =' . string(s:tlist_filetype_settings)
  redir END
  let &verbose = old_verbose
endfunction

" Load a taglist session (information about all the displayed files
" and the tags) from the specified file
function! taglist#SessionLoad(...)
  if a:0 == 0 || a:1 == ''
    call s:WarningMsg('Usage: SessionLoad <filename>')
    return
  endif
  let sessionfile = a:1
  if !filereadable(sessionfile)
    call s:WarningMsg('Unable to open file ' . sessionfile)
    return
  endif
  " Mark the current window as the file window
  call s:WindowMarkFileWindow()
  " Source the session file
  exe 'source ' . sessionfile
  if !exists('g:tlist_filetype_settings') ||
        \ !exists('g:tlist_file_cache')
    call s:WarningMsg('No session information found in ' . sessionfile)
    return
  endif
  if exists('g:tlist_filetype_settings')
    if empty(s:tlist_filetype_settings)
      let s:tlist_filetype_settings = copy(g:tlist_filetype_settings)
    else
      for key in keys(g:tlist_filetype_settings)
        if !has_key(s:tlist_filetype_settings, key)
          let s:tlist_filetype_settings[key] = copy(g:tlist_filetype_settings[key])
        endif
      endfor
    endif
    unlet! g:tlist_filetype_settings
  endif
  if exists('g:tlist_file_cache')
    for fname in keys(g:tlist_file_cache)
      if g:tlist_file_cache[fname].ftime != getftime(fname)
        let g:tlist_file_cache[fname].valid = 0
        let g:tlist_file_cache[fname].ftime = getftime(fname)
      endif
      let g:tlist_file_cache[fname].str = 0
      let g:tlist_file_cache[fname].end = 0
      if !empty(g:tlist_file_cache[fname].flags)
        for flag in keys(g:tlist_file_cache[fname].flags)
          let g:tlist_file_cache[fname].flags[flag].offset = 0
        endfor
      endif
    endfor
    if empty(s:tlist_file_cache)
      let s:tlist_file_cache = copy(g:tlist_file_cache)
    else
      for key in keys(g:tlist_file_cache)
        if !has_key(s:tlist_file_cache, key)
          let s:tlist_file_cache[key] = copy(g:tlist_file_cache[key])
        endif
      endfor
    endif
    unlet! g:tlist_file_cache
  endif
  " If the taglist window is open, then update it
  let tlist_winnr = bufwinnr(g:TagList_title)
  if tlist_winnr != -1
    let save_winnr = winnr()
    " Goto the taglist window
    call s:GotoTagListWindow()
    " Refresh the taglist window
    call s:WindowRefresh()
    " Go back to the original window
    if save_winnr != winnr()
      call s:ExeCmdWithoutAcmds('wincmd p')
    endif
  endif
endfunction

" Enable logging of taglist debug messages.
function! taglist#DebugEnable(...)
  let s:tlist_debug = 1
  " Check whether a valid file name is supplied.
  if a:1 != ''
    let s:tlist_debug_file = fnamemodify(a:1, ':p')
    " Empty the log file
    exe 'redir! > ' . s:tlist_debug_file
    redir END
    " Check whether the log file is present/created
    if !filewritable(s:tlist_debug_file)
      call s:WarningMsg('Unable to create log file '
            \ . s:tlist_debug_file)
      let s:tlist_debug_file = ''
    endif
  endif
endfunction

" Disable logging of taglist debug messages.
function! taglist#DebugDisable(...)
  let s:tlist_debug = 0
  let s:tlist_debug_file = ''
endfunction

" Display the taglist debug messages in a new window
function! taglist#DebugShow()
  if s:tlist_msg == ''
    call s:WarningMsg('No debug messages')
    return
  endif
  " Open a new window to display the taglist debug messages
  new taglist_debug.txt
  " Delete all the lines (if the buffer already exists)
  silent! %delete _
  " Add the messages
  silent! put =s:tlist_msg
  " Move the cursor to the first line
  normal! gg
endfunction

" Initialize the taglist menu
function! taglist#MenuInit()
  call s:MenuAddBaseMenu()
  " Automatically add the tags defined in the current file to the menu
  augroup TagListMenuCmds
    autocmd!
    if !g:tlist_process_file_always
      " Auto refresh the taglist window
      autocmd BufEnter,BufWritePost,FileChangedShellPost * call taglist#RefreshCurrentBuffer()
      " When a buffer is deleted, remove the file from the taglist
      autocmd BufDelete * silent call taglist#BufferRemoved(expand('<afile>:p'))
    endif
    autocmd BufLeave * call s:MenuRemoveFile()
  augroup END
  call s:MenuUpdateFile(0)
endfunction

" Open the taglist window automatically on Vim startup.
" Open the window only when files present in any of the Vim windows support
" tags.
function! taglist#WindowCheckAutoOpen()
  let open_window = 0
  let winnum = 1
  let bufnum = winbufnr(winnum)
  while bufnum != -1
    let fname = fnamemodify(bufname(bufnum), ':p')
    let ftype = s:GetBufferFileType(bufnum)
    if !s:SkipFile(fname, ftype)
      let open_window = 1
      break
    endif
    let winnum += 1
    let bufnum = winbufnr(i)
  endwhile
  if open_window
    call taglist#WindowOpen()
  endif
endfunction

" Refresh the taglist
function! taglist#RefreshCurrentBuffer()
  call s:LogMsg('RefreshCurrentBuffer(tlist_skip_refresh = ' .
        \ s:tlist_skip_refresh . ', ' . bufname('%') . ')')
  " Skip buffers with 'buftype' set to nofile, nowrite, quickfix or help
  " This also includes taglist window itself
  if &buftype != ''
    return
  endif
  " If we are entering the buffer from one of the taglist functions, then
  " no need to refresh the taglist window again.
  if s:tlist_skip_refresh
    " We still need to update the taglist menu
    if g:tlist_show_menu
      call s:MenuUpdateFile(0)
    endif
    return
  endif
  " If the taglist window is not opened and not configured to process
  " tags always and not displaying the tags menu, then return
  if bufwinnr(g:TagList_title) == -1 &&
        \ !g:tlist_process_file_always &&
        \ !g:tlist_show_menu
    return
  endif
  let fname = fnamemodify(bufname('%'), ':p')
  let ftype = s:GetBufferFileType(bufname('%'))
  " If the file doesn't support tag listing, skip it
  if s:SkipFile(fname, ftype)
    return
  endif
  if !has_key(s:tlist_file_cache, fname)
    " If the taglist should not be auto updated, then return
    if !g:tlist_auto_update
      return
    endif
  endif
  " Initialize the tags for the file
  call s:UpdateFile(fname, ftype)
  " Update the taglist menu
  if g:tlist_show_menu
    call s:MenuUpdateFile(0)
  endif
endfunction

" A buffer is removed from the Vim buffer list. Remove the tags defined
" for that file
function! taglist#BufferRemoved(fname)
  call s:LogMsg('BufferRemoved(' . a:fname .  ')')
  " Make sure a valid filename is supplied
  if a:fname == ''
    return
  endif
  let fname = fnamemodify(a:fname, ':p')
  " Get tag list index of the specified file
  if !has_key(s:tlist_file_cache, fname)
    " File not present in the taglist
    return
  endif
  " Remove the file from the list
  call s:RemoveFile(fname, 0)
endfunction

" Initialize the taglist window/buffer, which is created when loading
" a Vim session file.
function! taglist#VimSessionLoad()
  call s:LogMsg('VimSessionLoad')
  " Initialize the taglist window
  call s:WindowInit()
  " Refresh the taglist window
  call s:WindowRefresh()
endfunction

" When the mouse cursor is over a tag in the taglist window, display the
" tag prototype (balloon)
function! taglist#BalloonExpr()
  " Get the tag info
  let info = s:WindowGetInfoByLineNr(v:beval_lnum)
  return info
endfunction
" }}}1

" INTERNAL FUNCTIONS: {{{1
" Display a message using WarningMsg highlight group
function! s:WarningMsg(msg)
  echohl WarningMsg
  echomsg (a:msg !~ '^\w\+:') ? 'TagList: ' . a:msg : a:msg
  echohl None
endfunction

" Log the supplied debug message along with the time
function! s:LogMsg(msg)
  if s:tlist_debug
    let msg = strftime('%H:%M:%S') . ': ' . a:msg
    if s:tlist_debug_file != ''
      exe 'redir >> ' . s:tlist_debug_file
      silent echo msg
      redir END
    else
      " Log the message into a variable
      " Retain only the last 3000 characters
      if !exists('s:tlist_msg')
        let s:tlist_msg = ''
      endif
      let len = strlen(s:tlist_msg)
      if len > 3000
        let s:tlist_msg = strpart(s:tlist_msg, len - 3000)
      endif
      let s:tlist_msg .= msg
    endif
  endif
endfunction

" Execute the specified Ex command after disabling autocommands
function! s:ExeCmdWithoutAcmds(cmd)
  let old_eventignore = &eventignore
  set eventignore=all
  exe a:cmd
  let &eventignore = old_eventignore
endfunction

" Goto the taglist window
function! s:GotoTagListWindow()
  let tlist_winnr = bufwinnr(g:TagList_title)
  if tlist_winnr != -1
    if winnr() != tlist_winnr
      call s:ExeCmdWithoutAcmds(tlist_winnr . 'wincmd w')
    endif
  endif
endfunction

" Update the list of user removed files from the taglist
" add == 1, Add the file to the removed list
" add == 0, Delete the file from the removed list
function! s:UpdateRemovedFileList(fname, add)
  if !has_key(s:tlist_file_cache, a:fname)
    return
  endif
  let ftype = s:tlist_file_cache[a:fname].ftype
  if a:add && s:tlist_file_cache[a:fname].visible != -1
    call s:DiscardFileInfo(a:fname)
    call s:InitFile(a:fname, ftype)
    let s:tlist_file_cache[a:fname].visible = -1
  elseif s:tlist_file_cache[a:fname].visible == -1
    let s:tlist_file_cache[a:fname].visible = 0
  endif
endfunction

" Determine the filetype for the specified file using the filetypedetect
" autocmd.
function! s:GetFileType(fname)
  " Save the 'filetype', as this will be changed temporarily
  let old_filetype = &filetype
  " Ignore the filetype autocommands
  let old_eventignore = &eventignore
  set eventignore=FileType
  " Run the filetypedetect group of autocommands to determine
  " the filetype
  exe 'doautocmd filetypedetect BufRead ' . a:fname
  " Save the detected filetype
  let ftype = &filetype
  " Restore the previous state
  let &filetype = old_filetype
  let &eventignore = old_eventignore
  return ftype
endfunction

" Get the filetype for the specified buffer
function! s:GetBufferFileType(bnum)
  let bname = bufname(a:bnum)
  " Skip non-existent buffers
  if !bufexists(bname)
    return ''
  endif
  let buf_ft = getbufvar(bname, '&filetype')
  " Check whether 'filetype' contains multiple file types separated by '.'
  " If it is, then use the first file type
  let pos = stridx(buf_ft, '.')
  if pos != -1
    let buf_ft = strpart(buf_ft, 0, pos)
  endif
  if bufloaded(bname)
    " For loaded buffers, the 'filetype' is already determined
    return buf_ft
  endif
  " For unloaded buffers, if the 'filetype' option is set, return it
  if buf_ft != ''
    return buf_ft
  endif
  " For buffers whose filetype is not yet determined, try to determine
  " the filetype
  return s:GetFileType(bname)
endfunction

function! s:ParseRawSettingStrings(settings)
  " Format of the string that specifies the filetype and ctags arugments:
  "
  "       <ctags_ftype>;<flag>:<name>;<flag>:<name>;...
  "
  " Note: The file type passed to ctags may be different from the
  " file type detected by Vim
  let msg = 'Invalid ctags option setting - ' . a:settings
  let pos = stridx(a:settings, ';')
  if pos <= 0
    call s:WarningMsg(msg)
    return {}
  endif
  let ftype = strpart(a:settings, 0, pos)
  " Make sure a valid filetype is supplied. If the user didn't specify a
  " valid filetype, then the ctags option settings may be treated as the
  " filetype
  if stridx(ftype, ':') != -1
    call s:WarningMsg(msg)
    return {}
  endif
  " Parse file type settings to a dictionary
  let parsed_settings = { 'ftype': ftype, 'flags': {} }
  " Remove the file type from settings
  let settings = strpart(a:settings, pos + 1)
  if settings == ''
    call s:WarningMsg(msg)
    return {}
  endif
  " Process all the specified ctags flags.
  while settings != ''
    " Extract the flag
    let pos = stridx(settings, ':')
    if pos == -1
      call s:WarningMsg(msg)
      return {}
    endif
    let flag = strpart(settings, 0, pos)
    if flag == ''
      call s:WarningMsg(msg)
      return {}
    endif
    " Remove the flag from settings
    let settings = strpart(settings, pos + 1)
    " Extract the tag type name
    let pos = stridx(settings, ';')
    if pos == -1
      call s:WarningMsg(msg)
      return {}
    endif
    let name = strpart(settings, 0, pos)
    if name == ''
      call s:WarningMsg(msg)
      return {}
    endif
    let settings = strpart(settings, pos + 1)
    let parsed_settings.flags[flag] = name
  endwhile
  return parsed_settings
endfunction

" Initialize the ctags settings for the session
" with respect to the specified file type
function! s:InitFileTypeSettings(ftype)
  call s:LogMsg('InitFileTypeSettings(' . a:ftype . ')')
  if !exists('s:tlist_filetype_settings')
    let s:tlist_filetype_settings = {}
  endif
  " No need to do anything if session file type
  " settings already exist
  if has_key(s:tlist_filetype_settings, a:ftype)
    return 1
  endif
  " If the user didn't specify any settings, use the default
  " ctags settings. Otherwise, use the settings specified by the user.
  " This allows the user settings to overwrite the default settings.
  if exists('g:tlist_' . a:ftype . '_settings')
    " User specified ctags settings
    let settings = s:ParseRawSettingStrings(eval(
          \ 'g:tlist_' . a:ftype . '_settings'))
    if empty(settings)
      return 0
    endif
  elseif exists('s:tlist_' . a:ftype . '_settings')
    " Plugin specified additional ctags settings
    let settings = s:ParseRawSettingStrings(eval(
          \ 's:tlist_' . a:ftype . '_settings'))
    if empty(settings)
      return 0
    endif
  elseif has_key(s:tlist_def_settings, a:ftype)
    " Default ctags settings
    let settings = s:ParseRawSettingStrings(s:tlist_def_settings[a:ftype])
  else
    " No default settings for this file type. This filetype is
    " not supported
    return 0
  endif
  " Store ctags settings for the session
  let s:tlist_filetype_settings[a:ftype] = settings
  return 1
endfunction

" Extract the tag prototype from the tag text
function! s:ExtractTagPrototype(tag_line_parts)
  let tag_proto = (a:tag_line_parts[2][-4: -4] == '$' ?
        \ a:tag_line_parts[2][2: -5] :
        \ a:tag_line_parts[2][2: -4])
  return substitute(tag_proto, '^\s\+', '', '')
endfunction

" Extract the tag search pattern from the tag text
function! s:ExtractTagSearchPattern(tag_line_parts)
  let tag_pattern = (a:tag_line_parts[2][-4: -4] == '$' ?
        \ a:tag_line_parts[2][2: -5] :
        \ a:tag_line_parts[2][2: -4])
  return '\V\^' . tag_pattern . '\$'
endfunction

" Extract the tag scope from the tag text
function! s:ExtractTagScope(tag_line_parts)
  return len(a:tag_line_parts) > 5 ?
        \ strpart(a:tag_line_parts[-1],
        \ stridx(a:tag_line_parts[-1], ':') + 1) :
        \ ''
endfunction

" Parse a tag line from the ctags output. Separate the tag output based on the
" tag type and store it in the tag type variable.
" The format of each line in the ctags output is:
"
"     tag_name<TAB>file_name<TAB>ex_cmd;"<TAB>extension_fields
"
function! s:ParseTagLine(tag_line, fname, ftype)
  if a:tag_line == ''
    " Skip empty lines
    return 0
  elseif a:tag_line =~ '^ctags\.exe: Warning:'
    " Log warning messages
    call s:WarningMsg(a:tag_line)
    return 0
  endif
  " Divide the tag line into parts
  let tag_line_parts = split(a:tag_line, "\t")
  " Extract tag flag
  let tag_flag = tag_line_parts[3]
  " Make sure the tag flag is a valid and supported one
  if !has_key(s:tlist_filetype_settings[a:ftype].flags, tag_flag)
    return 0
  endif
  " Extract tag specific information
  let cur_tag = {
        \ 'tag_flag'   : tag_flag,
        \ 'tag_name'   : tag_line_parts[0],
        \ 'tag_lnum'   : tag_line_parts[4][5:],
        \ 'tag_proto'  : s:ExtractTagPrototype(tag_line_parts),
        \ 'tag_pattern': s:ExtractTagSearchPattern(tag_line_parts),
        \ 'tag_scope'  : s:ExtractTagScope(tag_line_parts),
        \ }
  " Store flag information if it is not already available
  if !has_key(s:tlist_file_cache[a:fname].flags, tag_flag)
    let s:tlist_file_cache[a:fname].flags[tag_flag] = {
          \ 'offset': 0,
          \ 'tags'  : [],
          \ }
  endif
  " Store tag specific information
  call add(s:tlist_file_cache[a:fname].flags[tag_flag].tags, cur_tag)
  return 1
endfunction

" Simply return the line number of the specified tag
function! s:GetTagLineNr(fname, flag, tidx)
  return s:tlist_file_cache[a:fname].flags[a:flag].tags[a:tidx].tag_lnum
endfunction

" Search the closest tag to the supplied line number
" Returns [flag, tidx] for the flag and index of that tag
" Returns [], if no tag can be found for the specified line number
function! s:SearchClosestTagIndex(fname, lnum)
  call s:LogMsg('SearchClosestTagIndex(' . a:fname . ', ' . a:lnum . ')')
  let sort_type = s:tlist_file_cache[a:fname].sortby
  let closest_tag = []
  for flag in keys(s:tlist_file_cache[a:fname].flags)
    let left = 0
    let right = len(s:tlist_file_cache[a:fname].flags[flag].tags) - 1
    if sort_type == 'order'
      " Tags sorted by order, use a binary search.
      " The idea behind this function is taken from the ctags.vim script (by
      " Alexey Marinichev) available at the Vim online website.
      " If the current line is the less than the first tag, then no need to
      " search
      let first_lnum = s:GetTagLineNr(a:fname, flag, 0)
      if a:lnum < first_lnum
        continue
      endif
      while left < right
        let middle = (left + right + 1) / 2
        let middle_lnum = s:GetTagLineNr(a:fname, flag, middle)
        if middle_lnum == a:lnum
          let left = middle
          break
        elseif middle_lnum > a:lnum
          let right = middle - 1
        else
          let left = middle
        endif
      endwhile
    else
      " Tags sorted by name, use a linear search. (by Dave Eggum)
      " Look for a tag with a line number less than or equal to the supplied
      " line number. If multiple tags are found, then use the tag with the
      " line number closest to the supplied line number. IOW, use the tag
      " with the highest line number.
      let closest_lnum = 0
      let final_left = 0
      while left <= right
        let lnum = s:GetTagLineNr(a:fname, flag, left)
        if lnum == a:lnum
          let closest_lnum = lnum
          let final_left = left
          break
        elseif lnum < a:lnum && lnum > closest_lnum
          let closest_lnum = lnum
          let final_left = left
        else
          let left += 1
        endif
      endwhile
      if closest_lnum == 0
        continue
      endif
      if left >= right
        let left = final_left
      endif
    endif
    " Compare tags of other flags
    let lnum = s:GetTagLineNr(a:fname, flag, left)
    if lnum  == a:lnum
      let closest_tag = [flag, left]
      break
    elseif empty(closest_tag) ||
          \ lnum > str2nr(s:GetTagLineNr(a:fname, closest_tag[0], closest_tag[1]))
      let closest_tag = [flag, left]
    endif
  endfor
  return closest_tag
endfunction

" Get the tag on or before the specified line number in the
" current buffer
function! s:GetTagByLine()
  " Get the current buffer name and line number
  let fname = fnamemodify(bufname('%'), ':p')
  let lnum = line('.')
  " Verify the file name
  if !has_key(s:tlist_file_cache, fname)
    return {}
  endif
  " If there are no tags for this file, then no need to proceed further
  if empty(s:tlist_file_cache[fname].flags)
    return {}
  endif
  " Get the tag text using the line number
  let closest_tag = s:SearchClosestTagIndex(fname, lnum)
  if empty(closest_tag)
    return {}
  endif
  let [flag, tidx] = closest_tag
  return s:tlist_file_cache[fname].flags[flag].tags[tidx]
endfunction

" Highlight the current tag
" type == 1, Called by the taglist plugin itself
" type == 2, Forced by the user through the TlistHighlightTag command
" center == 1, Center the position of the tag name in the taglist window
function! s:HighlightTag(type, center)
  " Highlight the current tag only if the user configured the
  " taglist plugin to do so or if the user explictly invoked the
  " command to highlight the current tag.
  if !g:tlist_auto_highlight_tag && a:type == 1
    return
  endif
  " Make sure the taglist window is present
  let save_winnr = winnr()
  let tlist_winnr = bufwinnr(g:TagList_title)
  if tlist_winnr == -1
    " Do nothing is the taglist window is not open
    call s:WarningMsg('Error: Taglist window is not open')
    return
  elseif tlist_winnr == save_winnr
    call s:WarningMsg('Error: This is the taglist window')
    return
  endif
  " Get the current buffer name and line number
  let fname = fnamemodify(bufname('%'), ':p')
  let lnum = line('.')
  if !has_key(s:tlist_file_cache, fname)
    return
  endif
  " If the file is not being displayed in the taglist window, then return
  if s:tlist_file_cache[fname].visible != 1
    return
  endif
  " If there are no tags for this file, then no need to proceed further
  if empty(s:tlist_file_cache[fname].flags)
    return
  endif
  " Get the tag index
  let closest_tag = s:SearchClosestTagIndex(fname, lnum)
  if empty(closest_tag)
    return
  endif
  let [flag, tidx] = closest_tag
  " Go to the taglist window
  call s:GotoTagListWindow()
  " Clear previously selected name
  match none
  " Goto the line containing the tag
  exe s:tlist_file_cache[fname].str +
        \ s:tlist_file_cache[fname].flags[flag].offset + tidx + 1
  " Open the fold
  if foldclosed('.') != -1
    .foldopen
  endif
  if a:center
    " Move the tag line to the center of the taglist window
    normal! z.
  else
    " Make sure the current tag line is visible in the taglist window.
    " Calling the winline() function makes the line visible. Don't know
    " of a better way to achieve this.
    call winline()
  endif
  " Highlight the tag name
  call s:WindowHighlightLine()
  " Go back to the original window
  call s:ExeCmdWithoutAcmds('wincmd p')
  return
endfunction

" Check whether tag listing is supported for the specified file
function! s:SkipFile(fname, ftype)
  " Skip buffers with no names and buffers with filetype not set
  if a:fname == '' || a:ftype == ''
    return 1
  endif
  " Skip files which are not supported by exuberant ctags
  " First check whether default settings for this filetype are available.
  " If it is not available, then check whether user specified settings are
  " available. If both are not available, then don't list the tags for this
  " filetype
  if !has_key(s:tlist_def_settings, a:ftype) &&
        \ !exists('s:tlist_' . a:ftype . '_settings') &&
        \ !exists('g:tlist_' . a:ftype . '_settings')
    return 1
  endif
  " Skip files which are not readable or files which are not yet stored
  " to the disk
  if !filereadable(a:fname)
    return 1
  endif
  return 0
endfunction

" Initialize a new file in the file cache
function! s:InitFile(fname, ftype)
  call s:LogMsg('InitFile(' . a:fname . ')')
  if !has_key(s:tlist_file_cache, a:fname)
    " File type settings are required to initialize the file cache
    if !has_key(s:tlist_filetype_settings, a:ftype)
      call s:WarningMsg('File type settings not initialized.')
      return 0
    endif
    " Initialize the file variables
    let s:tlist_file_cache[a:fname] = {
          \ 'ftype'  : a:ftype,
          \ 'sortby' : g:tlist_sort_type,
          \ 'ftime'  : 0,
          \ 'valid'  : 0,
          \ 'visible': 0,
          \ 'str'    : 0,
          \ 'end'    : 0,
          \ 'ntags'  : 0,
          \ 'flags'  : {},
          \ 'mcmd'   : '',
          \ }
  endif
  return 1
endfunction

" Discard the stored tag information for a file
function! s:DiscardFileTagInfo(fname)
  call s:LogMsg('DiscardFileTagInfo(' . a:fname . ')')
  if !has_key(s:tlist_file_cache, a:fname)
    return 0
  endif
  " Discard total number of tags
  let s:tlist_file_cache[a:fname].ntags = 0
  " Discard information about the tags defined in the file
  let s:tlist_file_cache[a:fname].flags = {}
  " Discard the stored menu command
  let s:tlist_file_cache[a:fname].mcmd = ''
  return 1
endfunction

" Discard a file from the file cache
function! s:DiscardFileInfo(fname)
  call s:LogMsg('DiscardFileInfo(' . a:fname . ')')
  call remove(s:tlist_file_cache, a:fname)
endfunction

" Get the list of tags defined in the file and store them
" in the file cache.
function! s:ProcessFile(fname, ftype)
  call s:LogMsg('ProcessFile(' . a:fname . ', ' . a:ftype . ')')
  " Check whether this file is supported
  if s:SkipFile(a:fname, a:ftype)
    return 0
  endif
  " If the filetype settings are not yet initialized, then process them now
  if !has_key(s:tlist_filetype_settings, a:ftype)
    if s:InitFileTypeSettings(a:ftype) == 0
      return 0
    endif
  endif
  " If the file cache has never been initialized, then create the file cache,
  " otherwise discard the tag information
  if !has_key(s:tlist_file_cache, a:fname)
    if s:InitFile(a:fname, a:ftype) == 0
      return 0
    endif
  else
    call s:DiscardFileTagInfo(a:fname)
  endif
  let s:tlist_file_cache[a:fname].valid = 1
  " Create ctags arguments
  let ctags_args = ''
  " Read contents of ctags configuration file
  if exists('g:tlist_ctags_conf') && len(g:tlist_ctags_conf) > 0
    let ctags_args .= '--options=' . shellescape(g:tlist_ctags_conf) . ' '
  endif
  " Default ctags arguments for taglist plugin
  let ctags_args .= '-f - --format=2 --excmd=pattern --fields=nks '
  " Add sort type to ctags arguments
  let ctags_args .= '--sort=' . (
        \ s:tlist_file_cache[a:fname].sortby == 'name' ?
        \ 'yes' : 'no') . ' '
  " Add the filetype specific arguments
  let ctags_args .= '--language-force=' .
        \ s:tlist_filetype_settings[a:ftype].ftype .
        \ ' --' . s:tlist_filetype_settings[a:ftype].ftype . '-types=' .
        \ join(keys(s:tlist_filetype_settings[a:ftype].flags), '')
  " Ctags command to produce output with regexp for locating the tags
  let ctags_cmd = g:tlist_ctags_cmd . ' ' .
        \ ctags_args . ' ' . shellescape(a:fname)
  " Run ctags and get the tag list
  call s:LogMsg('Run: ' . ctags_cmd)
  let cmd_output = system(ctags_cmd)
  " Handle errors
  if v:shell_error
    call s:WarningMsg('Failed to generate tags for ' . a:fname)
    if cmd_output != ''
      call s:WarningMsg(cmd_output)
    endif
    return 1
  endif
  " Store the modification time for the file
  let s:tlist_file_cache[a:fname].ftime = getftime(a:fname)
  " No tags for current file
  if cmd_output == ''
    call s:LogMsg('No tags defined in ' . a:fname)
    return 1
  endif
  call s:LogMsg('Generated tags for ' . a:fname)
  call s:LogMsg(">>>\n" . cmd_output . "\n<<<")
  " Parse the ctags output
  let nparsed = count(map(split(cmd_output, '\n'),
        \ 's:ParseTagLine(v:val, a:fname, a:ftype)'), 1)
  call s:LogMsg('A total of ' . nparsed . ' tags have been parsed')
  let s:tlist_file_cache[a:fname].ntags = nparsed
  return 1
endfunction

" Update the tags for a file (if needed)
function! s:UpdateFile(fname, ftype)
  call s:LogMsg('UpdateFile(' . a:fname . ')')
  " If the file doesn't support tag listing, skip it
  if s:SkipFile(a:fname, a:ftype)
    return
  endif
  if has_key(s:tlist_file_cache, a:fname)
    if s:tlist_file_cache[a:fname].visible == -1
      " File is suppressed by the user, then return
      call s:LogMsg('File is suppressed by the user. Return.')
      return
    elseif s:tlist_file_cache[a:fname].valid &&
          \ s:tlist_file_cache[a:fname].ftime == getftime(a:fname)
      " File exists and the tags are valid
      " Check whether the file was modified after the last tags update
      " If it is not modified, no need to update the tags
      return
    else
      " Need to invalidate the file otherwise the taglist window
      " will not update
      let s:tlist_file_cache[a:fname].valid = 0
    endif
  endif
  " If the taglist window is not present, update the taglist
  " of the file and return, otherwise update the taglist window
  if bufwinnr(g:TagList_title) == -1
    call s:ProcessFile(a:fname, a:ftype)
    return
  endif
  " If tags for only one file are displayed and we are not
  " updating the tags for that file, then there is no need to
  " refresh the taglist window. Update the taglist and return
  if g:tlist_show_one_file && s:tlist_cur_file != '' &&
        \ s:tlist_cur_file !=# a:fname
    call s:ProcessFile(a:fname, a:ftype)
    return
  endif
  " The taglist window is present so need to update both
  " Disable screen updates
  let old_lazyredraw = &lazyredraw
  set nolazyredraw
  " Save the current window number
  let save_winnr = winnr()
  " Goto the taglist window
  call s:GotoTagListWindow()
  " Save the cursor position
  let save_pos = getpos('.')[1: 2]
  " Update the taglist window and the file
  call s:WindowRefreshFileInDisplay(a:fname, a:ftype)
  " Restore the cursor position
  call cursor(save_pos)
  " Jump back to the original window
  if save_winnr != winnr()
    call s:ExeCmdWithoutAcmds(save_winnr . 'wincmd w')
  endif
  " Highlight the current tag
  if g:tlist_show_one_file && s:tlist_cur_file != a:fname
    " If displaying tags for only one file in the taglist
    " window and about to display the tags for a new file,
    " then center the current tag line for the new file
    let center_tag_line = 1
  else
    let center_tag_line = 0
  endif
  call s:HighlightTag(1, center_tag_line)
  " Restore screen updates
  let &lazyredraw = old_lazyredraw
  " Update the taglist menu
  if g:tlist_show_menu
    call s:MenuUpdateFile(1)
  endif
endfunction

" Remove the specified file
function! s:RemoveFile(fname)
  call s:LogMsg('RemoveFile(' . a:fname . ')')
  let save_winnr = winnr()
  let tlist_winnr = bufwinnr(g:TagList_title)
  if tlist_winnr != -1
    " When taglist window is open, remove the file from display
    if save_winnr != tlist_winnr
      call s:ExeCmdWithoutAcmds(tlist_winnr . 'wincmd w')
    endif
    call s:WindowRemoveFileFromDisplay(a:fname)
    if save_winnr != tlist_winnr
      call s:ExeCmdWithoutAcmds('wincmd p')
    endif
  endif
  " Discard the file from the file cache
  call s:DiscardFileInfo(a:fname)
  " If the tags for only one file is displayed and if we just
  " now removed that file, then invalidate the current file variable
  if g:tlist_show_one_file
    if s:tlist_cur_file ==# a:fname
      let s:tlist_cur_file = ''
    endif
  endif
endfunction

" Process multiple files. Each filename is separated by "\n"
" Returns the number of processed files
function! s:BatchProcessFileList(flist)
  let flist = a:flist
  if empty(flist)
    return 0
  endif
  " Enable lazy screen updates
  let old_lazyredraw = &lazyredraw
  set lazyredraw
  " Keep track of the number of processed files
  let fcnt = 0
  " Process one file at a time
  for fname in flist
    if fname == '' || isdirectory(fname)
      continue
    endif
    let fname = fnamemodify(fname, ':p')
    let ftype = s:GetFileType(fname)
    " If the file is suppressed by the user, release it from suppression
    if has_key(s:tlist_file_cache, fname) &&
      s:tlist_file_cache[fname].visible == -1
      call s:LogMsg('Release ' .
            \ fnamemodify(fname, ':p:t') . 'from suppression')
      let s:tlist_file_cache[fname].visible = 0
    endif
    call s:LogMsg('Processing tags for ' . fnamemodify(fname, ':p:t'))
    call s:UpdateFile(fname, ftype)
    let fcnt += 1
  endfor
  " Restore the previous state
  let &lazyredraw = old_lazyredraw
  return fcnt
endfunction

" Process the files in a directory matching the specified pattern
function! s:BatchProcessDir(dir_name, pat)
  let len = strlen(a:dir_name)
  let top_dir =
        \ (a:dir_name[len - 1] == '\' || a:dir_name[len - 1] == '/') ?
        \ a:dirname : a:dirname . '/'
  if v:version >= 704
    let flist = glob(top_dir . a:pat, 0, 1)
    let all_files = glob(top_dir . '*', 0, 1)
  else
    let flist = split(glob(top_dir . a:pat, 0), "\n")
    let all_files = split(glob(top_dir . '*', 0), "\n")
  endif
  let fcnt = s:BatchProcessFileList(flist)
  for dir_name in all_files
    " Skip non-directory names
    if dir_name == '' || !isdirectory(dir_name)
      continue
    endif
    call s:LogMsg('Processing files in directory ' . fnamemodify(dir_name, ':t'))
    let fcnt += s:BatchProcessDir(dir_name, a:pat)
  endfor
  return fcnt
endfunction

" Update the line offsets of tags for other files (with respect
" to the reference file) being displayed in the taglist window
function! s:WindowUpdateLineOffsets(fname, increment, offset)
  for fname in keys(s:tlist_file_cache)
    " No need to update the reference file
    if fname ==# a:fname
      continue
    endif
    " Update the line offsets only if the file is visible
    if s:tlist_file_cache[fname].visible != 1
      continue
    endif
    " No need to update for files displayed before the reference file
    if a:fname != ''
      if s:tlist_file_cache[fname].end <
            \ s:tlist_file_cache[a:fname].str
        continue
      endif
    endif
    if a:increment
      let s:tlist_file_cache[fname].str += a:offset
      let s:tlist_file_cache[fname].end += a:offset
    else
      let s:tlist_file_cache[fname].str -= a:offset
      let s:tlist_file_cache[fname].end -= a:offset
    endif
  endfor
endfunction

" Remove the file from display
function! s:WindowRemoveFileFromDisplay(fname)
  call s:LogMsg('WindowRemoveFileFromDisplay(' . a:fname . ')')
  " If the file is not visible then no need to remove it
  if s:tlist_file_cache[a:fname].visible != 1
    return
  endif
  " Remove the tags displayed for the specified file from the window
  let start = s:tlist_file_cache[a:fname].str
  " Include the empty line after the last line also
  let end = g:tlist_compact_format ?
        \ s:tlist_file_cache[a:fname].end :
        \ s:tlist_file_cache[a:fname].end + 1
  setlocal modifiable
  exe 'silent! ' . start . ',' . end . 'delete _'
  setlocal nomodifiable
  " Update the start & end line offsets for all the files following
  " this file, as the tags for this file are removed
  call s:WindowUpdateLineOffsets(a:fname, 0, end - start + 1)
endfunction

" List the tags of the file in the taglist window
function! s:WindowRefreshFileInDisplay(fname, ftype)
  call s:LogMsg('WindowRefreshFileInDisplay(' . a:fname . ')')
  " First check whether the file already exists
  if has_key(s:tlist_file_cache, a:fname)
    if s:tlist_file_cache[a:fname].visible == -1
      " Check whether this file is removed based on user request
      " If it is, then no need to display the tags for this file
      call s:LogMsg('File removed by the user. Return.')
      return
    elseif s:tlist_file_cache[a:fname].visible == 1
      " Check whether the file tags are currently valid
      if s:tlist_file_cache[a:fname].valid
        call s:LogMsg('File listed and valid. Only unfold.')
        " Goto the first line in the file
        exe s:tlist_file_cache[a:fname].str
        " If the line is inside a fold, open the fold
        if foldclosed('.') != -1
          exe 'silent! ' . s:tlist_file_cache[a:fname].str . ',' .
                \ s:tlist_file_cache[a:fname].end . 'foldopen!'
        endif
        return
      else
        " Discard and remove the tags for this file from display
        call s:WindowRemoveFileFromDisplay(a:fname)
        call s:DiscardFileTagInfo(a:fname)
      endif
    endif
  endif
  " Process and generate a list of tags defined in the file
  if !s:ProcessFile(a:fname, a:ftype)
    return
  endif
  " Set report option to a huge value to prevent informational messages
  " while adding lines to the taglist window
  let old_report = &report
  set report=99999
  if g:tlist_show_one_file
    " Remove the previous file
    if s:tlist_cur_file != ''
      call s:WindowRemoveFileFromDisplay(s:tlist_cur_file)
      let s:tlist_file_cache[s:tlist_cur_file].visible = 0
      let s:tlist_file_cache[s:tlist_cur_file].str = 0
      let s:tlist_file_cache[s:tlist_cur_file].end = 0
    endif
    let s:tlist_cur_file_idx = a:fname
  endif
  " Mark the buffer as modifiable
  setlocal modifiable
  " Add new files to the end of the window. For existing files, add them at
  " the same line where they were previously present. If the file is not
  " visible, then add it at the end
  if s:tlist_file_cache[a:fname].str == 0 ||
        \ s:tlist_file_cache[a:fname].visible != 1
    let s:tlist_file_cache[a:fname].str = line('$') + 1
  endif
  let s:tlist_file_cache[a:fname].visible = 1
  " Add the file name to the buffer
  exe s:tlist_file_cache[a:fname].str - 1
  let fname_txt = fnamemodify(a:fname, ':t') . ' (' .
        \ fnamemodify(a:fname, ':p:h') . ')'
  let file_start_lnum = line('.') + 1
  silent! put =fname_txt
  " Add tag names grouped by the flags to the buffer
  for flag in keys(s:tlist_file_cache[a:fname].flags)
    " Add flag full names to the buffer
    let flag_txt = '  ' . s:tlist_filetype_settings[a:ftype].flags[flag]
    let flag_start_lnum = line('.') + 1
    silent! put =flag_txt
    " Add tag names to the buffer
    for taglet in s:tlist_file_cache[a:fname].flags[flag].tags
      if g:tlist_display_prototype
        let tag_txt = '    ' . taglet['tag_proto']
      else
        let tag_txt = '    ' . taglet['tag_name']
        if g:tlist_display_tag_scope && taglet['tag_scope'] != ''
          let tag_txt .= ' [' . taglet['tag_scope'] . ']'
        endif
      endif
      silent! put =tag_txt
    endfor
    " Add an empty line if not compact format
    if g:tlist_compact_format == 0
      silent! put =''
    endif
    " Store flag text offset
    let s:tlist_file_cache[a:fname].flags[flag]['offset'] =
          \ flag_start_lnum - file_start_lnum
  endfor
  " Still need to add an empty line after the file name text
  " if no flag is found for the file
  if empty(s:tlist_file_cache[a:fname].flags)
    if g:tlist_compact_format == 0
      silent! put =''
    endif
  endif
  let s:tlist_file_cache[a:fname].end = line('.') - 1
  call s:WindowCreateFoldsForFile(a:fname)
  " Goto the starting line for this file,
  exe s:tlist_file_cache[a:fname].str
  " Mark the buffer as not modifiable
  setlocal nomodifiable
  " Restore the report option
  let &report = old_report
  " Update the start & end line offsets for all the files following this file
  let start = s:tlist_file_cache[a:fname].str
  let end = g:tlist_compact_format ?
        \ s:tlist_file_cache[a:fname].end :
        \ s:tlist_file_cache[a:fname].end + 1
  call s:WindowUpdateLineOffsets(a:fname, 1, end - start + 1)
  " Update the tags menu (if present)
  if g:tlist_show_menu
    call s:MenuUpdateFile(1)
  endif
endfunction

" Display help at the start of the buffer
function! s:WindowDisplayHelp()
  if s:tlist_brief_help
    " Add the brief help
    call append( 0, '" Press <F1> to display help text')
  else
    " Add the extensive help
    call append( 0, '" <enter> : Jump to tag definition')
    call append( 1, '" o : Jump to tag definition in new window')
    call append( 2, '" p : Preview the tag definition')
    call append( 3, '" <space> : Display tag prototype')
    call append( 4, '" u : Update tag list')
    call append( 5, '" s : Select sort field')
    call append( 6, '" d : Remove file from taglist')
    call append( 7, '" x : Zoom-out/Zoom-in taglist window')
    call append( 8, '" + : Open a fold')
    call append( 9, '" - : Close a fold')
    call append(10, '" * : Open all folds')
    call append(11, '" = : Close all folds')
    call append(12, '" [[ : Move to the start of previous file')
    call append(13, '" ]] : Move to the start of next file')
    call append(14, '" q : Close the taglist window')
    call append(15, '" <F1> : Remove help text')
  endif
endfunction

" Display the tags for all the files in the taglist window
function! s:WindowRefresh()
  call s:LogMsg('WindowRefresh()')
  " Set report option to a huge value to prevent informational messages
  " while deleting the lines
  let old_report = &report
  set report=99999
  " Mark the buffer as modifiable
  setlocal modifiable
  " Delete the contents of the buffer to the black-hole register
  silent! %delete _
  " As we have cleared the taglist window, mark all the files
  " as not visible
  for fname in keys(s:tlist_file_cache)
    if s:tlist_file_cache[fname].visible == 1
      let s:tlist_file_cache[fname].visible = 0
    endif
  endfor
  if g:tlist_compact_format == 0
    " Display help in non-compact mode
    call s:WindowDisplayHelp()
  endif
  " Mark the buffer as not modifiable
  setlocal nomodifiable
  " Restore the report option
  let &report = old_report
  " If the tags for only one file should be displayed in the taglist
  " window, then no need to add the tags here. The bufenter autocommand
  " will add the tags for that file.
  if g:tlist_show_one_file
    return
  endif
  " List all the tags for the previously processed files
  " Do this only if taglist is configured to display tags for more than
  " one file. Otherwise, when tlist_show_one_file is configured,
  " tags for the wrong file will be displayed.
  for fname in keys(s:tlist_file_cache)
    let ftype = s:tlist_file_cache[fname].ftype
    call s:WindowRefreshFileInDisplay(fname, ftype)
  endfor
  if g:tlist_auto_update
    " Add and list the tags for all buffers in the Vim buffer list
    let bnum = 1
    while bnum <= bufnr('$')
      if buflisted(bnum)
        let fname = fnamemodify(bufname(bnum), ':p')
        let ftype = s:GetBufferFileType(bnum)
        " If the file does not support tag listing, skip it
        if !s:SkipFile(fname, ftype)
          call s:WindowRefreshFileInDisplay(fname, ftype)
        endif
      endif
      let bnum += 1
    endwhile
  endif
  " If tlist_auto_close_file_fold option is set, then close all the folds
  if g:tlist_auto_close_file_fold
    " Close all the folds
    silent! %foldclose
  endif
  " Move the cursor to the top of the taglist window
  normal! gg
endfunction

" Return the filename present in the specified line number
" Line number refers to the line number in the taglist window
function! s:WindowGetFileByLineNr(lnum)
  call s:LogMsg('WindowGetFileByLineNr(' . a:lnum . ')')
  " First try to see whether the new line number is within the range
  " of the last returned file
  if s:tlist_lnum_file_cache != '' &&
        \ has_key(s:tlist_file_cache, s:tlist_lnum_file_cache)
    if a:lnum >= s:tlist_file_cache[s:tlist_lnum_file_cache].str &&
          \ a:lnum <= s:tlist_file_cache[s:tlist_lnum_file_cache].end
      return s:tlist_lnum_file_cache
    endif
  endif
  let r_fname = ''
  if g:tlist_show_one_file
    " Displaying only one file in the taglist window. Check whether
    " the line is within the tags displayed for that file
    if s:tlist_cur_file != ''
      if a:lnum >= s:tlist_file_cache[s:tlist_cur_file].str &&
            \ a:lnum <= s:tlist_file_cache[s:tlist_cur_file].end
        let r_fname = s:tlist_cur_file
      endif
    endif
  else
    for fname in keys(s:tlist_file_cache)
      if a:lnum >= s:tlist_file_cache[fname].str &&
            \ a:lnum <= s:tlist_file_cache[fname].end
        let r_fname = fname
        break
      endif
    endfor
  endif
  let s:tlist_lnum_file_cache = r_fname
  return r_fname
endfunction

" Return the flag for the specified line in the taglist window
function! s:WindowGetFlagByLineNr(fname, lnum)
  call s:LogMsg('WindowGetFlagByLineNr(' . a:fname . ', ' . a:lnum . ')')
  " First try to see whether the new line number is within the range
  " of the last returned flag
  if s:tlist_lnum_flag_cache != '' &&
        \ has_key(s:tlist_file_cache[a:fname].flags,
        \ s:tlist_lnum_flag_cache)
    let start = s:tlist_file_cache[a:fname].str +
          \ s:tlist_file_cache[a:fname].flags[s:tlist_lnum_flag_cache].offset
    let end = start +
          \ len(s:tlist_file_cache[a:fname].flags[s:tlist_lnum_flag_cache].tags)
    if a:lnum >= start && a:lnum <= end
      return s:tlist_lnum_flag_cache
    endif
  endif
  let r_flag = ''
  " Determine to which flag the current line number belongs to using the
  " flag start line number and the number of tags under that flag
  for flag in keys(s:tlist_file_cache[a:fname].flags)
    let start = s:tlist_file_cache[a:fname].str +
          \ s:tlist_file_cache[a:fname].flags[flag].offset
    let end = start + len(s:tlist_file_cache[a:fname].flags[flag].tags)
    if a:lnum >= start && a:lnum <= end
      let r_flag = flag
      break
    endif
  endfor
  let s:tlist_lnum_flag_cache = r_flag
  return r_flag
endfunction

" Get tag information based on the line number of the taglist window
function! s:WindowGetInfoByLineNr(lnum)
  " Do not process empty or comment lines
  let line = getline(a:lnum)
  if line == '' || line[0] == '"'
    return ''
  endif
  " Get the file name
  let fname = s:WindowGetFileByLineNr(a:lnum)
  if fname == ''
    return ''
  endif
  " Prepare info text
  let info = fname
  if strlen(info) > min([50, &columns - 1])
    let info = fnamemodify(fname, ':t')
  endif
  if a:lnum == s:tlist_file_cache[fname].str
    " Cursor is on a file name
    let info .= ', Type: ' . s:tlist_file_cache[fname].ftype .
          \ ', Total Tag Count: ' . s:tlist_file_cache[fname].ntags
  else
    " Get the flag
    let flag = s:WindowGetFlagByLineNr(fname, a:lnum)
    if flag == ''
      let info .= ', Type: ' . s:tlist_file_cache[fname].ftype .
            \ ', Total Tag Count: ' . s:tlist_file_cache[fname].ntags
    else
      " Get the tag proto
      let tidx = s:WindowGetTagIndex(fname, flag, a:lnum)
      if tidx == -1
        let info .= ', Flag: ' . flag .
              \ ', Tag Count: ' . len(s:tlist_file_cache[fname].flags[flag].tags) .
              \ ' of ' . s:tlist_file_cache[fname].ntags
      else
        let info .= ', Flag: ' . flag . ', Prototype: ' .
              \ s:tlist_file_cache[fname].flags[flag].tags[tidx]['tag_proto']
      endif
    endif
  endif
  return info
endfunction

" Display information about the entry under the cursor
function! s:WindowShowInfo()
  call s:LogMsg('WindowShowInfo()')
  " Clear the previously displayed line
  echo
  " If inside a fold, then don't display the prototype
  if foldclosed('.') != -1
    return
  endif
  " Get the tag info of the current line
  let info = s:WindowGetInfoByLineNr(line('.'))
  " Cut info text within the range of the window width
  if len(info) > &columns - 21
    let info = strpart(info, 0, &columns - 25) . ' ...'
  endif
  echo info
  return
endfunction

" Return the tag index for the specified line in the taglist window
function! s:WindowGetTagIndex(fname, flag, lnum)
  " Compute the index into the displayed tags
  let tidx = -1
  let flag_start = s:tlist_file_cache[a:fname].str +
        \ s:tlist_file_cache[a:fname].flags[a:flag].offset
  let flag_end = flag_start +
        \ len(s:tlist_file_cache[a:fname].flags[a:flag].tags)
  if a:lnum > flag_start && a:lnum <= flag_end
    let tidx = a:lnum - flag_start - 1
  endif
  return tidx
endfunction

" Update the tags displayed in the taglist window
function! s:WindowUpdateFile()
  call s:LogMsg('WindowUpdateFile()')
  " Get the file name with respect to the current line
  let fname = s:WindowGetFileByLineNr(line('.'))
  " If the current line is not in the range of any file,
  " such as in the help section, return
  if fname == ''
    return
  endif
  " Remove the previous highlighting
  match none
  " Save the current line for later restoration
  let curline = '\V\^' . escape(getline('.'), "\\") . '\$'
  " Invalidate the tags listed for this file
  let s:tlist_file_cache[fname].valid = 0
  " Update the taglist window
  call s:WindowRefreshFileInDisplay(fname, s:tlist_file_cache[fname].ftype)
  " Go back to the tag line before the list is updated
  call search(curline, 'w')
  if g:tlist_show_menu
    call s:MenuUpdateFile(1)
  endif
endfunction

" Remove the file from the taglist window
function! s:WindowRemoveFile()
  call s:LogMsg('WindowRemoveFile()')
  " Get the file name with respect to the current line
  let fname = s:WindowGetFileByLineNr(line('.'))
  " If the current line is not in the range of any file,
  " such as in the help section, return
  if fname == ''
    return
  endif
  call s:WindowRemoveFileFromDisplay(fname)
  " As the user requested to remove the file from taglist,
  " add it to the removed file list
  call s:UpdateRemovedFileList(fname, 1)
  " If the tags for only one file is displayed and if we just
  " now removed that file, then invalidate the current file variable
  if g:tlist_show_one_file
    if s:tlist_cur_file ==# fname
      let s:tlist_cur_file = ''
    endif
  endif
endfunction

" Mark the current window as the file window to use when jumping to a tag.
" Only if the current window is a non-plugin, non-preview and non-taglist
" window
function! s:WindowMarkFileWindow()
  if getbufvar('%', '&buftype') == '' && !&previewwindow
    let w:tlist_file_window = 'yes'
  endif
endfunction

" Open the specified file in either a new window or an existing window
" and place the cursor at the specified tag pattern
function! s:WindowOpenFile(win_ctrl, fname, tagpat)
  call s:LogMsg('WindowOpenFile(' . a:fname . ',' .
        \ a:win_ctrl . ')')
  let prev_tlist_skip_refresh = s:tlist_skip_refresh
  let s:tlist_skip_refresh = 1
  if a:win_ctrl == 'newtab'
    " Create a new tab
    exe 'tabnew ' . fnameescape(a:fname)
    " Open the taglist window in the new tab
    call taglist#WindowOpen()
  endif
  if a:win_ctrl == 'checktab'
    " Check whether the file is present in any of the tabs.
    " If the file is present in the current tab, then use the
    " current tab.
    if bufwinnr(a:fname) != -1
      let file_present_in_tab = 1
      let tnum = tabpagenr()
    else
      let tnum = 1
      let bnum = bufnr(a:fname)
      let file_present_in_tab = 0
      while tnum <= tabpagenr('$')
        if index(tabpagebuflist(tnum), bnum) != -1
          let file_present_in_tab = 1
          break
        endif
        let tnum += 1
      endwhile
    endif
    if file_present_in_tab
      " Goto the tab containing the file
      exe 'tabnext ' . tnum
    else
      " Open a new tab
      exe 'tabnew ' . fnameescape(a:fname)
      " Open the taglist window
      call taglist#WindowOpen()
    endif
  endif
  let winnum = -1
  if a:win_ctrl == 'prevwin'
    " Open the file in the previous window, if it is usable
    let save_win = winnr()
    wincmd p
    if &buftype == '' && !&previewwindow
      exe "edit " . fnameescape(a:fname)
      let winnum = winnr()
    else
      " Previous window is not usable
      exe save_win . 'wincmd w'
    endif
  endif
  " Goto the window containing the file.  If the window is not there, open a
  " new window
  if winnum == -1
    let winnum = bufwinnr(a:fname)
  endif
  if winnum == -1
    " Locate the previously used window for opening a file
    let fwin_num = 0
    let first_usable_win = 0
    let i = 1
    let bnum = winbufnr(i)
    while bnum != -1
      if getwinvar(i, 'tlist_file_window') == 'yes'
        let fwin_num = i
        break
      endif
      if first_usable_win == 0 &&
            \ getbufvar(bnum, '&buftype') == '' &&
            \ !getwinvar(i, '&previewwindow')
        " First non-taglist, non-plugin and non-preview window
        let first_usable_win = i
      endif
      let i += 1
      let bnum = winbufnr(i)
    endwhile
    " If a previously used window is not found, then use the first
    " non-taglist window
    if fwin_num == 0
      let fwin_num = first_usable_win
    endif
    if fwin_num != 0
      " Jump to the file window
      exe fwin_num . "wincmd w"
      " If the user asked to jump to the tag in a new window, then split
      " the existing window into two.
      if a:win_ctrl == 'newwin'
        split
      endif
      exe "edit " . fnameescape(a:fname)
    else
      " Open a new window
      let cmd_mod = (v:version >= 700) ? 'keepalt ' : ''
      if g:tlist_use_horiz_window
        exe cmd_mod . 'leftabove split ' . fnameescape(a:fname)
      else
        if winbufnr(2) == -1
          " Only the taglist window is present
          if g:tlist_use_right_window
            exe cmd_mod . 'leftabove vertical split ' .
                  \ fnameescape(a:fname)
          else
            exe cmd_mod . 'rightbelow vertical split ' .
                  \ fnameescape(a:fname)
          endif
          " Go to the taglist window to change the window size to
          " the user configured value
          call s:ExeCmdWithoutAcmds('wincmd p')
          if g:tlist_use_horiz_window
            exe 'resize ' . g:tlist_win_height
          else
            exe 'vertical resize ' . g:tlist_win_width
          endif
          " Go back to the file window
          call s:ExeCmdWithoutAcmds('wincmd p')
        else
          " A plugin or help window is also present
          wincmd w
          exe cmd_mod . 'leftabove split ' . fnameescape(a:fname)
        endif
      endif
    endif
    " Mark the window, so that it can be reused.
    call s:WindowMarkFileWindow()
  else
    if v:version >= 700
      " If the file is opened in more than one window, then check
      " whether the last accessed window has the selected file.
      " If it does, then use that window.
      let lastwin_bufnum = winbufnr(winnr('#'))
      if bufnr(a:fname) == lastwin_bufnum
        let winnum = winnr('#')
      endif
    endif
    exe winnum . 'wincmd w'
    " If the user asked to jump to the tag in a new window, then split the
    " existing window into two.
    if a:win_ctrl == 'newwin'
      split
    endif
  endif
  " Jump to the tag
  if a:tagpat != ''
    " Add the current cursor position to the jump list, so that user can
    " jump back using the ' and ` marks.
    mark '
    silent call search(a:tagpat, 'w')
    " Bring the line to the middle of the window
    normal! z.
    " If the line is inside a fold, open the fold
    if foldclosed('.') != -1
      .foldopen
    endif
  endif
  " If the user selects to preview the tag then jump back to the
  " taglist window
  if a:win_ctrl == 'preview'
    " Go back to the taglist window
    let winnum = bufwinnr(g:TagList_title)
    exe winnum . 'wincmd w'
  else
    " If the user has selected to close the taglist window, when a
    " tag is selected, close the taglist  window
    if g:tlist_close_on_select
      call s:GotoTagListWindow()
      close
      " Go back to the window displaying the selected file
      let wnum = bufwinnr(a:fname)
      if wnum != -1 && wnum != winnr()
        call s:ExeCmdWithoutAcmds(wnum . 'wincmd w')
      endif
    endif
  endif
  let s:tlist_skip_refresh = prev_tlist_skip_refresh
endfunction

" Highlight the current line
function! s:WindowHighlightLine()
  " Clear previously selected name
  match none
  " Highlight the current line
  if g:tlist_display_prototype == 0
    let pat = '/\%' . line('.') . 'l\s\+\zs.*/'
  else
    let pat = '/\%' . line('.') . 'l.*/'
  endif
  exe 'match TagListTagName ' . pat
endfunction

" Jump to the location of the current tag
" win_ctrl == useopen - Reuse the existing file window
" win_ctrl == newwin - Open a new window
" win_ctrl == preview - Preview the tag
" win_ctrl == prevwin - Open in previous window
" win_ctrl == newtab - Open in new tab
function! s:WindowJumpToTag(win_ctrl)
  call s:LogMsg('WindowJumpToTag(' . a:win_ctrl . ')')
  " Do not process comment lines and empty lines
  let curline = getline('.')
  if curline =~ '^\s*$' || curline[0] == '"'
    return
  endif
  " If inside a closed fold, then use the first line of the fold
  " and jump to the file.
  let lnum = foldclosed('.')
  if lnum == -1
    " Jump to the selected tag or file
    let lnum = line('.')
  else
    " Open the closed fold
    .foldopen!
  endif
  " Get the tag output for the current tag
  let fname = s:WindowGetFileByLineNr(lnum)
  if fname == ''
    return
  endif
  let flag = s:WindowGetFlagByLineNr(fname, lnum)
  if flag == ''
    return
  endif
  let tidx = s:WindowGetTagIndex(fname, flag, lnum)
  if tidx != -1
    let tagpat = s:tlist_file_cache[fname].flags[flag].tags[tidx]['tag_pattern']
    " Highlight the tagline
    call s:WindowHighlightLine()
  else
    " Selected a line which is not a tag name. Just edit the file
    let tagpat = ''
  endif
  call s:WindowOpenFile(a:win_ctrl, fname, tagpat)
endfunction

" Change the sort order of the tag listing
" action == 'toggle', toggle sort from name to order and vice versa
" action == 'set', set the sort order to sort_type
function! s:WindowChangeSort(action, sort_type)
  call s:LogMsg('WindowChangeSort(action = ' . a:action .
        \ ', sort_type = ' . a:sort_type . ')')
  let fname = s:WindowGetFileByLineNr(line('.'))
  if fname == ''
    return
  endif
  " Remove the previous highlighting
  match none
  if a:action == 'toggle'
    let sort_type = s:tlist_file_cache[fname].sortby
    " Toggle the sort order from 'name' to 'order' and vice versa
    if sort_type == 'name'
      let s:tlist_file_cache[fname].sortby = 'order'
    else
      let s:tlist_file_cache[fname].sortby = 'name'
    endif
  else
    let s:tlist_file_cache[fname].sortby = a:sort_type
  endif
  " Save the current line for later restoration
  let curline = '\V\^' . escape(getline('.'), "\\") . '\$'
  " Invalidate the tags listed for this file
  let s:tlist_file_cache[fname].valid = 0
  " Update the taglist window
  call s:WindowRefreshFileInDisplay(fname, s:tlist_file_cache[fname].ftype)
  exe s:tlist_file_cache[fname].str . ',' .
        \ s:tlist_file_cache[fname].end . 'foldopen!'
  " Go back to the cursor line before the tag list is sorted
  call search(curline, 'w')
  if g:tlist_show_menu
    call s:MenuUpdateFile(1)
  endif
endfunction

" Move the cursor to the beginning of the current/previous file in the taglist window
" or to the beginning of the next file in the taglist window
" dir == -1 - Move the cursor to the beginning of the current/previous file
" dir == 1  - Move the cursor to the beginning of the next file
function! s:WindowMoveToFile(dir)
  if foldlevel('.') == 0
    " Cursor is on a non-folded line (it is not in any of the files)
    " Move it to a folded line
    if a:dir == -1
      normal! zk
    else
      " While moving down to the start of the next fold,
      " no need to do go to the start of the next file.
      normal! zj
      return
    endif
  endif
  let fname = s:WindowGetFileByLineNr(line('.'))
  if fname == ''
    return
  endif
  if a:dir == -1
    if s:tlist_file_cache[fname].str < line('.')
      " Move to the beginning of the current file
      exe s:tlist_file_cache[fname].str
      return
    else
      exe s:tlist_file_cache[fname].str - 1
      call s:WindowMoveToFile(-1)
    endif
  else
    let offset = g:tlist_compact_format ? 0 : 1
    if s:tlist_file_cache[fname].end + offset == line('$')
      " Move the cursor to the start of the file
      " if the end of the file is the bottom of the taglist window
      exe s:tlist_file_cache[fname].str
      return
    else
      exe s:tlist_file_cache[fname].end + offset + 1
      return
    endif
  endif
endfunction

" Toggle taglist plugin help text between the full version
" and the brief version
function! s:WindowToggleHelpText()
  if g:tlist_compact_format
    " In compact display mode, do not display help
    return
  endif
  setlocal modifiable
  " Include the empty line displayed after the help text
  let brief_help_size = 1
  let full_help_size = 16
  " Set report option to a huge value to prevent informational messages
  " while deleting the lines
  let old_report = &report
  set report=99999
  " Remove the currently highlighted tag. Otherwise, the help text
  " might be highlighted by mistake
  match none
  " Toggle between brief and full help text
  if s:tlist_brief_help
    let s:tlist_brief_help = 0
    " Remove the previous help
    exe '1,' . brief_help_size . ' delete _'
    " Adjust the start/end line numbers for all files being displayed
    call s:WindowUpdateLineOffsets('', 1, full_help_size - brief_help_size)
  else
    let s:tlist_brief_help = 1
    " Remove the previous help
    exe '1,' . full_help_size . ' delete _'
    " Adjust the start/end line numbers for all files being displayed
    call s:WindowUpdateLineOffsets('', 0, full_help_size - brief_help_size)
  endif
  call s:WindowDisplayHelp()
  " Restore the report option
  let &report = old_report
  setlocal nomodifiable
endfunction

" Open the fold for the specified file and close the fold for all the
" other files
function! s:WindowOpenFileFold(acmd_bufnr)
  call s:LogMsg('WindowOpenFileFold(' . a:acmd_bufnr . ')')
  " Make sure the taglist window is present
  let tlist_winnr = bufwinnr(g:TagList_title)
  if tlist_winnr == -1
    call s:WarningMsg('Error: Taglist window is not open')
    return
  endif
  " Save the original window number
  let save_winnr = winnr()
  if save_winnr == tlist_winnr
    let in_taglist_window = 1
  else
    let in_taglist_window = 0
  endif
  if in_taglist_window
    " When entering the taglist window, no need to update the folds
    return
  endif
  " Go to the taglist window
  if !in_taglist_window
    call s:ExeCmdWithoutAcmds(tlist_winnr . 'wincmd w')
  endif
  " Close all the folds
  silent! %foldclose
  " Get tag list index of the specified file
  let fname = fnamemodify(bufname(a:acmd_bufnr + 0), ':p')
  if filereadable(fname)
    if has_key(s:tlist_file_cache, fname)
      " Open the fold for the file
      exe "silent! " . s:tlist_file_cache[fname].str . ',' .
            \ s:tlist_file_cache[fname].end . 'foldopen'
    endif
  endif
  " Go back to the original window
  if !in_taglist_window
    call s:ExeCmdWithoutAcmds(save_winnr . 'wincmd w')
  endif
endfunction

" Create the folds in the taglist window for the specified file
function! s:WindowCreateFoldsForFile(fname)
  " Create the folds for each tag type in a file
  for flag in keys(s:tlist_file_cache[a:fname].flags)
    let sf = s:tlist_file_cache[a:fname].str +
          \ s:tlist_file_cache[a:fname].flags[flag].offset
    let ef = sf + len(s:tlist_file_cache[a:fname].flags[flag].tags)
    exe sf . ',' . ef . 'fold'
  endfor
  exe s:tlist_file_cache[a:fname].str . ',' .
        \ s:tlist_file_cache[a:fname].end . 'fold'
  exe 'silent! ' . s:tlist_file_cache[a:fname].str . ',' .
        \ s:tlist_file_cache[a:fname].end . 'foldopen!'
endfunction

" Remove and create the folds for all the files displayed in the taglist
" window. Used after entering a tab. If this is not done, then the folds
" are not properly created for taglist windows displayed in multiple tabs.
function! s:WindowRefreshFolds()
  let tlist_winnr = bufwinnr(g:TagList_title)
  if tlist_winnr == -1
    return
  endif
  let save_wnum = winnr()
  exe tlist_winnr . 'wincmd w'
  " First remove all the existing folds
  normal! zE
  if g:tlist_show_one_file
    " If only one file is displayed in the taglist window, then there
    " is no need to refresh the folds for the tags as the tags for the
    " current file will be removed anyway.
  else
    " Create the folds for each file in the tag list
    for fname in keys(s:tlist_file_cache)
      call s:WindowCreateFoldsForFile(fname)
    endfor
  endif
  exe save_wnum . 'wincmd w'
endfunction

" Zoom (maximize/minimize) the taglist window
function! s:WindowZoom()
  if s:tlist_win_maximized
    " Restore the window back to the previous size
    if g:tlist_use_horiz_window
      exe 'resize ' . g:tlist_win_height
    else
      exe 'vert resize ' . g:tlist_win_width
    endif
    let s:tlist_win_maximized = 0
  else
    " Set the window size to the maximum possible without closing other
    " windows
    if g:tlist_use_horiz_window
      resize
    else
      vert resize
    endif
    let s:tlist_win_maximized = 1
  endif
endfunction

" If the 'tlist_exit_onlywindow' option is set, then exit Vim if only the
" taglist window is present.
function! s:WindowExitOnlyWindow()
  " Before quitting Vim, delete the taglist buffer so that
  " the '0 mark is correctly set to the previous buffer.
  if winbufnr(2) == -1
    if tabpagenr('$') == 1
      " Only one tag page is present
      "
      " When deleting the taglist buffer, autocommands cannot be
      " disabled. If autocommands are disabled, then on exiting Vim,
      " the window size will not be restored back to the original
      " size.
      bdelete
      quit
    else
      " More than one tab page is present. Close only the current
      " tab page
      close
    endif
  endif
endfunction

" Set the default options for the taglist window
function! s:WindowInit()
  call s:LogMsg('WindowInit()')
  " The 'readonly' option should not be set for the taglist buffer.
  " If Vim is started as "view/gview" or if the ":view" command is
  " used, then the 'readonly' option is set for all the buffers.
  " Unset it for the taglist buffer
  setlocal noreadonly
  " Set the taglist buffer filetype to taglist
  setlocal filetype=taglist

  " Folding related settings
  setlocal foldenable
  setlocal foldminlines=0
  setlocal foldmethod=manual
  setlocal foldlevel=9999
  if g:tlist_enable_fold_column
    setlocal foldcolumn=3
  else
    setlocal foldcolumn=0
  endif
  setlocal foldtext=v:folddashes.getline(v:foldstart)

  " Mark buffer as scratch
  silent! setlocal buftype=nofile
  silent! setlocal bufhidden=delete
  silent! setlocal noswapfile
  silent! setlocal nobuflisted

  silent! setlocal nowrap
  " If the 'number' option is set in the source window, it will affect the
  " taglist window. So forcefully disable 'number' option for the taglist
  " window
  silent! setlocal nonumber
  if exists('&relativenumber')
    silent! setlocal norelativenumber
  endif
  " Use fixed height when horizontally split window is used
  if g:tlist_use_horiz_window
    set winfixheight
  else
    set winfixwidth
  endif
  " Setup balloon evaluation to display tag prototype
  if has('balloon_eval')
    setlocal balloonexpr=taglist#BalloonExpr()
    set ballooneval
  endif

  " Create buffer local mappings for jumping to the tags and sorting the list
  nnoremap <buffer> <silent> <CR>          :call <SID>WindowJumpToTag('useopen')<CR>
  nnoremap <buffer> <silent> o             :call <SID>WindowJumpToTag('newwin')<CR>
  nnoremap <buffer> <silent> p             :call <SID>WindowJumpToTag('preview')<CR>
  nnoremap <buffer> <silent> P             :call <SID>WindowJumpToTag('prevwin')<CR>
  nnoremap <buffer> <silent> t             :call <SID>WindowJumpToTag('checktab')<CR>
  nnoremap <buffer> <silent> <C-t>         :call <SID>WindowJumpToTag('newtab')<CR>
  nnoremap <buffer> <silent> <2-LeftMouse> :call <SID>WindowJumpToTag('useopen')<CR>
  nnoremap <buffer> <silent> s             :call <SID>WindowChangeSort('toggle', '')<CR>
  nnoremap <buffer> <silent> u             :call <SID>WindowUpdateFile()<CR>
  nnoremap <buffer> <silent> d             :call <SID>WindowRemoveFile()<CR>
  nnoremap <buffer> <silent> x             :call <SID>WindowZoom()<CR>
  nnoremap <buffer> <silent> [[            :call <SID>WindowMoveToFile(-1)<CR>
  nnoremap <buffer> <silent> <BS>          :call <SID>WindowMoveToFile(-1)<CR>
  nnoremap <buffer> <silent> ]]            :call <SID>WindowMoveToFile(1)<CR>
  nnoremap <buffer> <silent> <Tab>         :call <SID>WindowMoveToFile(1)<CR>
  nnoremap <buffer> <silent> <Space>       :call <SID>WindowShowInfo()<CR>
  nnoremap <buffer> <silent> <F1>          :call <SID>WindowToggleHelpText()<CR>
  nnoremap <buffer> <silent> +             :silent! foldopen<CR>
  nnoremap <buffer> <silent> -             :silent! foldclose<CR>
  nnoremap <buffer> <silent> *             :silent! %foldopen!<CR>
  nnoremap <buffer> <silent> =             :silent! %foldclose<CR>
  nnoremap <buffer> <silent> <kPlus>       :silent! foldopen<CR>
  nnoremap <buffer> <silent> <kMinus>      :silent! foldclose<CR>
  nnoremap <buffer> <silent> <kMultiply>   :silent! %foldopen!<CR>
  nnoremap <buffer> <silent> q             :close<CR>

  " Insert mode mappings
  inoremap <buffer> <silent> <CR>          <C-o>:call <SID>WindowJumpToTag('useopen')<CR>
  inoremap <buffer> <silent> <Return>      <C-o>:call <SID>WindowJumpToTag('useopen')<CR>
  inoremap <buffer> <silent> o             <C-o>:call <SID>WindowJumpToTag('newwin')<CR>
  inoremap <buffer> <silent> p             <C-o>:call <SID>WindowJumpToTag('preview')<CR>
  inoremap <buffer> <silent> P             <C-o>:call <SID>WindowJumpToTag('prevwin')<CR>
  inoremap <buffer> <silent> t             <C-o>:call <SID>WindowJumpToTag('checktab')<CR>
  inoremap <buffer> <silent> <C-t>         <C-o>:call <SID>WindowJumpToTag('newtab')<CR>
  inoremap <buffer> <silent> <2-LeftMouse> <C-o>:call <SID>WindowJumpToTag('useopen')<CR>
  inoremap <buffer> <silent> s             <C-o>:call <SID>WindowChangeSort('toggle', '')<CR>
  inoremap <buffer> <silent> u             <C-o>:call <SID>WindowUpdateFile()<CR>
  inoremap <buffer> <silent> d             <C-o>:call <SID>WindowRemoveFile()<CR>
  inoremap <buffer> <silent> x             <C-o>:call <SID>WindowZoom()<CR>
  inoremap <buffer> <silent> [[            <C-o>:call <SID>WindowMoveToFile(-1)<CR>
  inoremap <buffer> <silent> <BS>          <C-o>:call <SID>WindowMoveToFile(-1)<CR>
  inoremap <buffer> <silent> ]]            <C-o>:call <SID>WindowMoveToFile(1)<CR>
  inoremap <buffer> <silent> <Tab>         <C-o>:call <SID>WindowMoveToFile(1)<CR>
  inoremap <buffer> <silent> <Space>       <C-o>:call <SID>WindowShowInfo()<CR>
  inoremap <buffer> <silent> <F1>          <C-o>:call <SID>WindowToggleHelpText()<CR>
  inoremap <buffer> <silent> +             <C-o>:silent! foldopen<CR>
  inoremap <buffer> <silent> -             <C-o>:silent! foldclose<CR>
  inoremap <buffer> <silent> *             <C-o>:silent! %foldopen!<CR>
  inoremap <buffer> <silent> =             <C-o>:silent! %foldclose<CR>
  inoremap <buffer> <silent> <kPlus>       <C-o>:silent! foldopen<CR>
  inoremap <buffer> <silent> <kMinus>      <C-o>:silent! foldclose<CR>
  inoremap <buffer> <silent> <kMultiply>   <C-o>:silent! %foldopen!<CR>
  inoremap <buffer> <silent> q             <C-o>:close<CR>

  " Map single left mouse click if the user wants this functionality
  if g:tlist_use_single_click == 1
    " Contributed by Bindu Wavell
    " attempt to perform single click mapping, it would be much
    " nicer if we could nnoremap <buffer> ... however vim does
    " not fire the <buffer> <LeftMouse> when you use the mouse
    " to enter a buffer.
    let clickmap = ':if bufname("%") =~ "__Tag_List__" <bar> ' .
          \ 'call <SID>WindowJumpToTag("useopen") ' .
          \ '<bar> endif <CR>'
    let maparg = maparg('<LeftMouse>', 'n')
    if maparg == ''
      " No mapping for leftmouse
      exe ':nnoremap <silent> <LeftMouse> <LeftMouse>' . clickmap
    else
      " We have a mapping
      exe ':nnoremap <silent> <LeftMouse> <LeftMouse>' .
            \ substitute(substitute(maparg, '|', '<bar>', 'g'),
            \ '\c^<LeftMouse>', '', '') . clickmap
    endif
  endif

  " Define the taglist autocommands
  augroup TagListAutoCmds
    autocmd!
    " Display the tag prototype for the tag under the cursor.
    autocmd CursorMoved __Tag_List__ call s:WindowShowInfo()
    " Adjust the Vim window width when taglist window is closed
    autocmd BufUnload __Tag_List__ call s:WindowPostCloseCleanup()
    " Exit Vim itself if only the taglist window is present (optional)
    if g:tlist_exit_onlywindow
      autocmd BufEnter __Tag_List__ nested call s:WindowExitOnlyWindow()
    endif
    " Clear command line when leaving the taglist window
    autocmd WinLeave __Tag_List__ echo
    " Close the fold for this buffer when leaving the buffer
    if g:tlist_auto_close_file_fold
      autocmd BufEnter * silent call s:WindowOpenFileFold(expand('<abuf>'))
    endif
    if !g:tlist_process_file_always &&
          \ (!has('gui_running') || !g:tlist_show_menu)
      " Auto refresh the taglist window
      autocmd BufEnter,BufWritePost,FileChangedShellPost * call taglist#RefreshCurrentBuffer()
      " When a buffer is deleted, remove the file from the taglist
      autocmd BufDelete * silent call taglist#BufferRemoved(expand('<afile>:p'))
    endif
    autocmd TabEnter * silent call s:WindowRefreshFolds()
  augroup END

  let s:tlist_window_initialized = 1
endfunction

" Create a new taglist window. If it is already open, jump to it
function! s:WindowCreate()
  call s:LogMsg('WindowCreate()')
  " Create a new window. If user prefers a horizontal window, then open
  " a horizontally split window. Otherwise open a vertically split
  " window
  if g:tlist_use_horiz_window
    " Open a horizontally split window
    let win_dir = 'botright'
    " Horizontal window height
    let win_size = g:tlist_win_height
  else
    if s:tlist_winsize_chgd == -1
      " Open a vertically split window. Increase the window size, if
      " needed, to accomodate the new window
      if g:tlist_inc_win_width &&
            \ &columns < (80 + g:tlist_win_width)
        " Save the original window position
        let s:tlist_pre_winx = getwinposx()
        let s:tlist_pre_winy = getwinposy()
        " one extra column is needed to include the vertical split
        let &columns= &columns + g:tlist_win_width + 1
        let s:tlist_winsize_chgd = 1
      else
        let s:tlist_winsize_chgd = 0
      endif
    endif
    if g:tlist_use_right_window
      " Open the window at the rightmost place
      let win_dir = 'botright vertical'
    else
      " Open the window at the leftmost place
      let win_dir = 'topleft vertical'
    endif
    let win_size = g:tlist_win_width
  endif
  " If the tag listing temporary buffer already exists, then reuse it.
  " Otherwise create a new buffer
  let bufnum = bufnr(g:TagList_title)
  if bufnum == -1
    " Create a new buffer
    let wcmd = g:TagList_title
  else
    " Edit the existing buffer
    let wcmd = '+buffer' . bufnum
  endif
  " Create the taglist window
  exe 'silent! keepalt ' . win_dir . ' ' . win_size . 'split ' . wcmd
  " Overcome a weird behavor when Vim GUI window is maximized
  if !g:tlist_use_horiz_window && winwidth(0) != win_size
    exe 'silent! vertical resize ' . win_size
  endif
  " Save the new window position
  let s:tlist_winx = getwinposx()
  let s:tlist_winy = getwinposy()
  " Initialize the taglist window
  call s:WindowInit()
endfunction

" Close the taglist window and adjust the Vim window width
function! s:WindowPostCloseCleanup()
  call s:LogMsg('WindowPostCloseCleanup()')
  " Mark all the files as not visible
  " This will also release all suppressed files
  for fname in keys(s:tlist_file_cache)
    let s:tlist_file_cache[fname].visible = 0
  endfor
  " Remove the taglist autocommands
  silent! autocmd! TagListAutoCmds
  " Remove the left mouse click mapping if it was setup initially
  if g:tlist_use_single_click
    if hasmapto('<LeftMouse>')
      nunmap <LeftMouse>
    endif
  endif
  if g:tlist_use_horiz_window || g:tlist_inc_win_width == 0 ||
        \ s:tlist_winsize_chgd != 1 ||
        \ &columns < (80 + g:tlist_win_width)
    " No need to adjust window width if using horizontally split taglist
    " window or if columns is less than 101 or if the user chose not to
    " adjust the window width
  else
    " If the user didn't manually move the window, then restore the window
    " position to the pre-taglist position
    if s:tlist_pre_winx != -1 && s:tlist_pre_winy != -1 &&
          \ getwinposx() == s:tlist_winx &&
          \ getwinposy() == s:tlist_winy
      exe 'winpos ' . s:tlist_pre_winx . ' ' . s:tlist_pre_winy
    endif
    " Adjust the Vim window width
    let &columns -= g:tlist_win_width + 1
  endif
  let s:tlist_winsize_chgd = -1
  let s:tlist_window_initialized = 0
endfunction

" Add base menu
function! s:MenuAddBaseMenu()
  call s:LogMsg('Adding the base menu')
  " Add main menu
  an <silent> T&ags.Toggle\ Tag\ List     :call taglist#WindowToggle()<CR>
  an <silent> T&ags.Jump\ to\ Tag         :call taglist#JumpToTagByLine()<CR>
  an T&ags.-SEP0-                         :
  an <silent> T&ags.Refresh\ Menu         :call <SID>MenuRefresh()<CR>
  an <silent> T&ags.Sort\ Menu\ By.Name   :call <SID>MenuChangeSort('set', 'name')<CR>
  an <silent> T&ags.Sort\ Menu\ By.Order  :call <SID>MenuChangeSort('set', 'order')<CR>
  " Add popup menu
  if &mousemodel =~ 'popup'
    an PopUp.-TAGLIST-SEP-                        :
    an <silent> PopUp.T&ags.Jump\ to\ Tag         :call taglist#JumpToTagByLine()<CR>
    an PopUp.T&ags.-SEP0-                         :
    an <silent> PopUp.T&ags.Refresh\ Menu         :call <SID>MenuRefresh()<CR>
    an <silent> PopUp.T&ags.Sort\ Menu\ By.Name   :call <SID>MenuChangeSort('set', 'name')<CR>
    an <silent> PopUp.T&ags.Sort\ Menu\ By.Order  :call <SID>MenuChangeSort('set', 'order')<CR>
  endif
endfunction

" Get the menu command for the specified tag type
" fidx  - File type index
" ftype - File type
" flag  - Tag flag
function! s:MenuGetTagTypeCmd(fname, ftype, flag)
  " Number of tag entries for this flag
  if !has_key(s:tlist_file_cache[a:fname].flags, a:flag)
    return ''
  endif
  " If the tag type name contains space characters, escape it. This
  " will be used to create the menu entries.
  let flag_fullname = s:tlist_filetype_settings[a:ftype].flags[a:flag]
  let flag_fullname = escape(substitute(flag_fullname, '&', '&&', 'g'), ' .\|')
  " Number of tags under this flag
  let tcnt = len(s:tlist_file_cache[a:fname].flags[a:flag].tags)
  let mcmd = ''
  " Create the menu items for the tags.
  " Depending on the number of tags of this type, split the menu into
  " multiple sub-menus, if needed.
  if tcnt > g:tlist_max_submenu_items
    let tidx = 0
    while tidx < tcnt
      let f_tidx = tidx + g:tlist_max_submenu_items - 1
      if f_tidx >= tcnt
        let f_tidx = tcnt - 1
      endif
      " Extract the first and last tag names
      let fst_tag = s:tlist_file_cache[a:fname].flags[a:flag].tags[tidx].tag_name
      let lst_tag = s:tlist_file_cache[a:fname].flags[a:flag].tags[f_tidx].tag_name
      " Truncate the names if they are greater than the max length
      let fst_tag = strpart(fst_tag, 0, g:tlist_max_tag_length)
      let lst_tag = strpart(lst_tag, 0, g:tlist_max_tag_length)
      " Escape illegal characters
      let fst_tag = escape(substitute(fst_tag, '&', '&&', 'g'), ' .\|')
      let lst_tag = escape(substitute(lst_tag, '&', '&&', 'g'), ' .\|')
      " Form the menu command prefix
      let m_prefix = 'anoremenu <silent> T\&ags.' . flag_fullname .
            \ '.' . fst_tag . '\ \.\.\.\ ' . lst_tag . '.'
      " Character prefix used to number the menu items (hotkey)
      let m_prefix_idx = 0
      while tidx <= f_tidx
        let tname = s:tlist_file_cache[a:fname].flags[a:flag].tags[tidx].tag_name
        let tname = escape(substitute(tname, '&', '&&', 'g'), ' .\|')
        let mcmd = mcmd . m_prefix . '\&' .
              \ s:tlist_menu_prefix_chars[m_prefix_idx] . '\.\ ' .
              \ tname . ' :call <SID>MenuJumpToTag(' .
              \ "'" . a:flag . "', " . tidx . ')<CR>|'
        let m_prefix_idx += 1
        let tidx += 1
      endwhile
    endwhile
  else
    " Character prefix used to number the menu items (hotkey)
    let m_prefix_idx = 0
    let m_prefix = 'anoremenu <silent> T\&ags.' . flag_fullname . '.'
    let tidx = 0
    while tidx < tcnt
      let tname = s:tlist_file_cache[a:fname].flags[a:flag].tags[tidx].tag_name
      let tname = escape(substitute(tname, '&', '&&', 'g'), ' .\|')
      let mcmd = mcmd . m_prefix . '\&' .
            \ s:tlist_menu_prefix_chars[m_prefix_idx] . '\.\ ' .
            \ tname . ' :call <SID>MenuJumpToTag(' .
            \ "'" . a:flag . "', " . tidx . ')<CR>|'
      let m_prefix_idx += 1
      let tidx += 1
    endwhile
  endif
  return mcmd
endfunction

" Update the taglist menu with the tags for the specified file
function! s:MenuRefreshFile(fname)
  call s:LogMsg('Refreshing the tag menu for ' . a:fname)
  anoremenu T&ags.-SEP2- :
  exe s:tlist_file_cache[a:fname]['mcmd']
  " Update the popup menu (if enabled)
  if &mousemodel =~ 'popup'
    anoremenu PopUp.T&ags.-SEP1- :
    let cmd = substitute(s:tlist_file_cache[a:fname]['mcmd'], ' T\\&ags\.',
          \ ' PopUp.T\\\&ags.', 'g')
    exe cmd
  endif
  " The taglist menu is not empty now
  let s:tlist_menu_empty = 0
endfunction

" Add the taglist menu
function! s:MenuUpdateFile(clear_menu)
  if !has('gui_running')
    " Not running in GUI mode
    return
  endif
  call s:LogMsg('Updating the tag menu, clear_menu = ' . a:clear_menu)
  " Remove the tags menu
  if a:clear_menu
    call s:MenuRemoveFile()
  endif
  " Skip buffers with 'buftype' set to nofile, nowrite, quickfix or help
  if &buftype != ''
    return
  endif
  let fname = fnamemodify(bufname('%'), ':p')
  let ftype = s:GetBufferFileType(bufname('%'))
  " If the file doesn't support tag listing, skip it
  if s:SkipFile(fname, ftype)
    return
  endif
  if has_key(s:tlist_file_cache,fname)
    if s:tlist_file_cache[fname].visible == -1
      return
    endif
  endif
  if !has_key(s:tlist_file_cache, fname) ||
        \ !s:tlist_file_cache[fname].valid
    " Process the tags for the file
    if !s:ProcessFile(fname, ftype)
      return
    endif
  endif
  let fname_txt = escape(fnamemodify(bufname('%'), ':t'), ' .')
  let fname_txt = substitute(fname_txt, '&', '&&', 'g')
  if fname_txt != ''
    anoremenu T&ags.-SEP1- :
    exe 'anoremenu T&ags.' .  fname_txt . ' <Nop>'
  endif
  if empty(s:tlist_file_cache[fname].flags)
    return
  endif
  if s:tlist_file_cache[fname].mcmd != ''
    " Update the menu with the cached command
    call s:MenuRefreshFile(fname)
    return
  endif
  " We are going to add entries to the tags menu, so the menu won't be
  " empty
  let s:tlist_menu_empty = 0
  let mcmd = ''
  " Determine whether the tag type name needs to be added to the menu
  " If more than one tag type is present in the taglisting for a file,
  " then the tag type name needs to be present
  for flag in keys(s:tlist_filetype_settings[ftype].flags)
    if has_key(s:tlist_file_cache[fname].flags, flag)
      let mcmd .= s:MenuGetTagTypeCmd(fname, ftype, flag)
    endif
  endfor
  " Cache the menu command for reuse
  let s:tlist_file_cache[fname].mcmd = mcmd
  " Update the menu
  call s:MenuRefreshFile(fname)
endfunction

" Remove the tags displayed in the tags menu
function! s:MenuRemoveFile()
  if !has('gui_running') || s:tlist_menu_empty
    return
  endif
  call s:LogMsg('Removing the tags menu for a file')
  " Cleanup the Tags menu
  silent! unmenu T&ags
  if &mousemodel =~ 'popup'
    silent! unmenu PopUp.T&ags
  endif
  " Add a dummy menu item to retain teared off menu
  noremenu T&ags.Dummy l
  silent! unmenu! T&ags
  if &mousemodel =~ 'popup'
    silent! unmenu! PopUp.T&ags
  endif
  call s:MenuAddBaseMenu()
  " Remove the dummy menu item
  unmenu T&ags.Dummy
  let s:tlist_menu_empty = 1
endfunction

" Refresh the taglist menu
function! s:MenuRefresh()
  call s:LogMsg('Refreshing the tags menu')
  let fname = fnamemodify(bufname('%'), ':p')
  if has_key(s:tlist_file_cache, fname)
    " Invalidate the cached menu command
    let s:tlist_file_cache[fname].mcmd = ''
  endif
  " Update the taglist, menu and window
  call taglist#RefreshCurrentBuffer()
endfunction

" Change the sort order of the tag listing
" action == 'toggle', toggle sort from name to order and vice versa
" action == 'set', set the sort order to sort_type
function! s:MenuChangeSort(action, sort_type)
  call s:LogMsg('MenuChangeSort(action = ' . a:action .
        \ ', sort_type = ' . a:sort_type . ')')
  let fname = fnamemodify(bufname('%'), ':p')
  if fname == ''
    return
  endif
  if a:action ==# 'toggle'
    let sort_type = s:tlist_file_cache[fname].sortby
    " Toggle the sort order from 'name' to 'order' and vice versa
    let s:tlist_file_cache[fname].sortby =
          \ (sort_type ==# 'name') ? 'order' : 'name'
  else
    let s:tlist_file_cache[fname].sortby = a:sort_type
  endif
  " Invalidate the tags listed for this file
  let s:tlist_file_cache[fname].valid = 0
  call s:MenuRemoveFile()
  call taglist#RefreshCurrentBuffer()
endfunction

" Jump to the selected tag
function! s:MenuJumpToTag(flag, tidx)
  let fname = fnamemodify(bufname('%'), ':p')
  if !has_key(s:tlist_file_cache, fname)
    return
  endif
  let tagpat = s:tlist_file_cache[fname].flags[a:flag].tags[a:tidx].tag_pattern
  if tagpat == ''
    return
  endif
  " Add the current cursor position to the jump list, so that user can
  " jump back using the ' and ` marks.
  mark '
  silent call search(tagpat, 'w')
  " Bring the line to the middle of the window
  normal! z.
  " If the line is inside a fold, open the fold
  if foldclosed('.') != -1
    .foldopen
  endif
endfunction
" }}}1

" Restore cpotions.
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: set fdm=marker fdl=0:
