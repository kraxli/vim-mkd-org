
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

  if match(current_line, '^\s*[*\-+] \[ \]') >= 0
    call setline(lineNum, substitute(current_line, '^\(\s*[*\-+]\) \[ \]', '\1 [-]', ''))
    return
  endif
  if match(current_line, '^\s*[*\-+] \[-\]') >= 0
    call setline(lineNum, substitute(current_line, '^\(\s*[*\-+]\) \[-\]', '\1 [x]', ''))
    return
  endif
  if match(current_line, '^\s*[*\-+] \[x\]') >= 0
    call setline(lineNum, substitute(current_line, '^\(\s*\) [*\-+] \[x\]', '\1', ''))
    return
  endif
  if match(current_line, '^\s*[*\-+] \(\[[x ]\]\)\@!') >= 0
    call setline(lineNum, substitute(current_line, '^\(\s*[*\-+]\)', '\1 [ ]', ''))
    return
  endif

  if match(current_line, '^\s*#\{1,5}\s') >= 0
    call setline(lineNum, substitute(current_line, '^\(\s*#\{1,5}\) \(.*$\)', '\1# \2', ''))
    return
  endif
  if match(current_line, '^\s*#\{6}\s') >= 0
    call setline(lineNum, substitute(current_line, '^\(\s*\)#\{6} \(.*$\)', '\1# \2', ''))
    return
  endif

  "   " if match(current_line, '^\s*[^*\-+] ') >= 0
  " if match(current_line, '^\s*\S') >= 0
  "   call setline(lineNum, substitute(current_line, '^\(\s*\)\(\S*\) ', '\1- \2', ''))
  "   return
  " endif

  if match(current_line, '^\s*[^*\-+]') >= 0
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
  endif

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
    call setline(lineNum, substitute(current_line, '^\(\s*\) [*\-+]', '\1', ''))
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


" vim:foldmethod=marker

