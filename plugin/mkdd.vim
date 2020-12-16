
""""""""""""""
"  commands  "
""""""""""""""

" Switch status of things
command! ToggleStatusUp call mkdd#ToggleStatusUp()
command! ToggleStatusDown call mkdd#ToggleStatusDown()
command! -range ToggleStatusRangeUp call mkdd#ToggleStatusRangeUp()
command! -range -nargs=? NumberedList call mkdd#NumberedList(<f-args>)
command! TasksOpenHi silent :let @/='^\s*-\s\[\s\]'|set hls
command! TasksOpen silent :execute 'Fp \V\^\s\*\(\[-+*]\{1}\s[\s]\|\s\*#\{1,6}\.\*\)'|let @/='^\s*-\s\[\s\]'|set hls
" command! TasksOpen call mkdd#unfold_open_tasks()
command! MoveToEnd call mkdd#moveToEnd() " mkdd#MoveFoldToFileEnd()
command! MoveSelectionToEnd call mkdd#moveSelectionToEnd()

command! HeaderLevelIncrease call mkdd#HeaderIncrease()
command! HeaderLevelDecrease call mkdd#HeaderDecrease()

command! FindAllIncompletTasks call mkdd#findAllIncompleteTasks()
command! FindIncompleteTasks call mkdd#findIncompleteTasks()


""""""""""""""""""
"  key mappings  "
""""""""""""""""""
augroup mkdd_cmd
  autocmd!

  noremap <leader>td :VimwikiToggleListItem<cr> $"=strftime(" [@DONE: %Y-%m-%d]")<CR>p
  " http://vim.wikia.com/wiki/Insert_current_date_or_time
  nnoremap <leader>dt  "='@'.strftime("%Y-%m-%d").':'<CR>P
  nnoremap <leader>dr "='@'.strftime("%Y-%m-%d").' - '.strftime("%Y-%m-%d").':'<CR>P

  " move tasked-done (closed folds) to end of file
  " nnoremap <leader>td :.m $<cr>
  nnoremap <leader>tm :call MoveFoldToFileEnd()<cr>
  " <leader>tm on visual block (but the following is rather messy and extremly slow):
  vnoremap <leader>tm :call MoveFoldToFileEnd()<cr>



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
    nmap <silent> tm :MoveToEnd<cr>
    vmap <silent> tm :call mkdd#moveSelectionToEnd()<cr>
  endif

  if !hasmapto('TaksOpenHi')
    nmap <silent> th :TasksOpenHi<cr>
  endif

  if !hasmapto('TasksOpen')
    nmap <silent> to :TasksOpen<cr>
  endif

  if !hasmapto('HeaderLevelIncrease')
    nmap hi :HeaderLevelIncrease<cr>
    nmap <silent> <c-,> :HeaderLevelIncrease<cr>
    imap <silent> <c-,> :HeaderLevelIncrease<cr>
  endif

  if !hasmapto('HeaderLevelDecrease')
    nmap hd :HeaderLevelDecrease<cr>
    nmap <silent> <c-;> :HeaderLevelDecrease<cr>
    imap <silent> <c-;> :HeaderLevelDecrease<cr>
  endif

  if !hasmapto('FindAllIncompletTasks')
    nmap <silent> <Leader>wa :FindAllIncompletTasks<cr>
  endif

  if !hasmapto('FindIncompleteTasks')
    nmap <silent> <Leader>wx :FindIncompleteTasks<cr>
  endif


  au Filetype markdown,text
    \ execute 'nnoremap <silent> <buffer> ' . g:mkdd_wiki_index_key . ' :e ' . g:wiki_dir . ' index.md<CR>'

  au Filetype markdown,text
    \ execute 'nnoremap <silent> <buffer> ' . g:mkdd_blog_index_key . ' :e ' . g:blog_dir . ' index.md<CR>'



augroup END
