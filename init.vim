" ========================================================== PLUGINS
" to install new plugin enter add line Plug x, where x is github.com/x of
" the public github repo
" restart vim and call PlugInstall

call plug#begin()

Plug 'vim-scripts/indentpython.vim'
Plug 'vim-python/python-syntax'
Plug 'heavenshell/vim-pydocstring'

" awesome status line below
Plug 'itchyny/lightline.vim'

" open new buffer with overview of the current file
Plug 'vim-voom/voom'

" linter, gotodef, fixer, etc.
Plug 'w0rp/ale'

" identation, keywords, syntax, etc.
Plug 'neovimhaskell/haskell-vim'

call plug#end()

" ================================================ BASIC EDITOR CONF

colorscheme myown

" autoreload on file change

set autoread
au CursorHold,CursorHoldI * checktime

" tmux colorscheme fix
set background=dark

set encoding=utf-8
syntax on

" numbering lines
set number

" autocomplete vim commands, ":" <TAB> will display, second <TAB>
" will cycle through possible options, <S-TAB> backwards
set wildmenu
set wildmode=longest,list,full

" don't hide lines, which cannot be displayed completly
set display+=lastline

" enable up-down lines movement by their visual representation, not numbering
autocmd VimEnter * call ToggleVisualLineMovement()
" \w to toggle
noremap <silent> <Leader>w :call ToggleVisualLineMovement()<CR>

" hit full-stop for undo, comma for redo 
noremap <silent> . :undo<CR>
noremap <silent> , :redo<CR>

" highlight all search results
" disable with :noh command
" highlighting doesn't quite work with tmux :{
set hlsearch

" ??
noremap <buffer> <silent> <C-\> <Esc>
set linebreak
set wrap

" disable ignorecase if there's a capital letter
set smartcase
" always care-insensitive
set ignorecase
" find strings as you type search phrase
set incsearch

set smartindent	
set smarttab
set undolevels=1000

" sane backspace behaviour
set backspace=indent,eol,start	" Backspace behaviour

" highlight TODO and TEMP strngs
let w:m3=matchadd('Search', 'TODO')
let w:m4=matchadd('ErrorMsg', 'TEMP')
let w:m5=matchadd('ErrorMsg', 'ERROR')

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set fileformat=unix

" add yaml stuffs
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
filetype indent off

" ------------------------------------------- w0rp/ale

let g:ale_set_highlights = 0
let g:ale_completion_enabled = 1

" doesn't lint for chagnes in insert, only for changes made in normal
let g:ale_lint_on_insert_leave=1
let g:ale_lint_on_text_changed='normal'

" change default signs
let g:ale_sign_error = '!!'
let g:ale_sign_warning = '!!'
let g:ale_sign_info = '--'
let g:ale_sign_style_error = '--'
let g:ale_sign_style_warning = '--'

" change their colors
highlight ALEErrorSign ctermbg=NONE ctermfg=red cterm=bold
highlight ALEStyleErrorSign ctermbg=NONE ctermfg=yellow
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow

" make left sighns column transparent
highlight SignColumn ctermbg=NONE

" --------------------------------------------- lightline

"  ............customized items on the status line, added linter info
let g:lightline = {
	\ 'active': {
	\   'left': [ [ 'mode', 'paste' ],
	\             [ 'readonly', 'filename', 'modified' ] ], 
	\   'right': [ [ 'lineinfo' ],
	\              [ 'fileformat', 'fileencoding' ],
	\              [ 'linter_info' ] ]
	\ },
	\ 'component': {
	\   'linter_info': '%{LinterStatus()}',
	\ },
	\ }
 
" always display status line
set laststatus=2

" hide mode info, already present in lightline
set noshowmode


" ============================================ C CONF

command GCC ! gcc -std=c99 -o out -Wall -Wextra -Werror %:t
command RUN ! ./out
command GUN w | ! gcc -std=c99 -o out -Wall -Wextra -Werror %:t && ./out

" Use 'C' style program indenting
" wrap the line after 100 chars, no questions asked
au BufNewFile,BufRead *.c
  \ set cindent |	
  \ set textwidth=100 

au BufNewFile,BufRead *.c
  \ set cindent		" Use 'C' style program indenting

" ------------------------------------------- w0rp/ale

let g:ale_linters = {'c': ['gcc', 'clangtidy', 'clang-format'], 'cpp': ['clang', 'gcc' ]}
let g:ale_c_gcc_executable = 'gcc'
let g:ale_c_gcc_options = '-std=c99 -Wall -Wextra -pedantic'
let g:ale_c_clang_executable = 'gcc'
let g:ale_c_clang_options = '-std=c99 -Wall -Wextra -pedantic'
let g:ale_c_clangtidy_executable = 'clang-tidy'
let g:ale_c_clangtidy_options = '-std=c99 -Wall -Wextra -pedantic'

" CXX      = /packages/run.64/gcc-9.2/bin/c++
" TIDY     = /packages/run.64/llvm-9.0.1/bin/clang-tidy
" CXXFLAGS = -std=c++17 -Wall -Wextra -Werror -g
" BIN      = gttt

let g:ale_cpp_clang_executable = 'clang++-6.0'
let g:ale_cpp_clang_options = '-std=c++17 -Wall -Wextra -pedantic'
let g:ale_cpp_clangtidy_checks = []
let g:ale_cpp_clangtidy_executable = 'clang-tidy'
let g:ale_cpp_clangtidy_extra_options = ''
let g:ale_cpp_clangtidy_options = ''
let g:ale_cpp_gcc_executable = 'gcc'
let g:ale_cpp_gcc_options = '-std=c++17 -Wall -Wextra -pedantic'


" ============================================= PYTHON CONF

" type gggqG to reformat the whole file accoring to autopep8
au FileType python setlocal formatprg=autopep8\ -

"au BufNewFile,BufRead *.py
"  \ set textwidth=100

" yellow highlight from column 77, red from 80
" au BufWinEnter *.py let w:m1=matchadd('Search', '\%<81v.\%>77v', -1)
" au BufWinEnter *.py let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)

" --------------------------------------- w0rp/ale

let g:ale_fixers = {'python': ['autopep8']}
let g:python_highlight_all=1
let g:python_highlight_indent_errors=0
let g:python_highlight_space_errors=0

" ============================================== REST

" ----------------------------------------- ToggleVisualLineMovement
" move lines up or down not by their numbering, but by their visual
" representation

let g:visual_line_movement = 0
function! ToggleVisualLineMovement()
    if g:visual_line_movement
	let g:visual_line_movement = 0

	" remove all changes done below
	" in normal mode
	silent! nunmap <buffer> k
	silent! nunmap <buffer> j
	silent! nunmap <buffer> 0
	silent! nunmap <buffer> $
	silent! nunmap <buffer> <Home>
	silent! nunmap <buffer> <End>
	silent! nunmap <buffer> <Up>
	silent! nunmap <buffer> <Down>

	" for operator-pending commands
	silent! ounmap <buffer> k
	silent! ounmap <buffer> j
	silent! ounmap <buffer> 0
	silent! ounmap <buffer> $
	silent! ounmap <buffer> <Home>
	silent! ounmap <buffer> <End>
	silent! ounmap <buffer> <Up>
	silent! ounmap <buffer> <Down>
    else
	let g:visual_line_movement = 1

	" set remaps, on the left is what I'm pressing
	" on the right is what gets executed
	noremap <buffer> <silent> k gk
	noremap <buffer> <silent> j gj
	noremap <buffer> <silent> 0 g0
	noremap <buffer> <silent> $ g$
	noremap <buffer> <silent> <Up> g<Up>
	noremap <buffer> <silent> <Down> g<Down>
	noremap <buffer> <silent> <Home> g<Home>
	noremap <buffer> <silent> <End> g<End>
    endif
endfunction

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction
