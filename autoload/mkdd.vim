
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

function! mkdd#findIncompleteTasks()
  lvimgrep /- \[[^xX]\]/ %:p
  lopen
endfunction

function! mkdd#findAllIncompleteTasks()
  if exists(':Ag')
    Ag - \[[^xX]\]
  else
    VimwikiSearch /- \[[^xX]\]/
    lopen
  endif
endfunction


function! mkdd#findTags(search_string, bang)
  if exists(':Ag')

    let l:string2search = empty(a:search_string) ? '\[a-zA-Z0-9_-\]\{2,\}' : get(a:, 'search_string', '\[a-zA-Z0-9_-\]\{2,\}')
    let l:bang = get(a:, 'bang', 0) " get(a:, 2, 0)

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

    let l:non_vimwiki_tags = '\|\('. l:tag_prefix .'\)\\S\*'. l:string2search .'\\S\*'  " \R, problem with new line and space before
    let l:query = '\[^\(http\)\]:\\S\*'. l:string2search .'\\S\*:' . l:non_vimwiki_tags
    " let l:query = ':'. l:string2search .'\\S\*:\|\\s+\('. l:tag_prefix .'\)'. l:string2search .'\\S\*'
    let l:options_ag = '--md --color  --ignore-case ' " --ignore-case --smart-case

    return fzf#vim#grep('ag ' . l:options_ag . l:query, 1, fzf#vim#with_preview(), l:bang)
    " return fzf#run(fzf#wrap({'source': 'ag ' . l:options_ag . l:query}, l:bang))

  endif
endfunction


""""""""""""""""""""
"  fzf completion  "
""""""""""""""""""""

function! mkdd#get_crusor_expression()
"     " if getline('.')[col('.')-1] =~ ''
"     "   l:string = ''
"     " else
"     "   l:string = expand("<cword>")
"     " endif

    " get word before cursor
    let l:word_list = split(getline('.')[0:col('.')-1], '')
    let l:string2search = l:word_list == [] ? '\[a-zA-Z0-9_-:\]\{2,\}' : l:word_list[-1]
    let l:string2search = substitute(l:string2search, ':', '', '')

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

    return pattern2disp
endfunction


    " inoremap <expr> <c-f> fzf#vim#complete(fzf#wrap({'source': "ag '^#+ ' --md", 'prefix': '^.*$', 'reducer': { lines -> substitute(substitute(lines[0], '.md:\d*:', '', ''), ' ', '', '') }, 'options': '--preview'}))
    " inoremap <expr> <c-f> fzf#vim#complete(fzf#wrap({'source': "ag '^#+ ' --md", 'prefix': '^.*$', 'reducer': { lines -> substitute(substitute(lines[0], '.md:\d*:', '', ''), ' ', '', '') }, 'options': '--preview-window right:50% ctrl-/'}))

  " let g:zettel_fzf_options = ['--exact', '--tiebreak=end'] " --preview
  "  'options': '--exact --preview' --preview-window', 'hidden'
  "    let preview_args = get(g:, 'fzf_preview_window', ['right', 'ctrl-/'])
  "    let g:fzf_preview_window = ['right:50%', 'ctrl-/']

" Preview window on the upper side of the window with 40% height,
" hidden by default, ctrl-/ to toggle
" let g:fzf_preview_window = ['up:40%:hidden', 'ctrl-/']


" vim:foldmethod=marker

