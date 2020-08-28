scriptencoding utf-8

" Copyright (c) 2018-2019 Filip Szymański and Arad Zulti. All rights reserved.
" Use of this source code is governed by an MIT license that can be
" found in the LICENSE file.

let s:keep_cpo = &cpoptions
set cpoptions&vim


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

function! s:quickfix_sink(actions, lines) abort
    if len(a:lines) < 2
        return
    endif

    let l:key = remove(a:lines, 0)
    let l:cmd = get(a:actions, l:key, 'e')

    for line in a:lines
        let l:match = matchlist(line, '\v^([^:]*)\:(\d+)?%(\scol\s(\d+))?.*\:')[1:3]
        if empty(l:match) || empty(l:match[0])
            continue
        endif

        if empty(l:match[1]) && (bufnr(l:match[0]) == bufnr('%'))
            continue
        endif

        let l:lnum = empty(l:match[1]) ? 1 : str2nr(l:match[1])
        let l:col = empty(l:match[2]) ? 1 : str2nr(l:match[2])

        execute l:cmd fnameescape(l:match[0])
        call cursor(l:lnum, l:col)
        normal! zvzz
    endfor
endfunction

function! s:syntax() abort
    if has('syntax') && g:fzf_quickfix_syntax_on
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
    let opts = {
        \ 'source': map(a:1 ? getloclist(0) : getqflist(), 's:format_item(v:val)'),
        \ 'options': ['--multi', '--prompt', a:1 ? 'Loc>' : 'Qf>']
        \ }
    let opts = fzf#wrap('quickfix', opts)
    function! opts.sink(lines) dict
        return s:quickfix_sink(self._action, a:lines)
    endfunction
    let opts['sink*'] = remove(opts, 'sink')
    call fzf#run(opts)

    call s:syntax()
endfunction


let &cpoptions = s:keep_cpo
unlet s:keep_cpo
