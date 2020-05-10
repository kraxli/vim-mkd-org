
" Switch status of things
" TODO allow for ranges
command! -range ToggleStatusRangeUp call mkdd#ToggleStatusRangeUp()
command! -range -nargs=? NumberedList call mkdd#NumberedList(<f-args>)
command! ToggleStatusUp call mkdd#ToggleStatusUp()
command! ToggleStatusDown call mkdd#ToggleStatusDown()
command! TasksOpenHi silent :let @/='^\s*-\s\[\s\]'|set hls
command! TasksOpen silent :execute 'Fp \V\^\s\*\(\[-+*]\{1}\s[\s]\|\s\*#\{1,6}\.\*\)'|let @/='^\s*-\s\[\s\]'|set hls
" command! TasksOpen call mkdd#unfold_open_tasks()
command! MoveFold2End call mkdd#MoveFoldToFileEnd()
command! HeaderLevelIncrease call mkdd#HeaderIncrease()
command! HeaderLevelDecrease call mkdd#HeaderDecrease()

augroup mkdd_cmd
  autocmd!

  if !hasmapto('NumberedList')
    au Filetype markdown,text execute 'vnoremap <silent> <buffer> tln :NumberedList<cr>'
  endif

  if !hasmapto('ToggleStatusUp')
    " TODO let filetype list be determined by the user via a variable
    au Filetype markdown,text
      \ execute 'nnoremap <silent> <buffer> ' . g:mkdd_mapping_switch_status . ' :ToggleStatusUp<cr>'
  endif

  if !hasmapto('ToggleStatusRangeUp')
    " TODO let filetype list be determined by the user via a variable
    au Filetype markdown,text
      \ execute 'vnoremap <silent> <buffer> ' . g:mkdd_mapping_switch_status . ' :ToggleStatusRangeUp<cr> gv'
  endif

  if !hasmapto('ToggleStatusDown')
    " TODO let filetype list be determined by the user via a variable
    au Filetype markdown,text
      \ execute 'nnoremap <silent> <buffer> ' . g:mkdd_mapping_switch_status_down . ' :ToggleStatusDown<cr>'
  endif

  if !hasmapto('ToggleStatusRangeDown')
    " TODO let filetype list be determined by the user via a variable
    au Filetype markdown,text
      \ execute 'vnoremap <silent> <buffer> ' . g:mkdd_mapping_switch_status_down . ' :ToggleStatusRangeDown<cr> gv'
  endif

  if !hasmapto('MoveFold2End')
    nmap <silent> tm :MoveFold2End<cr>
  endif

  if !hasmapto('TaksOpenHi')
    nmap <silent> th :TasksOpenHi<cr>
  endif

  if !hasmapto('TasksOpen')
    nmap <silent> to :TasksOpen<cr>
  endif

  if !hasmapto('HeaderLevelIncrease')
    nmap hi :HeaderLevelIncrease<cr>
    nmap <c-,> :HeaderLevelIncrease<cr>
    imap <c-,> :HeaderLevelIncrease<cr>
  endif

  if !hasmapto('HeaderLevelDecrease')
    nmap hd :HeaderLevelDecrease<cr>
    nmap <c-;> :HeaderLevelDecrease<cr>
    imap <c-;> :HeaderLevelDecrease<cr>
  endif

  au Filetype markdown,text
    \ execute 'nnoremap <silent> <buffer> ' . g:mkdd_wiki_index_key . ' :e ' . g:wiki_dir . ' index.md<CR>'

  au Filetype markdown,text
    \ execute 'nnoremap <silent> <buffer> ' . g:mkdd_blog_index_key . ' :e ' . g:blog_dir . ' index.md<CR>'

augroup END
