# vim-mkd-org

## (Optional) Requirement

- skywind3000/asyncrun.vim
- junegunn/fzf.vim
- latex / xelatex (texlive-full)
- pip3 install pandoc-xnos --upgrade
- silversearcher (optional)
- pandoc
- `pip3 install pandoc-xnos --upgrade`


tools and support to use vimwiki/markdown files to organize your work, life, ...

## TODOs
- [ ] replace gx command: defx#util#open(filename)  & `def execute_system of defx`
- [ ] toggle list/task items on line range

## Commands and default mappings

see [plugin/mkdd.md](./plugin/mkdd.md)

## Functions

pandoc#html(...)
argument 0: template.css (default: pandoc_killercup.css)
argument 1: path to template (default vim-mkd-org/templates)


## Variables
```vim
  if !exists('g:css_template')
    let g:css_template = 'pandoc_killercup.css'
  endif

  if !exists('g:css_template_path')
    let g:css_template_path = s:path_plugin . '/templates/' . 'pandoc_killercup.css'
  endif
```

# References

## css templages
- killer template

# Future
## Include other pandoc templates
- https://github.com/topics/pandoc-template
- [sindresorhus / github-markdown-css](https://github.com/sindresorhus/github-markdown-css)
- sty-files from: https://github.com/kjhealy/latex-custom-kjh.git
  ```sh
    cd /usr/share/texmf/tex/latex
    sudo git clone https://github.com/kjhealy/latex-custom-kjh.git
  ```
  - latex style: https://github.com/kjhealy/latex-custom-kjh: in  /usr/share/texmf/tex/latex
