" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

source ~/.vim/vim-plug.vim

" Custom mapping
let mapleader = ","

"let g:nekomi_noplugin = match(v:argv, '\c--noplugin') > -1 ? 1 : 0

function NekomiLogger(msg)
    let debugFile = $HOME."/.nekomi/debug.vimrc.log"
    if filereadable(debugFile) == 1
        call writefile([strftime("%c") . " - " . a:msg], debugFile, "a")
    endif
endfunc

function NekomiToggleLineNumberMode(mode)
    if a:mode == 0
        augroup nekomiNumberToggle
            autocmd!
            set nonumber "norelativenumber
        augroup END
    elseif a:mode == 1
        set number relativenumber
        augroup nekomiNumberToggle
            autocmd!
            autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
            autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
        augroup END
    else
        augroup nekomiNumberToggle
            autocmd!
            set number "norelativenumber
        augroup END
    endif
endfunction

call NekomiToggleLineNumberMode(1)

if !has("nvim")
    nnoremap <leader>wu :UndotreePersistUndo<cr>
    nnoremap <leader>ut :UndotreeToggle<cr>
    nnoremap <leader>uf :UndotreeFocus<cr>
    nnoremap <leader>nh :noh<cr>
    nnoremap <silent> <leader>lmt :PeekabooGenerateMOMTemplate<cr>
endif

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup    " do not keep a backup file, use versions instead
set history=50  " keep 50 lines of command line history
set ruler       " show the cursor position all the time
set showcmd     " display incomplete commands
set incsearch   " do incremental searching
set nowrap

set belloff=all

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
    set mouse=r
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
    au!

    set textwidth=80

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
                \ if line("'\"") > 1 && line("'\"") <= line("$") |
                \   exe "normal! g`\"" |
                \ endif
augroup END

if !has("nvim")
    " Here are good settings for codebase that uses 4 space characters for each
    " indent.
    set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
endif

set foldmethod=indent
set foldlevelstart=99

let javaScript_fold=1		" JavaScript
let php_folding=1			" PHP
let xml_syntax_folding=1	" XML
let vimsyn_folding='af'		" Vim Script

if !has("nvim")
    nnoremap <silent> <leader>r0 :call NekomiToggleLineNumberMode(0)<cr>
    nnoremap <silent> <leader>r1 :call NekomiToggleLineNumberMode(1)<cr>
    nnoremap <silent> <leader>r2 :call NekomiToggleLineNumberMode(2)<cr>
endif

aug isPager
    au!
    au StdinReadPre * call NekomiToggleLineNumberMode(0)
aug END

let g:GPGDefaultRecipients = ['virtual.singkong@novellpharm.com']

set directory=/tmp/

"source $HOME/.vim/plugin/matchit/plugin/matchit.vim
let b:match_ignorecase=1
let b:match_words = '\<IF\>:\<ELSE\>:\<ENDI,\<SCAN\>:\<ENDS,
            \\<DO\ CASE\>:\<CASE\>:\<OTHE:\<ENDC,
            \\<DO\ WHIL:\<ENDD,\<FOR\>:\<ENDF'

if &diff
    call NekomiLogger("Starting in diff mode.")

    if &diffopt !~ 'iwhite'
        set diffopt+=iwhite
    endif

    map gs :call IwhiteToggle()<CR>

    function! IwhiteToggle()
        if &diffopt =~ 'iwhite'
            set diffopt-=iwhite
        else
            set diffopt+=iwhite
        endif
    endfunction
endif

let g:seiya_auto_enable=1

" Configuration for vim-airline
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

"let g:airline#extensions#tabline#enabled = 1

" Unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''

if !has("nvim")
    let g:airline_theme = 'desertink'
    set laststatus=2
    set noshowmode
    set guioptions=F
    set path+=**

    if !has("nvim")
        " Replace :emoji_name: into Emoji
        nnoremap <silent> <leader>emo
                    \ :%s/:\([^:]\+\):/\=emoji#for(submatch(1),submatch(0))/g\|noh<cr>
    endif
endif

if !has("nvim")
    inoremap ,. <Esc>

    inoremap <leader>wv <Esc>:wviminfo<CR>
    nnoremap <leader>wv :wviminfo<CR>
    inoremap <leader>rv <Esc>:rviminfo<CR>
    nnoremap <leader>rv :rviminfo<CR>

    nnoremap <silent> <leader>ev :tabe $MYVIMRC<cr><c-w>J
    nnoremap <leader>sv :source $MYVIMRC<cr>

    "nnoremap <leader>td "=strftime("%a %b %d, %Y")<CR>P
    "inoremap <leader>td <C-R>=strftime("%a %b %d, %Y")<CR>
    nnoremap <leader>tD "=strftime("%Y-%m-%d")<CR>P
    inoremap <leader>tD <C-R>=strftime("%Y-%m-%d")<CR>
    nnoremap <leader>ts "=strftime('%Y%m%d%H%M%S')<CR>P
    inoremap <leader>ts <C-R>=strftime('%Y%m%d%H%M%S')<CR>

    " Don't use Ex mode, use Q for formatting
    map Q gq

    " CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
    " so that you can undo CTRL-U after inserting a line break.
    inoremap <C-U> <C-G>u<C-U>

    " Allow saving of files as sudo when I forgot to start vim using sudo.
    cmap w!! w !sudo tee > /dev/null %

    " Jump to the next or previous non-empty line
    nnoremap <c-n> <esc>/^[^\ ]<cr>:noh<cr>
    nnoremap <c-m> <esc>?^[^\ ]<cr>:noh<cr>

    " Change to uppercase or lowercase a word both in normal and insert mode.
    inoremap <c-u> <esc>viWUA
    inoremap <c-l> <esc>viWuA
    nnoremap <c-u> m"viwU<esc>`"
    nnoremap <c-l> m"viwu<esc>`"

    " Shortcut workflow with buffers
    nnoremap <leader>b :buffers<cr>:b
    nnoremap <leader>bf :bf<cr>
    nnoremap <leader>bn :bn<cr>
    nnoremap <leader>bp :bp<cr>
    nnoremap <leader>bl :bl<cr>

    " Capitalize every first character on visualized text.
    vnoremap <silent> <leader>uc :s/\%V\v<(.)(\w*)/\u\1\L\2/g <cr>
endif

if !has("nvim")
    " Start Scratch
    nnoremap <leader>sc :setlocal buftype=nofile<cr>
    " Turn on the black hole register
    nnoremap <leader>- "_
endif

let g:GPGFilePattern = '*.{gpg,asc,pgp}{,.wiki,.tex}'
let g:GPGPreferArmor = 1

set thesaurus+=~/.vim/thesaurus/mthesaur.txt

" This enables Vim's and neovim's syntax-related features. Without this, some
" VimTeX features will not work (see ":help vimtex-requirements" for more
" info).
syntax enable

let g:undotree_WindowLayout = 2
let g:undotree_SetFocusWhenToggle = 1

"exec "set undodir=" . $HOME . "/.local/state/vim/undo/"

"Mode Settings
"Cursor settings:
"  1 -> blinking block
"  2 -> solid block
"  3 -> blinking underscore
"  4 -> solid underscore
"  5 -> blinking vertical bar
"  6 -> solid vertical bar
let &t_SI.="\e[5 q" "SI = INSERT mode
"let &t_SR.="\e[4 q" "SR = REPLACE mode
let &t_EI.="\e[2 q" "EI = NORMAL mode (ELSE)

" In order to make the CursorLine and CursorColumn work, I moved them to the
" bottom in the .vimrc script. ~ Mar 8, 2023
"
hi CursorLine   cterm=none ctermbg=darkgray ctermfg=white guibg=darkred guifg=darkgray
hi CursorColumn cterm=NONE ctermbg=none ctermfg=red guibg=NONE guifg=red
set cursorline cursorcolumn

hi Search ctermbg=darkblue
