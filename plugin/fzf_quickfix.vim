scriptencoding utf-8

" Copyright (c) 2018-2019 Filip Szymański and Arad Zulti. All rights reserved.
" Use of this source code is governed by an MIT license that can be
" found in the LICENSE file.

if exists('g:loaded_fzf_quickfix')
  finish
endif
let g:loaded_fzf_quickfix = 1

let s:keep_cpo = &cpoptions
set cpoptions&vim

if !exists('g:fzf_quickfix_syntax_on')
  let g:fzf_quickfix_syntax_on = 1
endif

execute 'command! -bang' get(g:, 'fzf_command_prefix', '')
      \ . 'Quickfix call fzf_quickfix#run("<bang>" ==# "!")'

let &cpoptions = s:keep_cpo
unlet s:keep_cpo

" vim: et sw=2 ts=2
