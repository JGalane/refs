
"  ---------------------
"  | TABLE OF CONTENTS |
"  ---------------------
"  1. GENERAL
"  2. AUTOCOMMANDS
"  3. COMMANDS
"  4. FUNCTIONS
"  5. MAPPINGS 
"  6. PLUGIN STUFF

" --------------
" | 1. GENERAL |
" --------------
set tabstop=2
set shiftwidth=2
set textwidth=0
set expandtab
set smartindent
set autoindent
set number
set nohlsearch
set rnu
set nowrap
set history=200
set updatetime=100
set so=5
set tags=~/tags;/
set noswapfile
set nocompatible


" -------------------
" | 2. AUTOCOMMANDS |
" -------------------
if has('autocmd')
  " Enable filetype detection
  filetype on

  " Grouping everyone together while this list is small
  augroup all_autocmds
      autocmd!

      autocmd BufWritePost vimrc,.vimrc source $MYVIMRC

      " Opens help menus vertically
      autocmd FileType help wincmd L

      " Custom format settings for different filetypes
      autocmd FileType text :call SetTextEnvironment()
      autocmd FileType cpp  :call SetCppEnvironment()
      autocmd FileType java :call SetJavaEnvironment()
      autocmd FileType proto setlocal ts=2 sw=2 smartindent

      autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
      autocmd BufNewFile,BufFilePre,BufRead *.md :call SetTextEnvironment()
  augroup END
endif


" ---------------
" | 3. COMMANDS |
" ---------------
:command! Vrc :normal <C-w>v<C-w>l :edit ~/.vimrc


" ----------------
" | 4. FUNCTIONS |
" ----------------
function! NumberToggle()
    if(&relativenumber == 1)
        set nornu
        set number
    else
        set rnu
    endif
endfunc

function! HighlightToggle()
    if(&hlsearch == 1)
        set nohlsearch
    else
        set hlsearch
    endif
endfunc

function! SetCppEnvironment()
    set tabstop=2
    set shiftwidth=2
    set smartindent
    inoremap <buffer> iff if ()<left>
    inoremap <buffer> LOG LOG(DEVEL, "");<left><left><left>
endfunc

function! SetJavaEnvironment()
    set tabstop=2
    set shiftwidth=2
    set smartindent
    inoremap <buffer> iff if ()<left>
    inoremap <buffer> LOG System.out.println("");<left><left><left>
endfunc

function! SetTextEnvironment()
    set textwidth=90
    set tabstop=4
    set shiftwidth=4
    set smartindent
endfunc

function! FormatTextDoc()
    " Save the cursor position
    let l = line(".")
    let c = col(".")
    let _s=@/
    " Execute the command
    :normal gggwG
    " Restore cursor position
    call cursor(l, c)
endfunc


" ---------------
" | 5. MAPPINGS |
" ---------------
noremap <Up>    <Nop>
noremap <Down>  <Nop>
noremap <Left>  <Nop>
noremap <Right> <Nop>

" Utility Mappings
noremap <Space>ve <C-w>v<C-w>l :edit $MYVIMRC<cr>
noremap <Space>vs :source $MYVIMRC<cr>
noremap <Space>n :call NumberToggle()<cr>
noremap <Space>h :call HighlightToggle()<cr>
noremap <Space>ft :call FormatTextDoc()<cr>
noremap <Space>o o<cr>
noremap <Space>m :messages<cr>

" Movement
noremap H ^
noremap L $

" Buffers
noremap [b :bp<cr>
noremap ]b :bn<cr>
noremap <Space>b :ls<cr>
noremap <Space>d :bd<cr>

" Windows
noremap <C-k> <C-w>k
noremap <C-j> <C-w>j
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l
noremap <Space>s <C-w>s
noremap <Space>v <C-w>v<C-w>l

" Tabs
noremap <Space>t :tabe<cr>

" Quickfix List
noremap [q :cp<cr>
noremap ]q :cn<cr>
noremap <Space>c :clist<cr>
noremap <C-s> :vimgrep /<C-r><C-w>/ %<cr> :clist<cr>

" Writing
inoremap <C-u> <esc>viwUi
vnoremap <C-q> <esc>`>a"<esc>`<i"<esc>

" Abbreviations (just some examples for now so I don't forget)
iabbrev waht what
iabbrev tehn then


" -------------------
" | 6. PLUGIN STUFF |
" -------------------
execute pathogen#infect()

" CtrlP
map <C-p> :CtrlP<cr>
let g:ctrlp_max_files=0
let g:ctrlp_max_height=30
let g:ctrlp_custom_ignore= {
  \ 'dir' : '\v[\/]\.(git)$|log$|Protos$|build-cots$|linux-64$|gen-linux-64$',
  \ 'file': '\v\.(git|log|class|jar|so)$'
  \ }

" TagBar
map <F8>  :TagbarToggle<CR>

" GitGutter
highlight SignColumn guibg=#000000 ctermbg=0
highlight GitGutterAdd guifg=#000000 ctermfg=2
highlight GitGutterAddLine guifg=#000000 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=4
highlight GitGutterChangeLine guifg=#000000 ctermfg=4
highlight GitGutterDelete guifg=#ff2222 ctermfg=1
highlight GitGutterDeleteLine guifg=#000000 ctermfg=1

" Fugitive
noremap <Space>gg :Git<cr>:exe "resize " . (winheight(0) * 1/2)<cr>
noremap <Space>gl :Git log<cr><C-w>k<C-w>L
noremap <Space>gd :Gvdiffsplit!<cr> <C-w>h
noremap <Space>gb :G blame<cr>

" Java Syntax
highlight link javaIdentifier NONE
highlight link javaDelimiter NONE

" plantuml-syntax
let g:plantuml_executable_script='~/shared/plantuml-1.2022.1.jar'

" TODO: Syntastic

" Vim-cpp-modern
let g:cpp_member_highlight = 1
let g:cpp_simple_highlight = 1
let g:cpp_attributes_hightlight = 1

" awesome-color-schemes
colorscheme focuspoint
syntax enable
