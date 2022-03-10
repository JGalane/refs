
" -----------
" | GENERAL |
" -----------
set tabstop=2
set shiftwidth=2
"set textwidth=80
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

if has('autocmd')
  " Enable filetype detection
  filetype on

  " Opens help menus vertically
  autocmd FileType help wincmd L

  " Custom whitespace settings for different filetypes
  autocmd FileType text :call SetTextEnvironment()
  autocmd FileType *.cc,*.hh,*.java,*.proto setlocal ts=2 sw=2 smartindent

  autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
endif

" -------------
" | FUNCTIONS |
" -------------
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


" ------------
" | COMMANDS |
" ------------
":command LogC :normal o LOG(INFO, "");<ESC> F"i
":command LogJ :normal o System.out.println("");<ESC> F"i
":command LineC :normal ^i//<ESC>
":command Vimrc :edit ~/.vimrc
:command Vrc :normal <C-w>v<C-w>l :edit ~/.vimrc


" -----------------------
" | GLORIOUS REMAPPINGS |
" -----------------------
noremap <Up>    <Nop>
noremap <Down>  <Nop>
noremap <Left>  <Nop>
noremap <Right> <Nop>

let mapleader=" "

" Utility Mappings
noremap <Leader>n :call NumberToggle()<cr>
noremap <Leader>h :call HighlightToggle()<cr>
noremap <Leader>i :call FormatTextDoc()<cr>
noremap <Leader>o o<cr>
noremap <Leader>b I<T><Esc> A</T><Esc>F<

" Buffers
noremap <Leader>q :bp<cr>
noremap <Leader>e :bn<cr>
noremap <Leader>r :ls<cr>
noremap <Leader>t :bd<cr>

" Panes
noremap <Leader>f <C-w>s
noremap <Leader>v <C-w>v<C-w>l
noremap <Leader>w <C-w>k
noremap <Leader>s <C-w>j
noremap <Leader>a <C-w>h
noremap <Leader>d <C-w>l

" Tabs
"noremap <Leader>z :tabp<cr>
noremap <Leader>x :tabe<cr>
"noremap <Leader>c :tabn<cr>


" ----------------
" | PLUGIN STUFF |
" ----------------
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
let mapleader="\<tab>"
noremap <Leader>g :Git<cr>:exe "resize " . (winheight(0) * 1/2)<cr>
noremap <Leader>l :Git log<cr><C-w>k<C-w>L
noremap <Leader>d :Gvdiffsplit!<cr> <C-w>h
noremap <Leader>b :G blame<cr>

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
