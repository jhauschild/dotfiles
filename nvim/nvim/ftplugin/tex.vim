" Only do this when not yet done for this buffer
if exists("b:did_joghurts_tex_ftplugin")
  finish
endif
" more text in one row
setlocal textwidth=0
setlocal wrap
" map j to gj and k to gk, so line navigation ignores line wrap
nmap j gj
nmap k gk

" less indent, used in formulas etc
set tabstop=4

" -- folding with vimtex for sections etc
set foldmethod=expr
set foldexpr=vimtex#fold#level(v:lnum)
set foldtext=vimtex#fold#text()




" ------- Obsolete options below
" forward search with okular:
" gvim --servername GVIMSRV --remote-tab-silent +%l %f
"" sync from beginining
"syntax on
"syntax sync fromstart
"syntax spell toplevel

"" overwrite the function for latex forward search
" latex-suite maps the keys <leader>ls to this function
"function! Tex_ForwardSearchLaTeX()
"    let s:syncfile = fnamemodify(fnameescape(Tex_GetMainFileName()), ":r").".pdf"
"    let execstr = "silent !okular --unique ".s:syncfile."\\#src:".line(".").expand("%\:p").' &'
"    exec execstr
"endfunction

"function! Tex_ViewLaTeX()
"    call Tex_ForwardSearchLaTeX()
"endfunction

