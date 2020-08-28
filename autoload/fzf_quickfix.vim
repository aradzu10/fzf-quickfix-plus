scriptencoding utf-8

" Copyright (c) 2018-2019 Filip Szymański and Arad Zulti. All rights reserved.
" Use of this source code is governed by an MIT license that can be
" found in the LICENSE file.

function! s:error_type(type, nr) abort
  if a:type ==? 'W'
    let l:msg = ' warning'
  elseif a:type ==? 'I'
    let l:msg = ' info'
  elseif a:type ==? 'E' || (a:type ==# "\0" && a:nr > 0)
    let l:msg = ' error'
  elseif a:type ==# "\0" || a:type ==# "\1"
    let l:msg = ''
  else
    let l:msg = ' ' . a:type
  endif

  if a:nr <= 0
    return l:msg
  endif

  return printf('%s %3d', l:msg, a:nr)
endfunction

function! s:format_item(item) abort
  return (a:item.bufnr ? bufname(a:item.bufnr) : '')
        \ . ':' . (a:item.lnum  ? a:item.lnum : '')
        \ . (a:item.col ? ' col ' . a:item.col : '')
        \ . s:error_type(a:item.type, a:item.nr)
        \ . ':' . substitute(a:item.text, '\v^\s*', ' ', '')
endfunction

function! s:quickfix_sink(err) abort
  let l:match = matchlist(a:err, '\v^([^:]*)\:(\d+)?%(\scol\s(\d+))?.*\:')[1:3]
  if empty(l:match) || empty(l:match[0])
    return
  endif

  if empty(l:match[1]) && (bufnr(l:match[0]) == bufnr('%'))
    return
  endif

  let l:lnum = empty(l:match[1]) ? 1 : str2nr(l:match[1])
  let l:col = empty(l:match[2]) ? 1 : str2nr(l:match[2])

  execute 'buffer' bufnr(l:match[0])
  call cursor(l:lnum, l:col)
  normal! zvzz
endfunction

function! s:syntax() abort
  if has('syntax') && exists('g:syntax_on')
    syntax match fzfQfFileName '^[^:]*' nextgroup=fzfQfSeparator
    syntax match fzfQfSeparator ':' nextgroup=fzfQfLineNr contained
    syntax match fzfQfLineNr '[^:]*' contained contains=fzfQfError
    syntax match fzfQfError 'error' contained

    highlight default link fzfQfFileName Directory
    highlight default link fzfQfLineNr LineNr
    highlight default link fzfQfError Error
  endif
endfunction

function! fzf_quickfix#run(...) abort
  call fzf#run(fzf#wrap({
        \ 'source': map(a:1 ? getloclist(0) : getqflist(), 's:format_item(v:val)'),
        \ 'sink': function('s:quickfix_sink'),
        \ 'options': printf('--prompt="%s> "', (a:1 ? 'LocList' : 'QfList'))
        \ }))

  if g:fzf_quickfix_syntax_on
    call s:syntax()
  endif
endfunction

