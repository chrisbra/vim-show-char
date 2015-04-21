" Vimball Archiver by Charles E. Campbell, Jr., Ph.D.
UseVimball
finish
plugin/showwhite.vim	[[[1
43
" ShowWhite - Vim Plugin for displaying Whitespace
" ------------------------------------------------
" Version:     0.2
" Maintainer:  Christian Brabandt <cb@256bit.org>
" Last Change: Tue, 21 Apr 2015 20:16:24 +0200
" Script: http://www.vim.org/scripts/script.php?script_id=
" Copyright:    © 2014 by Christian Brabandt
    "   The VIM LICENSE applies to ShowWhite.vim
    "   (see |copyright|) except use "ShowWhite.vim" 
    "   instead of "Vim". No warranty, express or implied.
    "   *** ***   Use At-Your-Own-Risk!   *** ***
" GetLatestVimScripts:  5043 2 :AutoInstall: showwhite.vim
" Init: {{{1
let s:cpo= &cpo
if exists("g:loaded_showwhite") || &cp
  finish
endif
set cpo&vim
let g:loaded_showwhite = 1

fu! <sid>ShowWhiteToggle()
    let w:showwhite_toggle = !get(w:, 'showwhite_toggle', 0)
	call showwhite#Init()
endfu

" Public Interface: {{{1
" Define the Command aliases "{{{2
com! ShowWhiteToggle :call <sid>ShowWhiteToggle()

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
autoload/showwhite.vim	[[[1
92
" ShowWhite - Vim Plugin for displaying Whitespace
" ------------------------------------------------
" Version:     0.2
" Maintainer:  Christian Brabandt <cb@256bit.org>
" Last Change: Tue, 21 Apr 2015 20:16:24 +0200
" Script: http://www.vim.org/scripts/script.php?script_id=
" Copyright:    © 2014 by Christian Brabandt
"               The VIM LICENSE applies to ShowWhite.vim
"               (see |copyright|) except use "ShowWhite.vim" 
"               instead of "Vim". No warranty, express or implied.
"               *** ***   Use At-Your-Own-Risk!   *** ***
" GetLatestVimScripts:  5043 2 :AutoInstall: showwhite.vim
fun! <sid>WarningMsg(msg) "{{{1
    let msg = "ShowWhite: ". a:msg
    echohl WarningMsg
    if exists(":unsilent") == 2
        unsilent echomsg msg
    else
        echomsg msg
    endif
    echohl Normal
    let v:errmsg = msg
endfun

fun! <sid>DefineWhiteSpace() "{{{1
    if w:showwhite_toggle
        exe 'syn match ShowWhite_WhiteSpace / / containedin=ALL conceal cchar='. s:ws
        if exists("s:ws_highlight") && !empty(s:ws_highlight)
            exe printf("hi Conceal %s", s:ws_highlight)
        elseif exists("s:ws_highlight_link") && !empty(s:ws_highlight_link)
            exe printf("hi! link Conceal %s", s:ws_highlight_link)
        endif
    elseif hlexists('ShowWhite_WhiteSpace')
        syn clear ShowWhite_WhiteSpace
    endif
endfu

fun! <sid>DefineAugroups(toggle) "{{{1
    if a:toggle && !exists("#ShowWhiteSpace")
        augroup ShowWhiteSpace
            au!
            au Syntax * :call showwhite#Init()
        augroup end
    elseif !a:toggle
        augroup ShowWhiteSpace
            au!
        augroup END
        augroup! ShowWhiteSpace
    endif
endfu

fun! showwhite#Init() "{{{1
    if v:version < 703
        call s:WarningMsg('ShowWhite needs Vim > 7.3 or it might not work correctly')
    endif
    let s:list_space = (v:version > 704 || (v:version == 704 && has("patch711")))
    if !has("conceal")
        call s:WarningMsg('ShowWhite works best with conceal feature')
    endif
    let s:ws_highlight = get(g:, 'showwhite_highlighting', '')
    let w:showwhite_toggle = get(w:, 'showwhite_toggle', 0)
    let s:ws = get(g:, 'showwhite_space_char', '·')
    if !s:list_space
        " concealing not needed, Vim supports the space argument for the
        " 'listchars' option
        let s:ws_highlight_link = get(g:, 'showwhite_highlighting_link', 'Normal')
        if has("conceal")
            if &l:cole != 2
                setl conceallevel=2
            endif
            if &l:cocu !=# 'nv'
                setl concealcursor=nv
            endif
        endif
        call <sid>DefineWhiteSpace()
        call <sid>DefineAugroups(w:showwhite_toggle)
    else
        if w:showwhite_toggle
            if &listchars !~# "space:."
                exe printf("setl listchars+=space:%s",s:ws)
            endif
            setl list
        else
            let space = matchstr(&listchars, 'space:.')
            exe ":setl listchars-=".space
            set nolist
        endif
    endif
endfun 

" Modeline {{{1
" vim: ts=4 sts=4 fdm=marker com+=l\:\" fdl=0 et
doc/ShowWhitespace.txt	[[[1
154
*ShowWhitespace.txt*   A Plugin for displaying Whitespace

Author:  Christian Brabandt <cb@256bit.org>
Version: 0.2 Tue, 21 Apr 2015 20:16:24 +0200
Copyright: (c) 2009-2014 by Christian Brabandt
           The VIM LICENSE applies to ShowWhitespacePlugin.vim and
           ShowWhitespacePlugin.txt (see |copyright|) except use
           ShowWhitespacePlugin instead of "Vim".
           NO WARRANTY, EXPRESS OR IMPLIED.  USE AT-YOUR-OWN-RISK.

==============================================================================
1. Contents                                               *ShowWhitespacePlugin*

    1.  Contents.......................................: |ShowWhitespacePlugin|
    2.  ShowWhitespace Manual..........................: |ShowWhitespace-manual|
    2.1 ShowWhitespace configuration...................: |ShowWhitespace-config|
    3.  ShowWhitespace Feedback........................: |ShowWhitespace-feedback|
    4.  ShowWhitespace History.........................: |ShowWhitespace-history|

==============================================================================
2. ShowWhitespace Manual                                  *ShowWhitespace-manual*

Functionality

A popular question on Stackoverflow is the question, how to highlight
WhiteSpace so that it is easily recognizable
(http://stackoverflow.com/questions/1675688). This plugin aims to make that
easily possible. It not configured otherwise, Spaces will be displayed using
the '·' character.

Note, it is possible, that not all spaces will be highlighted correctly. This
seems to be - well - a particularity of the syntax highlighting used by Vim,
that it skips syntax regions which have the skipwhite (|syn-skipwhite|) flag
set. I posted a patch to fix this, so this might be fixed in the future.
But until then, there is nothing this plugin can do to fix this.
The patch is available at:
https://groups.google.com/d/msg/vim_dev/sSkuUhSDX6o/fEWBkaseeoUJ

Note: Starting from Vim 7.4.711 a different patch has been included that makes
use of the 'listchars' option to display whitespace characters.

                                                        *:ShowWhiteToggle*
:ShowWhiteToggle  Toggle displaying Whitespace (highlights only Spaces, no 
                  Tabs or other whitespace characters!). The state of the 
                  toggle function is remembered per window.

                                                         *ShowWhiteMapping*
Mapping     Mode   Function~
-------     ----   --------
<Leader>ws  n      Toggle displaying Whitespace chars (like calling
                   |:ShowWhiteToggle|)

==============================================================================

2.1 ShowWhitespace Configuration                          *ShowWhitespace-config*
--------------------------------

By default, a '·' will be shown for spaces (and only spaces). If you like to
use a different char, specify the g:showwhite_space_char variable in your
|.vimrc| like this: >

    :let g:showwhite_space_char = '­'
<
(default: '·')
------------------------------------------------------------------------------

By default the <Leader>ws mapping will be defined to toggle displaying
whitespace characters. If you would like to use a different key mapping, you
can map it to the <Plug>ShowWhiteToggle function like this in your |.vimrc| >

    :nmap <F3> <Plug>ShowWhiteToggle
<
(default: <Leader>ws)
------------------------------------------------------------------------------

The default highlighting for the space characters is the Conceal highlighting
group (|hl-Conceal|). If you would like to customize it, you can define your
own highlighting group like this (e.g. in your |.vimrc|): >

    :hi Conceal ctermfg=7 ctermbg=NONE guifg=LightGrey guibg=NONE
<
Note: This should be done after loading your |colorscheme|).

Alternatively, you can define the variable g:showwhite_highlighting like this
(in your |.vimrc|) >

    :let g:showwhite_highlighting = 'ctermfg=7 ctermbg=NONE guifg=LightGrey guibg=NONE'
>
This interally modifies the Conceal highlighting, so it can have an influence
on normal syntax highlighting rules.

Note: Since starting from Vim 7.4.711 Vim supports highlighting whitespaces using
the 'listchars' option, this option is not supported anymore

(default: Conceal)
------------------------------------------------------------------------------

If the default Conceal highlighting is too disturbing for the plugin can also
link the Conceal highlighting group to the Normal (|hl-Normal|) or any other
highlighting group you define.

To do so, set the g:showwhite_highlighting_link variable like this
(e.g. in your |.vimrc|): >

    :let g:showwhite_highlighting_link = 'Normal'
<
Note: This only works, if the g:showwhite_highlighting variable is not set.

If you do not want this, set the variable to the empty string like this (e.g.
in your |.vimrc|): >

    :let g:showwhite_highlighting_link = ''

Note: Since starting from Vim 7.4.711 Vim supports highlighting whitespaces using
the 'listchars' option, this option is not supported anymore

(default: Normal)
=============================================================================
3. ShowWhitespace Feedback                            *ShowWhitespace-feedback*

Feedback is always welcome. If you like the plugin, please rate it at the
vim-page:
http://www.vim.org/scripts/script.php?script_id=5043

You can also follow the development of the plugin at github:
http://github.com/chrisbra/ShowWhitespace

Please don't hesitate to report any bugs to the maintainer, mentioned in the
third line of this document.

If you like the plugin, write me an email (look in the third line for my mail
address). And if you are really happy, vote for the plugin and consider
looking at my Amazon whishlist: http://www.amazon.de/wishlist/2BKAHE8J7Z6UW

=============================================================================
4. ShowWhitespace History                              *ShowWhitespace-history*

0.2: Apr 21, 2015 {{{1
- Make sure highlighting group exists (issue
  https://github.com/chrisbra/vim-show-whitespace/issues/1, reported by
  feroxium, thanks!)
- Link Conceal highlighting to Normal group
- Support Vim 7.4.711 (includes a native fix for whitespace highlighting using
  the 'listchars' option)

0.1: Oct 26, 2014 {{{1

- Initial upload
- development versions are available at the github repository
- put plugin on a public repository (http://github.com/chrisbra/ShowWhitespace)
  }}}
==============================================================================
Modeline:
vim:tw=78:ts=8:ft=help:et:fdm=marker:fdl=0:norl
