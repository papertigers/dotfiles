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
set splitright			  " vsplit opens on the right
set number			  " vsplit opens on the right

" Finding files
set path+=** "search recursively
set wildmenu "display all matching files when tab completing

" Tab remappings
nnoremap tn :tabnew<Space>
nnoremap tk :tabnext<CR>
nnoremap tj :tabprev<CR>

" Aliases
cmap w!! w !sudo tee > /dev/null %

" ctags
if executable("ctags")
	command MakeTags !ctags -R .
else
	command MakeTags !exctags -R .
endif

" mdcat
if executable("mdcat")
	command Mdcat !mdcat -c yes % | less -r
endif

" Open ctag in a new tab/buffer
nnoremap <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
nnoremap <leader><C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
nnoremap <leader><C-]> :sp <CR>:exec("tag ".expand("<cword>"))<CR>

" Folding
set foldmethod=syntax
"set foldcolumn=1
let javaScript_fold=1
set foldlevelstart=99
hi Folded ctermbg=Black
hi Folded ctermfg=White

" Theme
set background=dark
set encoding=utf8
set fillchars=""

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  " JavaScript files
  autocmd BufNewFile,BufReadPre,FileReadPre   *.json,*.js setlocal filetype=javascript
  autocmd FileType                            javascript,json  setlocal sw=4 sts=4 et
endif

"Better MD support
augroup markdown
    au!
    au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

augroup rust
    au FileType rust nmap gd <Plug>(rust-def)
    au FileType rust nmap gs <Plug>(rust-def-split)
    au FileType rust nmap gx <Plug>(rust-def-vertical)
    au FileType rust nmap <leader>gd <Plug>(rust-doc)
augroup end

"Hightlight long lines
call lengthmatters#highlight('ctermbg=4 ctermfg=14')
"highlight ColorColumn ctermbg=235 guibg=#2c2d27
"let &colorcolumn=join(range(81,999),",")

"Hightlight whitespace
highlight RedundantWhitespace ctermbg=green guibg=green
match RedundantWhitespace /\s\+$\| \+\ze\t/

" ====== Plugins ======
" Gutter
set updatetime=250
" airline
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tabline#enabled = 1 "display tabs nicely at the top
let g:airline#extensions#tabline#show_buffers = 0
let g:airline_powerline_fonts = 1
let g:airline_theme = "deus"
let g:airline#extensions#whitespace#enabled = 0 "disable annoying whitespace plugin
" go-vim
let g:go_highlight_types = 1
let g:go_highlight_functions = 1
" rust racer
let g:racer_cmd ='~/.cargo/bin/racer'
