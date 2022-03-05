colorscheme darkblue
"set textwidth=80
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set number
set rnu
set history=200
set tags=tags;/

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

map <C-n> :call NumberToggle()<cr>
map <C-x> :call HighlightToggle()<cr>
map <F10> :tabe<cr>
map <F11> :tabp<cr>
map <F12> :tabn<cr>

"execute pathogen#infect()
map <F2> :NERDTreeToggle<CR>
map <F3> :NERDTree<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
