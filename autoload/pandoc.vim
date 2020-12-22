
let s:path_plugin = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')

function! pandoc#base(out, ...)
  let executionStr = ''
  for item in a:000
    let executionStr = executionStr . ' ' . item
  endfor

  let runStr = 'AsyncRun pandoc %:p
                  \ -s
                  \ -o %:p:h/' . g:subdir_out . '%:p:t:r.' . a:out . '
                  \ --toc
                  \ --toc-depth=2
                  \ --variable geometry=a4paper
                  \ --variable linkcolor=blue
                  \ --variable citecolor=blue
                  \ --variable urlcolor=blue
                  \ --filter pandoc-xnos
                  \ --variable toccolor=blue ' . executionStr
  " echo runStr
  execute(runStr)
endfunction

" \ -o ' . g:dir_pandoc_out . ' %:p:t:r ' . a:out . '
" \ -o %:p:h/html/%:p:t:r.html
" \ --number-sections or -N
" \ --filter pandoc-eqnos
" \ --filter pandoc-tablenos
" \ --filter pandoc-fignos

" HTML:
" !pandoc %:p -s -o %:p:h/%:p:t:r.html  --toc --toc-depth=2 --pdf-engine=xelatex --variable geometry=a4paper --variable linkcolor=blue --variable citecolor=blue --variable urlcolor=blue --filter pandoc-eqnos --filter pandoc-tablenos --filter pandoc-fignos --variable toccolor=blue --css /home/dave/.cache/vim/dein/repos/github.com/kraxli/vim-mkd-org//templates/pandoc_killercup.css --mathjax="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
"
" PDF:
" !pandoc %:p -s -o %:p:h/%:p:t:r.pdf  --toc --toc-depth=2 --pdf-engine=xelatex --variable geometry=a4paper --variable linkcolor=blue --variable citecolor=blue --variable urlcolor=blue --filter pandoc-eqnos --filter pandoc-tablenos --filter pandoc-fignos --variable toccolor=blue
"

function! pandoc#html(...)
  let path_plugin = get(a:, 2, s:path_plugin)
  let css_template = path_plugin . '/templates/' . get(a:, 1, 'pandoc_killercup.css')
  echo css_template
  call pandoc#base('html',
  \ '--mathjax="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"',
  \ '--css ' . css_template
  \ )
endfunction

