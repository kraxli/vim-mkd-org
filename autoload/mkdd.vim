
" {{{ SWITCH STATUS OF RANGE
function! mkdd#NumberedList(...) range
  " or simply use !cat -n on selected range
  if a:0 != 0 | let style=a:1 | else | let style='.' | endif
  let line_start = getpos("'<")[1]
  let line_end = getpos("'>")[1]

  for num in range(line_start, line_end)
    let current_line = getline(num)
    let listNum = num - line_start + 1

    " TODO allow for other list types as (capital) roman numbers, (capital) letters
    call setline(num, substitute(current_line, '^\(\s*\)', '\1' . listNum . style . ' ', ''))
  endfor
endfunction
" }}}

" {{{ SWITCH STATUS
" credit: https://github.com/gabrielelana/vim-markdown/blob/master/autoload/markdown.vim

function! mkdd#ToggleStatusUp(...)
  if a:0 == 0 | let lineNum = line('.') | else | let lineNum = a:1 | endif

  let current_line = getline(lineNum)


  " === Header Toggling ===
  " header toggling up
  if match(current_line, '^\s*#\{1,5}\s') >= 0
    call setline(lineNum, substitute(current_line, '^\(\s*#\{1,5}\) \(.*$\)', '\1# \2', '')) | return
  endif

  " header toggling: header level 6 -> header level 1
  if match(current_line, '^\s*#\{6}\s') >= 0
    call setline(lineNum, substitute(current_line, '^\(\s*\)#\{6} \(.*$\)', '\1# \2', '')) | return
  endif


  " === List Toggling ===
  " check box item -> check box item in progress
  if match(current_line, '^\s*[*\-+] \[ \]') >= 0
    if !g:mkdd_use_mkdx | call setline(lineNum, substitute(current_line, '^\(\s*[*\-+]\) \[ \]', '\1 [-]', '')) | return
    else | call mkdx#ToggleCheckboxState() | return
    endif
  endif

  " check box item in progress -> check box item done
  if match(current_line, '^\s*[*\-+] \[-\]') >= 0
    if !g:mkdd_use_mkdx | call setline(lineNum, substitute(current_line, '^\(\s*[*\-+]\) \[-\]', '\1 [x]', '')) | return
    else | call mkdx#ToggleCheckboxState() | return
    endif
  endif

  " check box item done -> no list item
  if match(current_line, '^\s*[*\-+] \[x\]') >= 0
    if !g:mkdd_use_mkdx | call setline(lineNum, substitute(current_line, '\(^\s*\)[*\-+] \[x\] ', '\1', '')) | return
    else | call mkdx#ToggleChecklist() | return
    endif
  endif

  " regular list item -> to do / check box item
  if match(current_line, '^\s*[*\-+] \(\[[x ]\]\)\@!') >= 0
    if !g:mkdd_use_mkdx | call setline(lineNum, substitute(current_line, '^\(\s*[*\-+]\)', '\1 [ ]', '')) | return
    else | call mkdx#ToggleChecklist() | return
    endif
  endif

   " no list item -> regular list item
  if match(current_line, '^\s*[^*\-]') >= 0
    if !g:mkdd_use_mkdx
        call setline(lineNum, substitute(current_line, '^\(\s*[*\-+]\) \[x\]', '\1', ''))
        let prev_line = getline(lineNum-1)
        let nxt_line = getline(lineNum+1)

        if match(prev_line, '^\s*[*\-+]') >= 0
            let listIndicator = substitute(prev_line, '^\s*', '', '')[0]
        elseif match(nxt_line, '^\s*[*\-+]') >= 0
            let listIndicator = substitute(nxt_line, '^\s*', '', '')[0]
        else
          let listIndicator = '-'
        endif

        call setline(lineNum, substitute(current_line, '^\(\s*\)', '\1'. listIndicator .' ', ''))
        return
    else
        call mkdx#ToggleList()
        return
    endif

 endif

  "   " if match(current_line, '^\s*[^*\-+] ') >= 0
  " if match(current_line, '^\s*\S') >= 0
  "   call setline(lineNum, substitute(current_line, '^\(\s*\)\(\S*\) ', '\1- \2', ''))
  "   return
  " endif

endfunction

function! mkdd#ToggleStatusDown(...)
  if a:0 == 0 | let lineNum = line('.') | else | let lineNum = a:1 | endif

  let current_line = getline(lineNum)

  if match(current_line, '^\s*[*\-+] \[ \]') >= 0
    " call setline(lineNum, substitute(current_line, '^\(\s*[*\-+]\) \[ \]', '\1 [-]', ''))
    call setline(lineNum, substitute(current_line, '^\(\s*[*\-+]\) \[ \]', '\1', ''))
    return
  endif
  if match(current_line, '^\s*[*\-+] \[-\]') >= 0
    call setline(lineNum, substitute(current_line, '^\(\s*[*\-+]\) \[-\]', '\1 [ ]', ''))
    return
  endif
  if match(current_line, '^\s*[*\-+] \[x\]') >= 0
    call setline(lineNum, substitute(current_line, '^\(\s*[*\-+]\) \[x\]', '\1 [-]', ''))
    return
  endif
  if match(current_line, '^\s*[*\-+] \(\[[x ]\]\)\@!') >= 0
    call setline(lineNum, substitute(current_line, '^\(\s*\)[*\-+] ', '\1', ''))
    return
  endif

  if match(current_line, '^\s*[^*\-+]') >= 0
    let prev_line = getline(lineNum-1)
    let nxt_line = getline(lineNum+1)

    if match(prev_line, '^\s*[*\-+]') >= 0
      let listIndicator = substitute(prev_line, '^\s*', '', '')[0]
    elseif match(nxt_line, '^\s*[*\-+]') >= 0
      let listIndicator = substitute(nxt_line, '^\s*', '', '')[0]
    else
      let listIndicator = '-'
    endif

    call setline(lineNum, substitute(current_line, '^\(\s*\)', '\1'. listIndicator .' [x] ', ''))
    return
  endif

  if match(current_line, '^\s*#\{1,5}\s') >= 0
    return
  endif
  if match(current_line, '^\s*#\{6}\s') >= 0
    return
  endif

endfunction
" }}}


" {{{ SWITCH STATUS OF RANGE
function! mkdd#ToggleStatusRangeUp() range
  let line_start = getpos("'<")[1]
  let line_end = getpos("'>")[1]

  for num in range(line_start, line_end)
    call mkdd#ToggleStatusUp(num)
  endfor
endfunction

function! mkdd#ToggleStatusRangeDown() range
  let line_start = getpos("'<")[1]
  let line_end = getpos("'>")[1]

  for num in range(line_start, line_end)
    call mkdd#ToggleStatusDown(num)
  endfor
endfunction
" }}}

" {{{ SWITCH HEADER LEVEL
function! mkdd#HeaderIncrease(...)
  if a:0 == 0 | let lineNum = line('.') | else | let lineNum = a:1 | endif

  let current_line = getline(lineNum)

  if match(current_line, '^\s*#\{1,6}\s') >= 0
    call setline(lineNum, substitute(current_line, '^\(\s*#\{1,5}\) \(.*$\)', '\1# \2', ''))
    return
  endif
  if match(current_line, '^\s*[^#]') >= 0
    call setline(lineNum, substitute(current_line, '^\(\s*\)\(.*$\)', '\1# \2', ''))
    return
  endif

endfunction

function! mkdd#HeaderDecrease(...)
  if a:0 == 0 | let lineNum = line('.') | else | let lineNum = a:1 | endif

  let current_line = getline(lineNum)

  if match(current_line, '^\s*#\{2,6}\s') >= 0
    call setline(lineNum, substitute(current_line, '^\(\s*#\{1,5}\)# \(.*$\)', '\1 \2', ''))
    return
  endif
  if match(current_line, '^\s*#\{1}\s') >= 0
    call setline(lineNum, substitute(current_line, '^\(\s*\)# \(.*$\)', '\1\2', ''))
    return
  endif

endfunction

" }}}

" Move line / fold to End {{{
function! mkdd#moveToEnd()
    let line_number = line('.')
    execute "normal! dd G p " . line_number . "G"
endfunction

function! mkdd#moveSelectionToEnd(...) range
  " if a:0 != 0 | let style=a:1 | else | let style='.' | endif
  let visual_start = getpos("'<")[1]
  let visual_end = getpos("'>")[1]

  execute visual_start . "," . visual_end . "m$"
  execute "normal! " . visual_start . "G"

  " for num in range(line_start, line_end)
  "    let current_line = getline(num)
  "    execute current_line . "m$ "
  "    execute "normal! " . current_line . "G"
  "    " let listNum = num - line_start + 1
  "  endfor

endfunction
" }}}

" {{{ MOVE FOLD TO END
function! mkdd#MoveFoldToFileEnd()

  let line_number = line('.')

  " move current line / fold to end of file
  execute ".m $<cr>"
  " or line_number."m $<cr>"
  execute "normal! zM"
  execute line_number

  " restore fold-level instead of following just opening it:
  if foldclosed(line('.')) > -1
      execute "silent! normal ".foldlevel(line('.'))."zo"
  endif
  " execute "normal! zo"

endfunction
" }}}


" {{{
function mkdd#unfold_open_tasks()
  " execute "normal! zM"
  " execute "g/^\\s*[-+\\*]\\{1}\\s\\[\\s\\]/normal! zv"
  " If you want all subfolds opened as well, use normal! zvzO instead

  " execute 'Fp \V\(\^\s\*\[-+*]\{1}\s[\s]\)' -> works
  " execute 'Fp \V\(foo\|todo\)' -> works


  " execute 'Fp ^\\s*[-+\\*]\\{1}\\s\\[\\s\\]' -> works
  execute 'Fp \V\(\^\s\*\[-+*]\{1}\s[\s]\|\s\*#\{1,6}\.\*\)'
endfunction
" }}}

  " execute 'Fp \V\(\^\s\*\[-+*]\{1}\s[\s]\|\s\*#\{1,6}.\*\)'
" |#\\{1,6}.*\\)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Vimwik snippets
"  source: https://vimwiki.github.io/vimwikiwiki/Tips%20and%20Snips.html  "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:fzf_spec = {'options': ['--layout=reverse', '--info=inline', '--exact', '--tiebreak=end'], 'down': '40%'}
let s:query_task_open = '- \[\h{1}\]'
let s:options_ag = '--color --ignore-case  --column'

function! mkdd#findIncompleteTasks(fullscreen)
  if executable('ag')
    let l:file = substitute(expand('%'), '\.', '\\.', 'g')
    let l:options_ag = s:options_ag .  ' --file-search-regex ' . l:file
    call fzf#vim#ag(s:query_task_open, l:options_ag, fzf#vim#with_preview(s:fzf_spec), a:fullscreen)
  else
    lvimgrep /- \[[^xX]\]/ %:p
    lopen
  endif
endfunction

function! mkdd#findAllIncompleteTasks(fullscreen)
  if exists(':Ag')
    " Ag - \[[^xX\-]\]
    " Ag - \[\h{1}\]
    call fzf#vim#ag(s:query_task_open, s:options_ag . ' --md', fzf#vim#with_preview(s:fzf_spec), a:fullscreen)
  else
    VimwikiSearch /- \[[^xX\-]\]/
    lopen
  endif
endfunction


""""""""""""""""""""
"  fzf completion  "
""""""""""""""""""""

function! mkdd#findTags(search_string, exact_match, with_non_vimwiki_tags)

  let l:tag_pattern_base = '\[A-Za-z0-9-_#~@%\]\{2,\}'
  " let l:tag_pattern_base = '\\H\{2,\}'
  let l:newline_string = '\(\?\|\^\|\\h\+\)\\K'

  " let l:string2search = empty(a:search_string) ? '\[a-zA-Z0-9_-\]\{2,\}' : get(a:, 'search_string', '\[a-zA-Z0-9_-\]\{2,\}')
  let l:string2search = empty(a:search_string) ?  l:tag_pattern_base : get(a:, 'search_string',  l:tag_pattern_base)
  let l:fullscreen = get(a:, 'bang', 0) " get(a:, 2, 0)
  let l:exact = get(a:, 'exact_match', 0)
  let l:with_non_vimwiki_tags = get(a:, 'with_non_vimwiki_tags', 0)  " should non-vimwiki-tags be used

  if l:with_non_vimwiki_tags
    let l:mkdd_tag_prefixes = deepcopy(g:mkdd_tag_prefixes)
    " clean out tags which are not supported
    " let l:mkdd_tag_prefixes= substitute(g:mkdd_tag_prefixes, '+', '', '')
    let l:isin = index(l:mkdd_tag_prefixes, '+')
    if l:isin != -1
      remove(l:mkdd_tag_prefixes, l:isin)
    endif

    " let l:tag_prefix = join(split(l:mkdd_tag_prefixes, '\zs'), '\|')
    let l:tag_prefix = join(l:mkdd_tag_prefixes, '\|')
    let l:tag_prefix = substitute(l:tag_prefix, '&', '\\&', 'g')


    if l:exact
      let l:non_vimwiki_tags = '\|'. l:newline_string .'\('. l:tag_prefix .'\)\\H\*'. l:string2search .'\\H\*'  " \R, problem with new line and space before
    else
      " default:
      let l:non_vimwiki_tags = '\|' . l:newline_string . '\('. l:tag_prefix .'\)'.l:tag_pattern_base  " \*
    endif

  " exclude non vimwiki tag identifiers
  else
    let l:non_vimwiki_tags = ''
  endif

  if l:exact
    let l:query = '\[^\(http\)\(s\?\)\]:\\H\*'. l:string2search .'\\H\*:' . l:non_vimwiki_tags
  else
    " default:  (?|^|\h)\K(:\H{2,}:)
    let l:query = '\(' . l:newline_string . ':'. l:tag_pattern_base .':\)' . l:non_vimwiki_tags
    " let l:query = l:newline_string . '\(:'. l:tag_pattern_base .':\)' . l:non_vimwiki_tags
    " let l:query = ':\(\?\=\[A-Za-z\]\{1,\}\)\[\\iA-Z0-9_-\]\{2,\}:' . l:non_vimwiki_tags
    " let l:query = '\[^\(http\)\(s\?\)\]:\(\?\=\[A-Za-z\]\{1,\}\)\\S\{2,\}:' . l:non_vimwiki_tags
    " let l:query = '\[^\(http\)\(s\?\)\]:\\S\{2,\}:' . l:non_vimwiki_tags
  endif

  return l:query
endfunction


function! mkdd#tagsGo2(search_string, bang, exact_match, with_non_vimwiki_tags)

  if !exists(':Ag')
    echo 'ag (silver-searcher required)'
  endif

  let search_ext = "*" . vimwiki#vars#get_wikilocal('ext')


  let l:string2search = a:search_string
  let l:with_non_vimwiki_tags = get(a:, 'with_non_vimwiki_tags', 0)  " should non-vimwiki-tags be used
  let l:exact = get(a:, 'exact_match', 0)
  let l:fullscreen = get(a:, 'bang', 0) " get(a:, 2, 0)

  let l:query = mkdd#findTags(l:string2search, l:exact, l:with_non_vimwiki_tags)

  let l:options_ag = '--md --color --ignore-case ' " --ignore-case --smart-case
  let l:specs = {'sink':  function('zettel#fzf#search_open'), 'options': ['--layout=default', '--info=inline'], 'window': { 'width': 0.9, 'height': 0.6 }}

  return fzf#vim#grep('ag ' . l:options_ag . l:query, 1, fzf#vim#with_preview(l:specs), l:fullscreen)
  " return fzf#vim#grep('ag ' . l:options_ag . l:query,, fzf#vim#with_preview(), l:bang)
endfunction


" go to headers, tags, titles, ...
" :MdoGo2  :Go2
function! mkdd#go2()
endfunction


" TODO: work in progress, function to trigger tag completion and to include in
" tag snippets. How to treat <expr> as input?
function! mkdd#tagCompletion()

  let l:string2search = '' " a:search_string
  let l:exact = 0
  let l:with_non_vimwiki_tags = 0
  let l:query = mkdd#findTags(l:string2search, l:exact, l:with_non_vimwiki_tags)
  let l:options_ag = ' --md --color --ignore-case ' " --ignore-case --smart-case

  return fzf#vim#complete(fzf#wrap('', {'source': "ag " . l:query . l:options_ag, 'options': ['--layout=default', '--info=inline'], 'prefix': mkdd#get_crusor_expression(), 'reducer': { lines ->  s:tag_reducer(lines[0])}, 'window': { 'width': 0.9, 'height': 0.6, 'xoffset': 0.5 }}))

endfunction

function! mkdd#get_crusor_expression()
"     " if getline('.')[col('.')-1] =~ ''
"     "   l:string = ''
"     " else
"     "   l:string = expand("<cword>")
"     " endif

    " get word before cursor
    let l:word_list = split(getline('.')[0:col('.')-1], '')
    let l:string2search = l:word_list == [] ? '\[a-zA-Z0-9_-:\]\{2,\}' : l:word_list[-1]
    " let l:string2search = substitute(l:string2search, ':', '', '')

    return l:string2search
endfunction


function! mkdd#references_reducer(line)
    let pattern2disp = a:line

    " TODO: search for headers, tags, titles and replace accordingly

    " headers
    let pattern2disp = substitute(substitute(pattern2disp, '.md:\d\+:', '', ''), ' ', '', '')
    let pattern2disp = substitute(pattern2disp, '#\+', '#', '')

    " title
    let pattern2disp = substitute(pattern2disp, 'title:.*', '', '')

    " vimwiki tags
    let pattern2disp = substitute(pattern2disp, '.*:\(\S\+\):.*', '#\1', '')

    " other tags
    let pattern2disp = substitute(pattern2disp, '.*&&\(\S\+\).*', '#\1', '')
    let pattern2disp = substitute(pattern2disp, '.*!\(\S\+\).*', '#\1', '')

    return pattern2disp
endfunction


function! s:tag_reducer(line)
    let pattern2disp = a:line

    " vimwiki tags
    let pattern2disp = substitute(pattern2disp, '.*:\(\S\+\):.*', '\1', '')

    " other tags
    let pattern2disp = substitute(pattern2disp, '.*&&\(\S\+\).*', '\1', '')
    let pattern2disp = substitute(pattern2disp, '.*!\(\S\+\).*', '\1', '')

    return pattern2disp
endfunction

" vim:foldmethod=marker

