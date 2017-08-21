runtime bundle/vim-pathogen/autoload/pathogen.vim
set nocompatible                  " Must come first because it changes other options.

"Pathogen
execute pathogen#infect()

syntax enable                     " Turn on syntax highlighting.
filetype plugin on                " Turn on file type detection.
set showcmd                       " Display incomplete commands.
set showmode                      " Display the mode you're in.
set backspace=indent,eol,start    " Intuitive backspacing.
set hidden                        " Handle multiple buffers better.
set wildmenu                      " Enhanced command line completion.
set wildmode=list:longest         " Complete files like a shell.
set incsearch                     " Highlight matches as you type.
set hlsearch                      " Highlight matches.
set wrap                          " Turn on line wrapping.
set modeline                      " Allow per file config
set tabstop=8
set t_Co=256			 " Support 256 color even if TERM is wrong
set autoindent

" Finding files
set path+=** "search recursively
set wildmenu "display all matching files when tab completing

" Tab remappings
nnoremap tn :tabnew<Space>
nnoremap tk :tabnext<CR>
nnoremap tj :tabprev<CR>

" ctags
if executable("ctags")
	command MakeTags !ctags -R .
else
	command MakeTags !exctags -R .
endif

" Open ctag in a new tab/buffer
nnoremap <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

" Theme
set background=dark
set encoding=utf8
set fillchars=""

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"Better MD support
augroup markdown
    au!
    au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

"Hightlight long lines
call lengthmatters#highlight('ctermbg=4 ctermfg=14')
"highlight ColorColumn ctermbg=235 guibg=#2c2d27
"let &colorcolumn=join(range(81,999),",")

"Hightlight whitespace
highlight RedundantWhitespace ctermbg=green guibg=green
match RedundantWhitespace /\s\+$\| \+\ze\t/

" ====== Plugins ======
"Gutter
set updatetime=250
"airline
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tabline#enabled = 1 "display tabs nicely at the top
