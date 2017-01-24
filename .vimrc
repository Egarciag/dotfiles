" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ekchuah vimrc
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"if has('mouse')
"	set mouse=a
"endif

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" Use Unix as the standard file type
set ffs=unix,dos,mac

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

execute pathogen#infect()
