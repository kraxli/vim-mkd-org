
" Switch status of things
" TODO allow for ranges
command! -range ToggleStatusRange call mkdd#ToggleStatusRange()
command! -range -nargs=? NumberedList call mkdd#NumberedList(<f-args>)
command! ToggleStatus call mkdd#ToggleStatus()
command! TasksOpenHi silent :let @/='^\s*-\s\[\s\]'|set hls
command! TasksOpen silent :execute 'Fp \V\^\s\*\(\[-+*]\{1}\s[\s]\|\s\*#\{1,6}\.\*\)'|let @/='^\s*-\s\[\s\]'|set hls
" command! TasksOpen call mkdd#unfold_open_tasks()
command! MoveFold2End call mkdd#MoveFoldToFileEnd()

augroup mkdd_cmd
  autocmd!

  if !hasmapto('NumberedList')
    au Filetype markdown,text execute 'vnoremap <silent> <buffer> tln :NumberedList<cr>'
  endif

  if !hasmapto('ToggleStatus')
    " TODO let filetype list be determined by the user via a variable
    au Filetype markdown,text
      \ execute 'nnoremap <silent> <buffer> ' . g:mkdd_mapping_switch_status . ' :ToggleStatus<cr>'
  endif

  if !hasmapto('ToggleStatusRange')
    " TODO let filetype list be determined by the user via a variable
    au Filetype markdown,text
      \ execute 'vnoremap <silent> <buffer> ' . g:mkdd_mapping_switch_status . ' :ToggleStatusRange<cr> gv'
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

  au Filetype markdown,text
    \ execute 'nnoremap <silent> <buffer> ' . g:mkdd_wiki_index_key . ' :e ' . g:wiki_dir . ' index.md<CR>'

  au Filetype markdown,text
    \ execute 'nnoremap <silent> <buffer> ' . g:mkdd_blog_index_key . ' :e ' . g:blog_dir . ' index.md<CR>'

augroup END
