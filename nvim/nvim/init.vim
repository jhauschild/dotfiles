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

" You can check if they work with :checkhealth
" TODO use $CONDA_EXE info --base
if isdirectory(expand('~/.config/nvim/.pynvim_env/bin'))
	let g:python3_host_prog  = expand('~/.config/nvim/.pynvim_env/bin/python')
else
	let g:python3_host_prog  = '/usr/bin/python'
endif

" =========================================================
" plugin management with vim-plug
" =========================================================
" to get vim-plug:
"     curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
"        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" To finish the installation of the plugins listed below, run
"     :PlugInstall

function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" ---------------------------------------------------------
" global vim behaviour
" ---------------------------------------------------------
call plug#begin('~/.config/nvim/plugged')

Plug 'junegunn/vim-plug'                                     " this provides help commands for vim-plug
Plug 'machakann/vim-sandwich'                                " add/remove/change brackets/quotationmarks/tags
Plug 'preservim/nerdcommenter'                               " NERDCommenter
Plug 'tyjak/vim-redact-pass'                                 " pass edit without leaking to swap files

Plug 'AndrewRadev/linediff.vim', Cond(!exists('g:vscode'), { 'on': 'Linediff' })       " diff of individual lines within a file
Plug 'mhinz/vim-startify', Cond(!exists('g:vscode'))         " start screen
Plug 'vim-airline/vim-airline', Cond(!exists('g:vscode'))    " fancy status bar
Plug 'sjl/gundo.vim', Cond(!exists('g:vscode'))              " Undo tree
Plug 'preservim/nerdtree', Cond(!exists('g:vscode'), { 'on': 'NERDTreeToggle' }) " NERDTree
Plug 'junegunn/vim-easy-align', Cond(!exists('g:vscode'))    " simplify alignment, also good for tables
Plug 'kien/ctrlp.vim', Cond(!exists('g:vscode'))             " open a file. Below re-mapped to <leader>o and :open
Plug 'SirVer/ultisnips', Cond(!exists('g:vscode'))           " snippet engine
Plug 'honza/vim-snippets', Cond(!exists('g:vscode'))         " snippets for ultisnips   
" plugin for firefox to allow editing text fields with neovim
" Amazing!
" see https://addons.mozilla.org/en-US/firefox/addon/firenvim/
" Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) }}


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
    " !micromamba activate neovim-py3
    !/usr/bin/python ./install.py
  endif
endfunction
Plug 'ycm-core/YouCompleteMe', Cond(!exists('g:vscode'), { 'branch': 'master', 'do': function('BuildYCM')})


Plug 'dense-analysis/ale', Cond(!exists('g:vscode'))          " asynchronous syntax/lint checker
" let g:ale_linters_ignore = {'python': ['pyright']}
" Plug 'ludovicchabant/vim-gutentags'

" Git integration
Plug 'airblade/vim-gitgutter', Cond(!exists('g:vscode'))      " show git changes in the current file
Plug 'tpope/vim-fugitive', Cond(!exists('g:vscode'))          " integration of git commands

" ---------------------------------------------------------
" Support for individual programming languages
" ---------------------------------------------------------
" LaTeX
Plug 'lervag/vimtex', Cond(!exists('g:vscode'))  " Latex tools. 
" note: No lazy loading for tex only to allow synctex-inverse search
"Plug 'vim-latex/vim-latex', {'for': 'tex'} " Latex-Suite

" Julia support; insert unicode characters
Plug 'JuliaEditorSupport/julia-vim', Cond(!exists('g:vscode'), {'for': 'julia'}) 
" Python extensions
Plug 'python-mode/python-mode', Cond(!exists('g:vscode'), {'for': 'python'})       " pymode

call plug#end()


" =========================================================
" global settings (including vscode)
" =========================================================

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

nmap Y y$

" copy and paste to system clipbord
" single press: copy to system clipboard (register '+')
" double press: copy to selection clipboard (register '*')
if ! exists('g:vscode')
	vmap <C-c> "+y
	vmap <C-x> "+c
	" vmap <C-c><C-c> "*y
	" vmap <C-x><C-x> "*c
	" <Insert> is the corresponding key on the keyboard!
	" <S-Insert> is linux default for the `*` register
	nmap <Insert> "+p
	cmap <Insert> "+p
	imap <Insert> <Esc>"+pa
	nmap <S-Insert> "*p
	cmap <S-Insert> "*p
endif
" <Leader> version of copy/paste to system clipboard
vmap <Leader>y "+y
vmap <Leader>x "+x
vmap <Leader>d "+d
vmap <Leader>p "+p


" =========================================================
" global settings (no vscode)
" =========================================================
if ! exists('g:vscode')
" exlcude all of the following config for vscode setup

	colorscheme anotherdark

	" fileencoding
	set encoding=utf-8

	" automatically read a file that has changed on disk
	set autoread
	" workaround to ensure that we note changed files
	" when focusing the terminal running nvim
	" See https://github.com/neovim/neovim/issues/1936
	au FocusGained * :checktime


	" When the page starts to scroll, keep the curser 8 lines from
	" the top and 4 lines from the bottom
	set scrolloff=4

	" tabwidth of 8 is definitely too much
	" WARNING: printing will though use 8 tabs,
	set tabstop=4
	set softtabstop=4
	set shiftwidth=4
	" allow hidden buffer so they don't have to be saved every time
	set hidden
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


	set diffopt=internal,filler,vertical,hiddenoff

	"----------------------------------------------------------
	" key bindings and mappings
	"----------------------------------------------------------

	" The most important mapping: jj to <esc> in insert mode
	" Escape keys are at different locations at different keyboards (especially
	" on notebooks), so you don't want to mess around with it all the time.
	imap jj <esc>



else  " continue the `if ! exists('g:vscode')`
	" ---------------------------------------------------------
	" Global vscode settings
	" ---------------------------------------------------------
	
	" Get folding working with vscode neovim plugin

	" As of now 06-2024, vscode-neovim doesn't support folding yet:
	" https://github.com/vscode-neovim/vscode-neovim/issues/58
	" Hence I manually set the foling commands to the vscode versions:
	nnoremap zM :call VSCodeNotify('editor.foldAll')<CR>
	nnoremap zR :call VSCodeNotify('editor.unfoldAll')<CR>
	nnoremap zn :call VSCodeNotify('editor.unfoldAll')<CR>
	nnoremap zc :call VSCodeNotify('editor.fold')<CR>
	nnoremap zC :call VSCodeNotify('editor.foldRecursively')<CR>
	nnoremap zo :call VSCodeNotify('editor.unfold')<CR>
	nnoremap zO :call VSCodeNotify('editor.unfoldRecursively')<CR>
	nnoremap za :call VSCodeNotify('editor.toggleFold')<CR>
	
	" following maps j/k to CursorDown/Up in VSCode due to
	" vscode-neovim forcing a nnoremap gj/gk
	nmap j gj
	nmap k gk
endif " no vscode


" =========================================================
" Plugin settings (including vscode)
" =========================================================

" ---------------------------------------------------------
" sandwich
if isdirectory(expand('~/.config/nvim/plugged/vim-sandwich'))
	nmap s <Nop>
	xmap s <Nop>
	let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
else
	" at least define it such that filetype plugins
	" can expand it with +=
	let g:sandwich#recipes = []
endif

" ---------------------------------------------------------
" NERDCommenter
let NERDSpaceDelims=1

" =========================================================
" Plugin settings (no vscode)
" =========================================================
if ! exists('g:vscode')
" exlcude all of the following config for vscode setup

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
	" select features I want:
	let g:pymode_indent = 1
	let g:pymode_folding = 0
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
	" let g:Tex_CompileRule_pdf="lualatex -interaction=nonstopmode -synctex=1 -src-specials --shell-escape $*"
	" let g:Tex_DefaultTargetFormat='pdf'
	" let g:Tex_ViewRule_pdf = 'okular --unique'
	" ---------------------------------------------------------
	" vimtex for latex
	let g:vimtex_view_method = 'zathura'
	let g:vimtex_compiler_latexmk = {
		\ 'build_dir' : '',
		\ 'callback' : 1,
		\ 'continuous' : 1,
		\ 'executable' : 'latexmk',
		\ 'hooks' : [],
		\ 'options' : [
		\   '-verbose',
		\   '-file-line-error',
		\   '-shell-escape',
		\   '-synctex=1',
		\   '-interaction=nonstopmode',
		\ ],
		\}



	" " ---------------------------------------------------------
	" " firenvim
	" if exists('g:started_by_firenvim')
	"   "if lines < 20
	"   "    set lines=20
	"   "endif
	"   au BufEnter github.com_*.txt set filetype=markdown
	"   nnoremap <C-z> :call firenvim#hide_frame()<CR>
	"   nnoremap <Leader>+ :set lines+=5<CR>:set columns+=5<CR>
	"   nnoremap <Leader>- :set lines-=5<CR>:set columns-=5<CR>
	" endif
	" " don't takeover (jupyter) notebooks with firenvim in the browser
	" let g:firenvim_config = { 
	"     \ 'localSettings': {
	"         \ '.*': {
	"             \ 'cmdline': 'neovim',
	"             \ 'priority': 0,
	"             \ 'selector': 'textarea, div[role="textbox"]',
	"             \ 'takeover': 'always',
	"         \ },
	"         \ 'notebooks': {
	"             \ 'priority': 1, 
	"             \ 'takeover': 'never',
	"         \ },
	"     \ },
	" \}

endif  " no vscode

