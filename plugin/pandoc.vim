
let s:path_plugin = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')

if !exists('g:css_template')
  let g:css_template = 'pandoc_killercup.css'
endif

if !exists('g:css_template_path')
  let g:css_template_path = s:path_plugin . '/templates/' . 'pandoc_killercup.css'
endif

" mathjax help:
"   - http://docs.mathjax.org/en/latest/web/configuration.html#configuration-using-an-in-line-script
"   - https://mathjax.github.io/MathJax-demos-web/

command! PandocEasy2Docx :AsyncRun pandoc %p -o %:p:r.docx
command! PandocEasy2Html :AsyncRun pandoc %p -o %:p:r.html

command! Pandoc2Pdf :call pandoc#base('pdf', '--pdf-engine=xelatex')
command! Pandoc2Tex :call pandoc#base('tex', '--pdf-engine=xelatex')
command! Pandoc2Doc :call pandoc#base('doc')
command! Pandoc2Docx :call pandoc#base('docx')
command! Pandoc2Epub :call pandoc#base('epub')
command! Pandoc2Html :call pandoc#base('html',
  \ '--mathjax="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"',
  \ '--css ' . g:css_template_path
  \ )
" \ '-M date="`date "+%B %e, %Y"`"'

command! -nargs=* Pandoc2HtmlCustom :call pandoc#html(<f-args>)
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
