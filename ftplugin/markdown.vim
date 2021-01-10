
let s:path_base = expand('<sfile>:p:h:h')

" --------------------------------------------------
" {{{ OPTIONS
" --------------------------------------------------
" setlocal autoindent
" setl formatoptions=tcroqn2
" setlocal comments=b:*,b:-,b:+,n:>,se:```
" setlocal commentstring=>\ %s
" setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\\|^\\s*[+-\\*]\\s\\+
setl wrap linebreak nolist
setl breakindent
setl textwidth=0
setl wrapmargin=0 " only used when textwidth=0
setlocal nolisp

" Enable spelling and completion based on dictionary words
" if &spelllang !~# '^\s*$' && g:mkdd_enable_spell_checking
"   setlocal spell
" endif

" Custom dictionary for emoji
execute 'setlocal dictionary+=' . shellescape(s:path_base) . '/dict/emoticons.dict'
setlocal complete+=k

" " if g:markdown_enable_input_abbreviations
"   " Replace common ascii emoticons with supported emoji
"   iabbrev <buffer> :-) :smile:
"   iabbrev <buffer> :-D :laughing:
"   iabbrev <buffer> :-( :disappointed:
"
"   " Replace common punctuation
"   iabbrev <buffer> ... …
"   iabbrev <buffer> << «
"   iabbrev <buffer> >> »
" " endif

" SNIPPETS
" let g:UltiSnipsSnippetDirectories=["UltiSnips", shellescape(s:path_base) . "/snippets/UltiSnips"]

UltiSnipsAddFiletypes markdown.org
UltiSnipsAddFiletypes vimwiki.org
UltiSnipsAddFiletypes vimwiki.markdown
UltiSnipsAddFiletypes vimwiki.writer

" ┌─────────────────────────┐
" │ Defautl Variable Values │
" └─────────────────────────┘

if !exists('g:mkdd_use_mkdx')
  let g:mkdd_use_mkdx = 0
endif

if !exists('g:mkdd_tag_prefixes')
  " let g:mkdd_tag_prefixes = '!&'
  let g:mkdd_tag_prefixes = ['!!','&&']
endif

if !exists('g:mkdd_task_done_symbols')
  let g:mkdd_task_done_symbols = '[xX✓]'
endif

if !exists('g:mkdd_mapping_switch_status')
  let g:mkdd_mapping_switch_status = '<c-space>'
endif

if !exists('g:mkdd_mapping_switch_status_down')
   let g:mkdd_mapping_switch_status_down = '<c-d>'
endif

if !exists('g:mkdd_wiki_index_key')
  let g:mkdd_wiki_index_key = '<leader>W'
endif

if !exists('g:mkdd_blog_index_key')
  let g:mkdd_blog_index_key = '<leader>B'
endif

if !exists('g:mkdd_rxHeader')
  let g:mkdd_rxHeader = '#'
endif

if !exists('g:mkdd_rxListItem')
  let g:mkdd_rxListItem = '^\s*[*-]\s'
endif

if !exists('g:wiki_dir')
  let g:wiki_dir = '~/wiki/'
endif

if !exists('g:blog_dir')
  let g:blog_dir =  '~/blog/'
endif

if !exists('g:subdir_out')
   let g:subdir_out = 'out/'
endif

