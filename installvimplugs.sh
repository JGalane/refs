#!/bin/bash

# Currently using pathogen cause... I'm too lazy to investigate anything else lol
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

cd ~/.vim/bundle

rm -rf *

git clone https://github.com/ctrlpvim/ctrlp.vim.git
git clone https://github.com/preservim/tagbar.git
git clone https://github.com/airblade/vim-gitgutter.git
git clone https://github.com/tpope/vim-fugitive.git
git clone https://github.com/uiiaoo/java-syntax.vim.git
git clone https://github.com/bfrg/vim-cpp-modern.git
git clone https://github.com/aklt/plantuml-syntax.git
git clone https://github.com/vim-scripts/CycleColor.git
git clone https://github.com/rafi/awesome-vim-colorschemes.git
git clone https://github.com/preservim/vim-markdown.git

