
function! pandoc#base(out, ...)
  let executionStr = ''
  for item in a:000
    let executionStr = executionStr . ' ' . item
  endfor

  echo executionStr

  execute('AsyncRun pandoc %:p
    \ -s
    \ -o %:p:h/%:p:t:r.' . a:out . '
    \ --toc
    \ --toc-depth=2
    \ --latex-engine=xelatex
    \ --variable geometry=a4paper
    \ --variable linkcolor=blue
    \ --variable citecolor=blue
    \ --variable urlcolor=blue
    \ --filter pandoc-eqnos
    \ --filter pandoc-tablenos
    \ --filter pandoc-fignos
    \ --variable toccolor=blue' . executionStr)
endfunction

" \ -o %:p:h/html/%:p:t:r.html
" \ --number-sections or -N


