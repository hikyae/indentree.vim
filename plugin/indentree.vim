let s:save_cpo = &cpoptions
set cpoptions&vim

if exists("g:loaded_indentree") && g:loaded_indentree
  finish
endif
let g:loaded_indentree = 1

if !exists('g:indentree_style')
  let g:indentree_style = 'unix'
endif

if !exists('g:indentree_styles')
  let g:indentree_styles = {
        \ 'unix':       ['    ', '│   ', '└── ', '├── '],
        \ 'unix_ascii': ['    ', '|   ', '`-- ', '|-- '],
        \ 'dos':        ['    ', '│   ', '└───', '├───'],
        \ 'dos_ascii':  ['    ', '|   ', '\---', '+---']
        \ }
endif

if index(keys(g:indentree_styles), g:indentree_style) != -1
  call indentree#set_style(g:indentree_style)
endif

" you can also custom tree characters by defining g:indentree_styles in your .vimrc file
" example
" let g:indentree_style = 'custom'
" let g:indentree_styles = {
"       \ 'unix':       ['    ', '│   ', '└── ', '├── '],
"       \ 'unix_ascii': ['    ', '|   ', '`-- ', '|-- '],
"       \ 'dos':        ['    ', '│   ', '└───', '├───'],
"       \ 'dos_ascii':  ['    ', '|   ', '\---', '+---'],
"       \ 'custom':     ['  ', '| ', '`-', '|-']
"       \ }

vnoremap <silent> <Plug>(indentree-convert) <Esc>:call indentree#convert(-1, 0, 0)<CR>
command! -range=% IndentreeConvert call indentree#convert(<range>, <line1>, <line2>)
command! -nargs=1 -complete=customlist,indentree#comp_style IndentreeStyle call indentree#set_style(<q-args>)

let &cpoptions = s:save_cpo
unlet s:save_cpo
