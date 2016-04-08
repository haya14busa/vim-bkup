"=============================================================================
" FILE: plugin/bkup.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
if expand('%:p') ==# expand('<sfile>:p')
  unlet! g:loaded_bkup
endif
if exists('g:loaded_bkup')
  finish
endif
let g:loaded_bkup = 1
let s:save_cpo = &cpo
set cpo&vim

augroup vim-bkup
  autocmd!
  autocmd BufWritePre * :call bkup#backup(expand('%'))
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
