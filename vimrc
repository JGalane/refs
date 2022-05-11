
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
" Resources ---------------------- {{{
"   
"   - http://vimcasts.org/episodes/archive/
"   - https://learnvimscriptthehardway.stevelosh.com/
"   - https://thevaluable.dev/vim-commands-beginner/
" }}}
" Basic Settings ---------------------- {{{
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
set autowriteall

" Configure ripgrep
if executable('rg')
    set grepprg=rg\ --vimgrep\ --hidden
else
    echoe "WARNING: Ripgrep not installed"
endif
" }}}
" Status Line ---------------------- {{{
" NOTE: you can view HL groups with :so $VIMRUNTIME/syntax/hitest.vim
set laststatus=2
set statusline= 
set statusline+=%#Keyword#
set statusline+=‹‹\ %n\ ››         " Buffer number
set statusline+=%#Constant#
set statusline+=\ %f               " File path
set statusline+=%#Type#
set statusline+=\ \‹‹\ %y\ ››\     " File type

set statusline+=%#CursorColumn#
set statusline+=%=                 " Switch to the right side
set statusline+=Line\ 
set statusline+=%l                 " Current Line
set statusline+=/
set statusline+=%L                 " Total Lines
set statusline+=\ ::\ Col\ 
set statusline+=%2c                " Current Column
" }}}

" -------------------
" | 2. AUTOCOMMANDS |
" -------------------
" Autocommands ---------------------- {{{
if has('autocmd')
  " Enable filetype detection
  filetype on

  " Grouping everyone together while this list is small
  augroup all_autocmds
      autocmd!

      " Autosurce the vimrc on write
      autocmd BufWritePost vimrc,.vimrc source $MYVIMRC

      " Enable folding for vimscript
      autocmd Filetype vim setlocal foldmethod=marker

      " Opens help menus vertically
      autocmd FileType help wincmd L

      " Custom format settings for different filetypes
      autocmd Filetype vim      :call SetVimEnvironment()
      autocmd FileType text     :call SetTextEnvironment()
      autocmd FileType cpp      :call SetCppEnvironment()
      autocmd FileType java     :call SetJavaEnvironment()
      autocmd FileType python   :call SetPythonEnvironment()
      autocmd FileType plantuml :call SetPlantEnvironment()
      autocmd FileType sh       :call SetBashEnvironment()
      autocmd FileType proto    setlocal ts=2 sw=2 smartindent

      autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
      autocmd BufNewFile,BufFilePre,BufRead *.md :call SetTextEnvironment()
  augroup END
endif
" }}}

" ---------------
" | 3. COMMANDS |
" ---------------
" All ---------------------- {{{
if (&grepprg =~# 'rg')
    :command! -nargs=+ Cppgrep   :call JG_FileSpecGrep('cpp', <q-args>)
    :command! -nargs=+ Javagrep  :call JG_FileSpecGrep('java', <q-args>)
    :command! -nargs=+ Xmlgrep   :call JG_FileSpecGrep('xml', <q-args>)
    :command! -nargs=+ Makegrep  :call JG_FileSpecGrep('make', <q-args>)
    :command! -nargs=+ Protogrep :call JG_FileSpecGrep('proto', <q-args>)
    :command! -nargs=+ Othergrep :call JG_FileSpecGrep('other', <q-args>)
    :command! -nargs=+ Testgrep  :call JG_FileSpecGrep('test', <q-args>)
else
    :command! -nargs=+ Grepcpp :call JG_Warn("TODO: no ripgrep, do regular grep")<cr>
endif
" }}}

" ----------------
" | 4. FUNCTIONS |
" ----------------
" Documentation ---------------------- {{{
"     :help E124               - general function definition guidelines
"     :help expr4              - lists all the expressions for functions
"     :help functions          - list of all the built-in functions
"     :help function-argument  - exactly what it sounds like lol
"     :help internal-variables - variable scopes (and other things)
"     :help local-variables    - exactly what it sounds like
" }}}
" Utility ---------------------- {{{
function! JG_Warn(msg)
    echohl ErrorMsg
    echom a:msg
    echohl NONE
endfunction

function! JG_NumberToggle()
    if(&relativenumber == 1)
        set nornu
        set number
    else
        set rnu
    endif
endfunction

function! JG_HighlightToggle()
    if(&hlsearch == 1)
        set nohlsearch
    else
        set hlsearch
    endif
endfunction
" }}}
" Search/Grep ---------------------- {{{
function! JG_FileSpecGrep(filetype, pattern)
    let ft = &filetype

    if (a:filetype ==? 'cpp')
        let l:fileargs = '*.{cc,hh,cpp,hpp}'
    elseif (a:filetype ==? 'java')
        let l:fileargs = '*.{java}'
    elseif (a:filetype ==? 'proto')
        let l:fileargs = '*.{proto}'
    elseif (a:filetype ==? 'xml')
        let l:fileargs = '*.{xml}'
    elseif (a:filetype ==? 'make')
        let l:fileargs = '*.{mk}'
    elseif (a:filetype ==? 'test')
        let l:fileargs = 'Test*.{cc,hh,cpp,hpp}'
    elseif (a:filetype ==? 'other')
        let l:fileargs = '!*.{cc,hh,cpp,hpp,java,xml,mk,proto}'
    else
        echoe "Invalid filetype"
        return
    endif

    if (&grepprg =~# 'rg')
        silent execute "grep! " . a:pattern . " -g \"" . l:fileargs . "\" ."
    else
        silent execute "grep! -R " . shellescape(@@) . "--include=" . l:fileargs " ."
    endif
    copen
endfunction

function! JG_GrepOperator(type)
    let save_register = @@

    if (a:type ==# 'v')
        "characterwise visual mode
        execute "normal! `<v`>y"
    elseif (a:type ==# 'char')
        "characterwise motion
        execute "normal! `[v`]y"
    elseif (a:type ==# 'V') || (a:type ==# 'line')
        " Not supporting lines for the time being...
        return
    else
        return
    endif

    if (&grepprg =~# 'rg')
        silent execute "grep! " . shellescape(@@)
    else
        silent execute "grep! -R " . shellescape(@@) . " ."
    endif

    copen

    let @@ = save_register
endfunction

function! JG_FileSpecGrepOp(type)
    let save_register = @@

    if (a:type ==# 'v')
        "characterwise visual mode
        execute "normal! `<v`>y"
    elseif (a:type ==# 'char')
        "characterwise motion
        execute "normal! `[v`]y"
    elseif (a:type ==# 'V') || (a:type ==# 'line')
        " Not supporting lines for the time being...
        return
    else
        return
    endif

    :call JG_FileSpecGrep(&filetype, shellescape(@@))

    let @@ = save_register
endfunction

function! JG_FindOperator(type)
    let save_register = @@

    if (a:type ==# 'v') || (a:type ==# 'V')
        "characterwise/line visual mode
        execute "normal! `<v`>y"
    elseif (a:type ==# 'char') || (a:type ==# 'line')
        "characterwise or standard line motion
        execute "normal! `[v`]y"
    else
        return
    endif

    silent execute "lvimgrep! " . @@ . " %"
    
    lopen

    let @@ = save_register
endfunction
" }}}
" Set Environment ---------------------- {{{
function! SetCppEnvironment()
    setlocal textwidth=0
    setlocal tabstop=2
    setlocal shiftwidth=2
    setlocal smartindent

    inoremap <buffer> if@ if ()<cr>{<cr>}<esc><up><up>f)i
    inoremap <buffer> elif@ <up><esc>/}<cr>a<cr>else if ()<cr>{<cr>}<esc><up><up>f)i
    inoremap <buffer> el@ <up><esc>/}<cr>a<cr>else<cr>{<cr>}<esc>O
    inoremap <buffer> for@ for ()<cr>{<cr>}<esc><up><up>f)i
    inoremap <buffer> fori@ for (size_t i = 0; $; ++i)<cr>{<cr>}<esc><up><up>f$s
    inoremap <buffer> forit@ for (auto it = $; ; ++it)<cr>{<cr>}<esc><up><up>f$s
    inoremap <buffer> switch@ switch ()<cr>{<cr>}<esc>Odefault:<cr>break;<esc>>>?switch<cr>f)i
    inoremap <buffer> while@ while ()<cr>{<cr>}<esc><up><up>f)i

    inoremap <buffer> /** /** <cr><cr>/<up><Space>
    inoremap <buffer> inc@ #include ""<left>
    inoremap <buffer> sup@ std::unique_ptr<><left>
    inoremap <buffer> ss@ std::string<Space>

    inoremap <buffer> LOG LOG(DEVEL, "");<left><left><left>
endfunction

function! SetJavaEnvironment()
    setlocal textwidth=0
    setlocal tabstop=2
    setlocal shiftwidth=2
    setlocal smartindent
    inoremap <buffer> if@ if () {<cr>}<esc><up>f)i
    inoremap <buffer> elif@ <up><esc>/}<cr>a else if () {<cr>}<esc><up>f)i
    inoremap <buffer> el@ <up><esc>/}<cr>a else {<cr>}<esc>O
    inoremap <buffer> for@ for () {<cr>}<esc><up>f)i
    inoremap <buffer> fori@ for (int i = 0; $; i++) {<cr>}<esc><up>f$s
    inoremap <buffer> switch@ switch () {<cr>}<esc>Odefault:<cr>break;<esc>>>?switch<cr>f)i
    inoremap <buffer> while@ while () {<cr>}<esc><up>f)i

    inoremap <buffer> /** /** <cr><cr><left>/<up><Space>

    inoremap <buffer> stack@ new Exception().printStackTrace();
    inoremap <buffer> LOG System.out.println("");<left><left><left>
endfunction

function! SetPythonEnvironment()
    setlocal tabstop=4
    setlocal shiftwidth=4
    setlocal smartindent
    
    inoremap <buffer> if@ if :<left>
    inoremap <buffer> elif@ elif :<left>
    inoremap <buffer> el@ else:<left>
    inoremap <buffer> fori@ for i in :<left>
    inoremap <buffer> forir@ for i in range():<left><left>
    inoremap <buffer> while@ while :<left>

    inoremap <buffer> def@ def ():<esc>F(a
endfunction

function! SetPlantEnvironment()
    setlocal textwidth=0
    setlocal tabstop=4
    setlocal shiftwidth=4
    setlocal smartindent

    inoremap <buffer> uml@ @enduml<esc>O@startuml<esc>o
    inoremap <buffer> nl@ <esc>Inote left of<Space><esc>oend note<esc>O
    inoremap <buffer> nr@ <esc>Inote right of<Space><esc>oend note<esc>O
    inoremap <buffer> no@ <esc>Inote over<Space><esc>oend note<esc>O
endfunction

function! SetBashEnvironment()
    setlocal tabstop=4
    setlocal shiftwidth=4
    setlocal smartindent

    inoremap <buffer> if@ fi<esc>Oif [ $ ]; then<esc>F$s
    inoremap <buffer> el@ <cr>else<cr>
    inoremap <buffer> while@ done<esc>Odo<esc>Owhile [ $ ];<esc>F$s
endfunction

function! SetTextEnvironment()
    setlocal textwidth=90
    setlocal tabstop=4
    setlocal shiftwidth=4
    setlocal smartindent
endfunction

function! SetVimEnvironment()
    setlocal textwidth=0
    setlocal tabstop=4
    setlocal shiftwidth=4
    setlocal smartindent

    inoremap <buffer> cr@ <cr<esc>a>
    inoremap <buffer> do@ <down<esc>a>
    inoremap <buffer> es@ <esc<esc>a>
    inoremap <buffer> le@ <left<esc>a>
    inoremap <buffer> ri@ <right<esc>a>
    inoremap <buffer> sp@ <Space<esc>a>
    inoremap <buffer> up@ <up<esc>a>

    inoremap <buffer> if@ endif<esc>Oif ()<left>
    inoremap <buffer> elif@ elseif ()<esc>i
    inoremap <buffer> el@ else<esc>o
    inoremap <buffer> for@ endfor<esc>Ofor i in<Space>
    inoremap <buffer> while@ endwhile<esc>Owhile<Space>

    inoremap <buffer> fun@ endfunction<esc>Ofunction! ()<left><left>
    inoremap <buffer> aug@ augroup END<esc>Oaugroup<Space>
    inoremap <buffer> em@ echom ""<left>
    inoremap <buffer> imbuf@ inoremap <buffer<esc>a><Space>
    inoremap <buffer> fold@ " }}}<esc>Oi<esc>0Di" $ ---------------------- {{{<esc>F$s
endfunction
" }}}
" Format ---------------------- {{{
function! FormatTextDoc() "TODO: this currently isn't mapped to anything
    " Save the cursor position
    let l = line(".")
    let c = col(".")
    let _s=@/
    " Execute the command
    :normal gggwG
    " Restore cursor position
    call cursor(l, c)
endfunction
" }}}

" ---------------
" | 5. MAPPINGS |
" ---------------
" Nops ---------------------- {{{
noremap <Up>    <Nop>
noremap <Down>  <Nop>
noremap <Left>  <Nop>
noremap <Right> <Nop>
noremap <Space> <Nop>
" }}}
" Utility Mappings ---------------------- {{{
noremap <Space>ve <C-w>v<C-w>l :edit $MYVIMRC<cr>
noremap <Space>vs :source $MYVIMRC<cr>
noremap <Space>n :call JG_NumberToggle()<cr>
noremap <Space>h :call JG_HighlightToggle()<cr>
noremap <Space>o o<cr>
noremap <Space>m :messages<cr>
noremap <Space>r :registers<cr>
noremap <Space>' :marks<cr>
noremap K :help <C-r><C-w><cr>
" }}}
" Movement ---------------------- {{{
noremap H ^
noremap L $
" }}}
" Buffers ---------------------- {{{
noremap [b :bp<cr>
noremap ]b :bn<cr>
noremap <Space>d :bd<cr>
" }}}
" Windows ---------------------- {{{
noremap <C-k> <C-w>k
noremap <C-j> <C-w>j
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l
noremap <Space>ws <C-w>s
noremap <Space>wv <C-w>v<C-w>l
" }}}
" Tabs ---------------------- {{{
noremap <Space>t :tabe<cr>
" }}}
" Quickfix/Location Lists ---------------------- {{{
nnoremap <silent> <Space>f :set operatorfunc=JG_FindOperator<cr>g@
vnoremap <silent> <Space>f :<C-u>call JG_FindOperator(visualmode())<cr>
noremap [l :lprev<cr>
noremap ]l :lnext<cr>
noremap <Space>l :lopen<cr>

nnoremap <silent> <Space>s :set operatorfunc=JG_FileSpecGrepOp<cr>g@
vnoremap <silent> <Space>s :<C-u>call JG_GrepOperator(visualmode())<cr>
nnoremap <silent> <Space>S :set operatorfunc=JG_GrepOperator<cr>g@
vnoremap <silent> <Space>S :<C-u>call JG_GrepOperator(visualmode())<cr>
noremap [q :cp<cr>
noremap ]q :cn<cr>
noremap <Space>q :copen<cr>
" }}}
" Writing/Text ---------------------- {{{
noremap  <Space>u 0yypVr=o
inoremap <C-e> <esc>A
inoremap <C-u> <esc>viwUi
vnoremap <C-q> <esc>`>a"<esc>`<i"<esc>
" }}}
" Abbreviations ---------------------- {{{ 
inoremap (( ()<left>
inoremap {{ {}<left>
inoremap [[ []<left>
inoremap << <><left>
inoremap "" ""<left>
inoremap '' ''<left>

iabbrev waht what
iabbrev tehn then
" }}}
" Operator mappings ---------------------- {{{
" https://learnvimscriptthehardway.stevelosh.com/chapters/15.html
" https://learnvimscriptthehardway.stevelosh.com/chapters/16.html
" }}}

" -------------------
" | 6. PLUGIN STUFF |
" -------------------
execute pathogen#infect()

" CtrlP ---------------------- {{{
map <C-P> :CtrlP<cr>
noremap <Space>b :CtrlPBuffer<cr>
let g:ctrlp_max_files=0
let g:ctrlp_max_height=30
let g:ctrlp_custom_ignore= {
  \ 'dir' : '\v[\/]\.(git)$|log$|Protos$|build-cots$|linux-64$|gen-linux-64$',
  \ 'file': '\v\.(git|log|class|jar|so)$'
  \ }
" }}}
" TagBar ---------------------- {{{
map <F8>  :TagbarToggle<CR>
" }}}
" GitGutter ---------------------- {{{
highlight SignColumn guibg=#000000 ctermbg=0
highlight GitGutterAdd guifg=#000000 ctermfg=2
highlight GitGutterAddLine guifg=#000000 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=4
highlight GitGutterChangeLine guifg=#000000 ctermfg=4
highlight GitGutterDelete guifg=#ff2222 ctermfg=1
highlight GitGutterDeleteLine guifg=#000000 ctermfg=1
" }}}
" Fugitive ---------------------- {{{
noremap <Space>gg :Git<cr>:exe "resize " . (winheight(0) * 1/2)<cr>
noremap <Space>gl :Git log<cr><C-w>k<C-w>L
noremap <Space>gd :Gvdiffsplit!<cr> <C-w>h
noremap <Space>gb :G blame<cr>
" }}}
" Java Syntax ---------------------- {{{
highlight link javaIdentifier NONE
highlight link javaDelimiter NONE
" }}}
" plantuml-syntax ---------------------- {{{
let g:plantuml_executable_script='~/shared/plantuml-1.2022.1.jar'
" }}}
" Vim-cpp-modern ---------------------- {{{
let g:cpp_member_highlight = 1
let g:cpp_simple_highlight = 1
let g:cpp_attributes_hightlight = 1
" }}}
" awesome-color-schemes ---------------------- {{{
" Favorites: focuspoint, alduin, gotham256
" Others: gotham256, solarized8
colorscheme alduin
syntax enable
" }}}

