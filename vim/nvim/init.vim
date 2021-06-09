" =========================================================
" Neo-vim configuration
" =========================================================

" the following allows to re-use the config of vim in neovim
" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath
" source ~/.vimrc
" I set up a new config, however.

" =========================================================
" installation-specific configuration
" =========================================================

" python to be used for external plugins, in a separate conda environment
" install the 
" You can check if they work with :checkhealth
" TODO use $CONDA_EXE info --base
if isdirectory(expand('~/installer/miniconda3/envs/neovim-py2/bin'))
let g:python_host_prog  = '~/installer/miniconda3/envs/neovim-py2/bin/python'
endif
if isdirectory(expand('~/installer/miniconda3/envs/neovim-py3/bin'))
let g:python3_host_prog  = '~/installer/miniconda3/envs/neovim-py3/bin/python'
endif


" =========================================================
" plugin management with vim-plug
" =========================================================
" to get vim-plug:
"     curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
"        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" To finish the installation of the plugins listed below, run
"     :PlugInstall
call plug#begin('~/.config/nvim/plugged')

" ---------------------------------------------------------
" global vim behaviour
" ---------------------------------------------------------
Plug 'junegunn/vim-plug'  " this provides help commands for vim-plug
Plug 'mhinz/vim-startify'  " start screen
Plug 'vim-airline/vim-airline'  " fancy status bar
Plug 'sjl/gundo.vim' " Undo tree
Plug 'preservim/nerdcommenter' " NERDCommenter
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' } " NERDTree
Plug 'AndrewRadev/linediff.vim', { 'on': 'Linediff' } " diff of individual lines within a file
Plug 'machakann/vim-sandwich' " add/remove/change brackets/quotationmarks/tags
Plug 'junegunn/vim-easy-align' " simplify alignment, also good for tables
Plug 'kien/ctrlp.vim' " open a file. Below re-mapped to <leader>o and :open
Plug 'SirVer/ultisnips' " snippet engine
Plug 'honza/vim-snippets'  " snippets for ultisnips   

" plugin for firefox to allow editing text fields with neovim
" Amazing!
" see https://addons.mozilla.org/en-US/firefox/addon/firenvim/
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) }}


" ---------------------------------------------------------
" IDE-behaviour for vim
" ---------------------------------------------------------
" Autocompletion for (almost) any language
" YouCompleteMe requires compilation *after* installation
"    cd ~/.config/nvim/plugged/YouCompleteMe/
"    conda activate neovim-py3
"    python install.py --clang-completer
" The following function does that automatically.
function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status != 'unchanged' || a:info.force
    !conda activate neovim-py3
    !python ./install.py
  endif
endfunction
Plug 'ycm-core/YouCompleteMe', { 'branch': 'legacy-py2', 'do': function('BuildYCM')}

Plug 'dense-analysis/ale'  " asynchronous syntax/lint checker
" Plug 'ludovicchabant/vim-gutentags'

" Git integration
Plug 'airblade/vim-gitgutter'   " show git changes in the current file
Plug 'tpope/vim-fugitive'   " integration of git commands



" ---------------------------------------------------------
" Support for individual programming languages
" ---------------------------------------------------------
"Plug 'vim-latex/vim-latex', {'for': 'tex'} " Latex-Suite
Plug 'lervag/vimtex', {'for': 'tex'}  " Latex tools
Plug 'JuliaEditorSupport/julia-vim', {'for': 'julia'} " Julia support; insert unicode characters
Plug 'python-mode/python-mode', {'for': 'python'} " pymode

call plug#end()

" =========================================================
" global settings
" =========================================================

" fileencoding
set encoding=utf-8

" automatically read a file that has changed on disk
set autoread
" workaround to ensure that we note changed files
" when focusing the terminal running nvim
" See https://github.com/neovim/neovim/issues/1936
au FocusGained * :checktime

" allow hidden buffer so they don't have to be saved every time
set hidden

" When the page starts to scroll, keep the curser 8 lines from
" the top and 4 lines from the bottom
set scrolloff=4

" tabwidth of 8 is definitely too much
" WARNING: printing will though use 8 tabs,
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Display tabs with a bar and trailing whitespace with an underscore
set list
set listchars=tab:\|\ ,trail:_

" show linenumbers
set number

" with linebreak on, vim brakes lines at characters set in
" `breakat`, default of breakat is  " ^I!@*-+;:,./?" ...
set linebreak
" Showbreak is a string put before lines broken by wrap to
" indicate, that theres no real <EOL>
let &showbreak="+++ "
set breakindent

" default foldmethod is indent, maybe overwritten by filetype plugins
set foldmethod=indent
set foldlevelstart=1

" spell checking
set spelllang=en_us
" global spellfile in home directory
set spellfile=~/.config/nvim/spell/en.utf-8.add
" local for the project, use 2zg to add a word here...
set spellfile+=spellignore.utf-8.add
" activate spellchecking with setlocal spell, see :help spell-quickstart

set nomodeline " security issue

" more quickly update background processes (save swap to disk, gitgutter, ...)
set updatetime=500


"----------------------------------------------------------
" key bindings and mappings
"----------------------------------------------------------

" The most important mapping: jj to <esc> in insert mode
" Escape keys are at different locations at different keyboards (especially
" on notebooks), so you don't want to mess around with it all the time.
imap jj <esc>


" mapleader is used by a bunch of plugins to define how to initialize a
" mapping.
let mapleader=","
let maplocalleader=","


" Search for selected text, forwards with * or backwards with # 
" (as in normal mode)
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

"Toggle highlight search
nmap ,n :set hls! hls?<cr>

" copy and paste to system clipbord
" single press: copy to system clipboard (register '+')
" double press: copy to selection clipboard (register '*')
vmap <C-c> "+y
vmap <C-c><C-c> "*y
vmap <C-x> "+c
vmap <C-x><C-x> "*c
" <Insert> is the corresponding key on the keyboard!
" <S-Insert> is linux default for the `*` register
nmap <Insert> "+p
cmap <Insert> "+p
imap <Insert> <Esc>"+pa
nmap <S-Insert> "*p
cmap <S-Insert> "*p

" =========================================================
" Plugin settings
" =========================================================


" ---------------------------------------------------------
" Airline
let g:airline_symbols_ascii = 1

" ---------------------------------------------------------
" CtrlP
let g:ctrlp_map = '<leader>o' " ,o like 'open'


" ---------------------------------------------------------
" gitgutter
let g:gitgutter_highlight_linenrs = 1

" ---------------------------------------------------------
" Gundo
noremap <F2> :GundoToggle<CR>

" ---------------------------------------------------------
" NERDTree
noremap <F3> :NERDTree<CR>

" ---------------------------------------------------------
" NERDCommenter
let NERDSpaceDelims=1

" ---------------------------------------------------------
" sandwich
if isdirectory(expand('~/.config/nvim/plugged/vim-sandwich'))
    nmap s <Nop>
    xmap s <Nop>
    let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
endif


" ---------------------------------------------------------
" YouCompleteMe
"let g:ycm_extra_conf_globlist = ['~/postdoc/*']
let g:ycm_global_ycm_extra_conf = '~/.config/nvim/ycm_extra_conf.py'

" ---------------------------------------------------------
" UltiSnips
let g:UltiSnipsExpandTrigger = "<c-s><c-s>"
let g:UltiSnipsListSnippets = "<c-s><c-l>"
let g:UltiSnipsJumpForwardTrigger = "<c-s><c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-s><c-k>"
"inoremap <c-x><c-k> <c-x><c-k>


" ---------------------------------------------------------
" julia-vim
runtime macros/matchit.vim
let g:latex_to_unicode_tab = 0
let g:latex_to_unicode_suggestions = 0
let g:latex_to_unicode_keymap = 1


" ---------------------------------------------------------
" python-mode
let g:pymode_python = 'python3'
" select features i want:
let g:pymode_indent = 1
let g:pymode_folding = 0  " slow!
let g:pymode_motion = 1
let g:pymode_doc = 0
let g:pymode_virtualenv = 0
let g:pymode_run = 1
let g:pymode_breakpoints = 1
let g:pymode_breakpoint_cmd = 'import ipdb; ipdb.set_trace() # TODO XXX'
let g:pymode_lint = 0      " use plugin `ale` instead
let g:pymode_rope = 0      " slow!
let g:pymode_syntax = 0    " slow!
let g:pymode_options_max_line_length = 99
let g:pymode_trim_whitespace = 0

" ---------------------------------------------------------
" latex-suite
" let g:Tex_CompileRule_pdf="lualatex -interaction=nonstopmode -synctex=1 -src-specials $*"
" let g:Tex_DefaultTargetFormat='pdf'
" let g:Tex_ViewRule_pdf = 'okular --unique'
" ---------------------------------------------------------
" vimtex for latex
let g:vimtex_view_method = 'zathura'

" ---------------------------------------------------------
" firenvim
if exists('g:started_by_firenvim')
  "if lines < 20
  "    set lines=20
  "endif
  au BufEnter github.com_*.txt set filetype=markdown
  nnoremap <C-z> :call firenvim#hide_frame()<CR>
  nnoremap <Leader>+ :set lines+=5<CR>:set columns+=5<CR>
  nnoremap <Leader>- :set lines-=5<CR>:set columns-=5<CR>
endif
" don't takeover (jupyter) notebooks with firenvim in the browser
let g:firenvim_config = { 
	\ 'localSettings': {
		\ '.*': {
			\ 'cmdline': 'neovim',
			\ 'priority': 0,
			\ 'selector': 'textarea, div[role="textbox"]',
			\ 'takeover': 'always',
		\ },
		\ 'notebooks': {
			\ 'priority': 1, 
			\ 'takeover': 'never',
		\ },
	\ },
\}


