# fzf :heart: quickfix

FZF-Quickfix-plus is a plugin design to quickly navigate quickfix and location list window.
It provide the default functionality of FZF search:
- Open multiple results.
- Open in new tab, split and vsplit.


![](https://user-images.githubusercontent.com/25827968/63228948-0d8ff100-c1fb-11e9-95d8-e5df195ba18e.png)

## Requirements
- [fzf](https://github.com/junegunn/fzf)

## Installation

Using the (Neo)vim built-in (kind of) plugin manager:

```sh
$ cd path/to/pack/foo/start
$ git clone https://github.com/aradzu10/fzf-quickfix-plus.git
```

Using your favorite (Neo)vim plugin manager:

```vim
Plug 'aradzu10/fzf-quickfix-plus', {'on': 'Quickfix'}

nnoremap <Leader>q :Quickfix<CR>
nnoremap <Leader>l :Quickfix!<CR>

```

## Documentation

For more information, see `:help fzf_quickfix.txt`.

## License

MIT
