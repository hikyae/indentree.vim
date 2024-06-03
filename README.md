# indentree.vim

Convert whitespace-indented structure into tree with box-drawing characters like tree command

![demo](https://user-images.githubusercontent.com/32293016/265293143-7413d1e8-7f0b-4a67-adde-1501781f813b.gif)

## Installation

### Pathogen (https://github.com/tpope/vim-pathogen)
```bash
git clone https://github.com/hikyae/indentree.vim ~/.vim/bundle/indentree.vim
```

### Vundle (https://github.com/gmarik/vundle)
```vim
Plugin 'hikyae/indentree.vim'
```

### NeoBundle (https://github.com/Shougo/neobundle.vim)
```vim
NeoBundle 'hikyae/indentree.vim'
```

### Vim-Plug (https://github.com/junegunn/vim-plug)
```vim
Plug 'hikyae/indentree.vim'
```

### Vim8 Native Plugin Manager (https://vimhelp.org/repeat.txt.html#packages)
```bash
git clone https://github.com/hikyae/indentree.vim.git ~/.vim/pack/plugins/start/indentree.vim
```

## Settings

You can set the mapping and variables in your .vimrc file

- Keymap for converting selected text in visual mode

```vim
vmap <Leader>I <Plug>(indentree-convert)
```

- Styles for tree structure

```vim
let g:indentree_style = 'unix' " default. like `tree` in Unix
let g:indentree_style = 'unix_ascii' " like `tree --charset=ascii` in Unix
let g:indentree_style = 'dos' " like `tree` in MS-DOS
let g:indentree_style = 'dos_ascii' " like `tree /A` in MS-DOS
```

- You can also custom tree characters by defining g:indentree_styles in your .vimrc file

```vim
" example
" let g:indentree_style = 'custom'
" let g:indentree_styles = {
"       \ 'unix':       ['    ', '│   ', '└── ', '├── '],
"       \ 'unix_ascii': ['    ', '|   ', '`-- ', '|-- '],
"       \ 'dos':        ['    ', '│   ', '└───', '├───'],
"       \ 'dos_ascii':  ['    ', '|   ', '\---', '+---'],
"       \ 'custom':     ['  ', '| ', '`-', '|-']
"       \ }
```

## Usage

Represent the directory structure with whitespace-based indentation.

This plugin uses 'tabstop' option to determine the depth of each node.

Though you can `set expandtab`, make sure to represent the structure using spaces with 'tabstop' width.

- Command line

```vim
" convert all text in the buffer
:IndentreeConvert
" convert text within a specified range
:5,15IndentreeConvert
" switch to unix-like style
:IndentreeStyle unix
" switch to unix-like style with ascii option
:IndentreeStyle unix_ascii
" switch to dos-like style
:IndentreeStyle dos
" switch to dos-like style with ascii option
:IndentreeStyle dos_ascii
```

- Keymap

Select text in visual mode and type the mapped key
