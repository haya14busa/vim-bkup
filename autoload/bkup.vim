"=============================================================================
" FILE: autoload/bkup.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:File = vital#bkup#import('System.File')
let s:Filepath = vital#bkup#import('System.Filepath')
let s:String = vital#bkup#import('Data.String')

let s:escaped_backslash = '\m\%(^\|[^\\]\)\%(\\\\\)*'

let g:bkup#backup = 1
let g:bkup#dir = get(g:, 'bkup#dir', expand('~/.local/share/vim/bkup/'))

function! bkup#backup(file) abort
  let from = fnamemodify(a:file, ':p')
  if from =~# s:filepattern_to_regex(&backupskip . ',' . g:bkup#dir)
    return
  endif
  let extension = fnamemodify(a:file, ':e')
  let time = strftime('_%Y%m%d_%X')
  let to = s:Filepath.join(g:bkup#dir, from) . time . '.' . extension
  let todir = fnamemodify(to, ':h')
  if !isdirectory(todir)
    call mkdir(todir, 'p')
  endif
  call s:File.copy(from, to)
endfunction

" :h file-pattern
" pattern   | description
" --------- | -----------
" *         | matches any sequence of characters; Unusual: includes path separators
" ?         | matches any single character
" \?        | matches a '?'
" .         | matches a '.'
" ~         | matches a '~'
" ,         | separates patterns
" \,        | matches a ','
" { }       | like \( \) in a |pattern|
" ,         | inside { }: like \| in a |pattern|
" \}        | literal }
" \{        | literal {
" \\\{n,m\} | like \{n,m} in a |pattern|
" \         | special meaning like in a |pattern|
" [ch]      | matches 'c' or 'h'
" [^ch]     | match any character but 'c' and 'h'
function! s:filepattern_to_regex(filepattern) abort
  let tr = {
  \   '*': '.*',
  \   '\?': '?',
  \   '?': '.',
  \   '.': '\.',
  \   '~': '\~',
  \   ',': '\|',
  \   '\,': ',',
  \   '{': '\(',
  \   '}': '\)',
  \   '\{': '{',
  \   '\}': '}',
  \   '\\\{': '{',
  \ }
  let p = join(map(keys(tr), 's:String.escape_pattern(v:val)'), '\|')
  let regex = substitute(a:filepattern, p, '\=tr[submatch(0)]', 'g')
  let regex = substitute(regex, s:escaped_backslash . '$\w\+', '\=eval(submatch(0))', 'g')
  return regex
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
