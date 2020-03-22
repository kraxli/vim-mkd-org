"
" if exists('*shiftwidth')
"   fun! s:sw()
"     return shiftwidth()
"   endfunc
" else
"   fun! s:sw()
"     return &sw
"   endfunc
" endif
"
" let g:mkdx#settings.checkbox.toggles =
" let g:mkdx#settings.checkbox.update_tree = 
"
" fun! mkdd#ToggleCheckboxState(...)
"   let reverse = get(a:000, 0, 0) == 1
"   let listcpy = deepcopy(g:mkdx#settings.checkbox.toggles)
"   let listcpy = reverse ? reverse(listcpy) : listcpy
"   let line    = getline('.')
"   let len     = len(listcpy) - 1
"
"   for mrk in listcpy
"     if (match(line, '\[' . mrk . '\]') != -1)
"       let nidx = index(listcpy, mrk) + 1
"       let nidx = nidx > len ? 0 : nidx
"       let line = substitute(line, '\[' . mrk . '\]', '\[' . listcpy[nidx] . '\]', '')
"       break
"     endif
"   endfor
"
"   call setline('.', line)
"   if (g:mkdx#settings.checkbox.update_tree != 0) | call s:util.UpdateTaskList() | endif
"   silent! call repeat#set("\<Plug>(mkdx-checkbox-" . (reverse ? 'prev' : 'next') . ")")
" endfun
"
"
" fun! s:util.UpdateTaskList(...)
"   let linenum               = get(a:000, 0, '.')
"   let force_status          = get(a:000, 1, -1)
"   let [target, tasks]       = s:util.TasksToCheck(linenum)
"   let [tlnum, ttk, tdpt, _] = target
"   let tasksilen             = len(tasks) - 1
"   let [incompl, compl]      = g:mkdx#settings.checkbox.toggles[-2:-1]
"   let empty                 = g:mkdx#settings.checkbox.toggles[0]
"   let tasks_lnums           = map(deepcopy(tasks), {idx, val -> get(val, 0, -1)})
"
"   if (tdpt > 0)
"     let nextupd = tdpt - 1
"
"     for [lnum, token, depth, line] in reverse(deepcopy(tasks))
"       if ((lnum < tlnum) && (depth == nextupd))
"         let nextupd  -= 1
"         let substats  = []
"         let parentidx = index(tasks_lnums, lnum)
"
"         for ii in range(parentidx + 1, tasksilen)
"           let next_task  = tasks[ii]
"           let depth_diff = abs(next_task[2] - depth)
"
"           if (depth_diff == 0) | break                            | endif
"           if (depth_diff == 1) | call add(substats, next_task[1]) | endif
"         endfor
"
"         let completed = index(map(deepcopy(substats), {idx, val -> val != compl}), 1) == -1
"         let unstarted = index(map(deepcopy(substats), {idx, val -> val != empty}), 1) == -1
"         let new_token = completed ? compl : (unstarted ? empty : incompl)
"         if (force_status > -1 && !unstarted)
"           if (force_status == 0) | let new_token = empty   | endif
"           if (force_status == 1) | let new_token = incompl | endif
"           if (force_status > 1)  | let new_token = compl   | endif
"         endif
"         let new_line  = substitute(line, '\[' . token . '\]', '\[' . new_token . '\]', '')
"
"         let tasks[parentidx][1] = new_token
"         let tasks[parentidx][3] = new_line
"
"         call setline(lnum, new_line)
"         if (nextupd < 0) | break | endif
"       endif
"     endfor
"
"     if (force_status < 0 && g:mkdx#settings.checkbox.update_tree == 2)
"       for [lnum, token, depth, line] in tasks
"         if (lnum > tlnum)
"           if (depth == tdpt) | break | endif
"           if (depth > tdpt) | call setline(lnum, substitute(line,  '\[.\]', '\[' . ttk . '\]', '')) | endif
"         endif
"       endfor
"     endif
"   endif
" endfun
"
"
" fun! s:util.TasksToCheck(linenum)
"   let lnum    = type(a:linenum) == type(0) ? a:linenum : line(a:linenum)
"   let cnum    = col('.')
"   let current = s:util.TaskItem(lnum)
"   let startc  = lnum
"   let items   = []
"
"   while (prevnonblank(startc) == startc)
"     let indent = s:util.TaskItem(startc)[1]
"     if (indent == 0) | break | endif
"     let startc -= 1
"   endwhile
"
"   if (current[1] == -1) | return | endif
"
"   while (nextnonblank(startc) == startc)
"     let [token, indent, line] = s:util.TaskItem(startc)
"     if ((startc < lnum) || (indent != 0))
"       call add(items, [startc, token, indent, line])
"       let startc += 1
"     else
"       break
"     endif
"   endwhile
"
"   return [extend([lnum], current), items]
" endfun
"
" fun! s:util.UpdateTaskList(...)
"   let linenum               = get(a:000, 0, '.')
"   let force_status          = get(a:000, 1, -1)
"   let [target, tasks]       = s:util.TasksToCheck(linenum)
"   let [tlnum, ttk, tdpt, _] = target
"   let tasksilen             = len(tasks) - 1
"   let [incompl, compl]      = g:mkdx#settings.checkbox.toggles[-2:-1]
"   let empty                 = g:mkdx#settings.checkbox.toggles[0]
"   let tasks_lnums           = map(deepcopy(tasks), {idx, val -> get(val, 0, -1)})
"
"   if (tdpt > 0)
"     let nextupd = tdpt - 1
"
"     for [lnum, token, depth, line] in reverse(deepcopy(tasks))
"       if ((lnum < tlnum) && (depth == nextupd))
"         let nextupd  -= 1
"         let substats  = []
"         let parentidx = index(tasks_lnums, lnum)
"
"         for ii in range(parentidx + 1, tasksilen)
"           let next_task  = tasks[ii]
"           let depth_diff = abs(next_task[2] - depth)
"
"           if (depth_diff == 0) | break                            | endif
"           if (depth_diff == 1) | call add(substats, next_task[1]) | endif
"         endfor
"
"         let completed = index(map(deepcopy(substats), {idx, val -> val != compl}), 1) == -1
"         let unstarted = index(map(deepcopy(substats), {idx, val -> val != empty}), 1) == -1
"         let new_token = completed ? compl : (unstarted ? empty : incompl)
"         if (force_status > -1 && !unstarted)
"           if (force_status == 0) | let new_token = empty   | endif
"           if (force_status == 1) | let new_token = incompl | endif
"           if (force_status > 1)  | let new_token = compl   | endif
"         endif
"         let new_line  = substitute(line, '\[' . token . '\]', '\[' . new_token . '\]', '')
"
"         let tasks[parentidx][1] = new_token
"         let tasks[parentidx][3] = new_line
"
"         call setline(lnum, new_line)
"         if (nextupd < 0) | break | endif
"       endif
"     endfor
"
"     if (force_status < 0 && g:mkdx#settings.checkbox.update_tree == 2)
"       for [lnum, token, depth, line] in tasks
"         if (lnum > tlnum)
"           if (depth == tdpt) | break | endif
"           if (depth > tdpt) | call setline(lnum, substitute(line,  '\[.\]', '\[' . ttk . '\]', '')) | endif
"         endif
"       endfor
"     endif
"   endif
" endfun
"
"
" fun! s:util.TaskItem(linenum)
"   let line   = getline(a:linenum)
"   let token  = get(matchlist(line, '\[\(.\)\]'), 1, '')
"   let ident  = strlen(get(matchlist(line, '^>\?\( \{0,}\)'), 1, ''))
"   let rem    = ident % s:sw()
"   let ident -= g:mkdx#settings.enter.malformed ? (rem - (rem > s:sw() / 2 ? s:sw() : 0)) : 0
"
"   return [token, (ident == 0 ? ident : ident / s:sw()), line]
" endfun
"
"
" fun! s:util.UpdateListNumbers(lnum, depth, ...)
"   let lnum       = a:lnum
"   let min_indent = strlen(get(matchlist(getline(lnum), '^>\?\( \{0,}\)'), 1, ''))
"   let incr       = get(a:000, 0, 0)
"
"   while (nextnonblank(lnum) == lnum)
"     let lnum  += 1
"     let ln     = getline(lnum)
"     let ident  = strlen(get(matchlist(ln, '^>\?\( \{0,}\)'), 1, ''))
"
"     if (ident < min_indent) | break | endif
"     call setline(lnum,
"      \ substitute(ln,
"      \    '^\(>\? \{' . min_indent . ',}\)\([0-9.]\+\)',
"      \    '\=submatch(1) . s:util.NextListNumber(submatch(2), ' . a:depth . ', ' . incr . ')', ''))
"   endwhile
" endfun
"
" fun! s:util.NextListNumber(current, depth, ...)
"   let curr  = substitute(a:current, '^ \+\| \+$', '', 'g')
"   let parts = split(curr, '\.')
"   let incr  = get(a:000, 0, 0)
"   let incr  = incr < 0 ? incr : 1
"
"   if (len(parts) > a:depth) | let parts[a:depth] = str2nr(parts[a:depth]) + incr | endif
"   return join(parts, '.') . ((match(curr, '\.$') > -1) ? '.' : '')
" endfun
"
"
