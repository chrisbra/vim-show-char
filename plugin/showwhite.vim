" ShowWhite - Vim Plugin for displaying Whitespace
" ------------------------------------------------
" Version:     0.3
" Maintainer:  Christian Brabandt <cb@256bit.org>
" Last Change: Thu, 04 May 2017 09:10:19 +0200
" Script: http://www.vim.org/scripts/script.php?script_id=
" Copyright:    © 2014 by Christian Brabandt
    "   The VIM LICENSE applies to ShowWhite.vim
    "   (see |copyright|) except use "ShowWhite.vim" 
    "   instead of "Vim". No warranty, express or implied.
    "   *** ***   Use At-Your-Own-Risk!   *** ***
" GetLatestVimScripts:  5043 3 :AutoInstall: showwhite.vim
" Init: {{{1
let s:cpo= &cpo
if exists("g:loaded_showwhite") || &cp
  finish
endif
set cpo&vim
let g:loaded_showwhite = 1

fu! <sid>ShowWhiteToggle()
	call showwhite#Init()
endfu

" Public Interface: {{{1
" Define the Command aliases "{{{2
com! ShowWhiteToggle :call <sid>ShowWhiteToggle()
com! -bang -nargs=* ShowCharAs :call showwhite#ShowCharAs(<bang>0, <q-args>)

" Define the Mapping: "{{{2
if !hasmapto('<Plug>ShowWhiteToggle')
	nmap <silent><unique> <Leader>ws <Plug>ShowWhiteToggle
endif
if !hasmapto('SWToggle')
    nnoremap <unique><script> <Plug>ShowWhiteToggle <sid>SWToggle
endif

nnoremap <sid>SWToggle :<c-u>call <sid>ShowWhiteToggle()<cr>

" Restore: "{{{1
let &cpo=s:cpo
unlet s:cpo
" vim: ts=4 sts=4 fdm=marker com+=l\:\" et
