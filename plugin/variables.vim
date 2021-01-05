
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

