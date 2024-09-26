function! indentree#comp_style(ArgLead, CmdLine, CursorPos) abort
  let style_names = keys(g:indentree_styles)
  if a:ArgLead == ''
    return style_names
  else
    return filter(style_names, {idx, style -> style =~ a:ArgLead})
  endif
endfunction

function! indentree#set_style(style) abort
  if index(keys(g:indentree_styles), a:style) == -1
    let available_styles = join(sort(keys(g:indentree_styles)), ', ')
    echohl WarningMsg | echo $'Available styles are {available_styles}.' | echohl None
    return
  endif
  let g:indentree_style = a:style
  let g:indentree_whitespace = g:indentree_styles[a:style][0]
  let g:indentree_bar = g:indentree_styles[a:style][1]
  let g:indentree_el = g:indentree_styles[a:style][2]
  let g:indentree_tee = g:indentree_styles[a:style][3]
endfunction

function! s:get_parent(past_lines, depth) abort
  let i = len(a:past_lines) - 1
  while i >= 0
    let line = a:past_lines[i]
    if a:depth - line['depth'] == 1
      return line['no']
    endif
    let i -= 1
  endwhile
  return 0
endfunction

function! s:indent_to_nodes(lines) abort
  let nodes = [{'no': 0, 'name': v:null, 'depth': -1, 'parent': v:null, 'tree_part': v:null}]
  let line_no = 1
  for line in a:lines
    let name = substitute(line, '^' .. s:tab_white .. '*', '', '')
    let depth = (strdisplaywidth(line) - strdisplaywidth(name)) / &tabstop
    let node = {'no': line_no, 'name': name, 'depth': depth, 'tree_part': ''}
    let node['parent'] = s:get_parent(nodes, depth)
    call add(nodes, node)
    let line_no += 1
  endfor
  return nodes
endfunction

function! s:ancestor_line(nodes, node) abort
  let ancestors = []
  let ancestor = a:nodes[a:node['parent']]
  while ancestor['depth'] >= 1
    call add(ancestors, ancestor)
    let ancestor = a:nodes[ancestor['parent']]
  endwhile

  let ancestors = sort(ancestors, {a1, a2 -> a1['no'] - a2['no']})
  let line = ''
  let added_depth = 0
  for ancestor in ancestors
    if stridx(ancestor['tree_part'], g:indentree_el) >= 0
      let line .= repeat(g:indentree_whitespace, ancestor['depth'] - added_depth)
    else
      let line .= g:indentree_bar .. repeat(g:indentree_whitespace, ancestor['depth'] - added_depth - 1)
    endif
    let added_depth = ancestor['depth']
  endfor

  return line
endfunction

function! s:nodes_to_tree(nodes) abort
  let tree = []
  for node in a:nodes[1:]
    let children = filter(a:nodes[1:], {idx, n -> n['parent'] == node['no']})
    for child in children[:-2]
      let child['tree_part'] = s:ancestor_line(a:nodes, child) .. g:indentree_tee
    endfor
    if len(children) >= 1
      let children[-1]['tree_part'] = s:ancestor_line(a:nodes, children[-1]) .. g:indentree_el
    endif
  endfor

  for node in a:nodes[1:]
    call add(tree, node['tree_part'] .. node['name'])
  endfor

  return tree
endfunction

function s:get_tab_scaffold(lines) abort
  let scaff_num = min(mapnew(a:lines, {_, line -> len(matchstr(line, '^' .. s:tab_white .. '*'))}))
  return join([s:tab_white]->repeat(scaff_num), '')
endfunction

function! indentree#convert(range, line1, line2) abort
  if a:range == -1
    " when calling this function from visual mode, -1 is set for a:range.
    let start = getpos("'<")[1]
    let end = getpos("'>")[1]
  else
    let start = a:line1
    let end = a:line2
  endif
  let lines = getline(start, end)
  let s:tab_white = &expandtab ? " " : "\t"
  let scaffold = s:get_tab_scaffold(lines)
  call map(lines, {_, line -> substitute(line, '^' .. scaffold, '', '')})
  let nodes = s:indent_to_nodes(lines)
  let tree = s:nodes_to_tree(nodes)
  for i in range(0, end - start)
    let line_no = start + i
    call setline(line_no, scaffold .. tree[i])
  endfor
endfunction

function! indentree#revert(range, line1, line2) abort
  if a:range == -1
    " when calling this function from visual mode, -1 is set for a:range.
    let start = getpos("'<")[1]
    let end = getpos("'>")[1]
  else
    let start = a:line1
    let end = a:line2
  endif
  let lines = getline(start, end)
  let s:tab_white = &expandtab ? " " : "\t"
  let scaffold = s:get_tab_scaffold(lines)
  call map(lines, {_, line -> substitute(line, '\('
        \ .. g:indentree_whitespace .. '\|'
        \ .. g:indentree_bar .. '\|'
        \ .. g:indentree_el .. '\|'
        \ .. g:indentree_tee
        \ .. '\)', s:tab_white, 'g')})
  for i in range(0, end - start)
    let line_no = start + i
    call setline(line_no, scaffold .. lines[i])
  endfor
endfunction
