" mark all *.tex files as tex filetype, dont use plaintex
" also mark *.pdf_tex used by Inkscape with pdf+latex export as tex
au BufRead,BufNewFile *.tex set filetype=tex
au BufRead,BufNewFile *.pdf_tex set filetype=tex
