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
