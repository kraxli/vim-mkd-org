if exists('g:mkdd_org_markdown_settings') || &cp
  finish
endif

let g:mkdd_org_markdown_settings = 1

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

