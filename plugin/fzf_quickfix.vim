scriptencoding utf-8

" Copyright (c) 2018-2019 Filip Szymański and Arad Zulti. All rights reserved.
" Use of this source code is governed by an MIT license that can be
" found in the LICENSE file.

if !exists('g:fzf_quickfix_syntax_on')
  let g:fzf_quickfix_syntax_on = 1
endif

execute 'command! -bang' get(g:, 'fzf_command_prefix', '')
      \ . 'Quickfix call fzf_quickfix#run("<bang>" ==# "!")'

