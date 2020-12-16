
let s:path_plugin = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')

" mathjax help:
"   - http://docs.mathjax.org/en/latest/web/configuration.html#configuration-using-an-in-line-script
"   - https://mathjax.github.io/MathJax-demos-web/

command! Pandoc2Pdf :call pandoc#base('pdf')
command! Pandoc2Doc :call pandoc#base('doc')
command! Pandoc2Docx :call pandoc#base('docx')
command! Pandoc2Epub :call pandoc#base('epub')
command! Pandoc2Html :call pandoc#base('html',
  \ '--mathjax="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"',
  \ '--css ' . s:path_plugin . '/templates/pandoc_killercup.css'
  \ )
" \ '-M date="`date "+%B %e, %Y"`"'

command! PandocPublish :call s:pandocPublish()

command! -nargs=1 PandocLib :pandoc %:p
  \ +inline_notes
  \ --filter pandoc-citeproc
  \ <f-args>
  " see:  http://johnmacfarlane.net/pandoc/demos.html

""""""""""""""""""""""
"  Privte Functions  "
""""""""""""""""""""""

function! s:pandocPublish()
     :Pandoc2Html
     :Pandoc2Pdf
endfunction
