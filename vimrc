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
set nomodeline                    " CVE-2019-12735
set modelines=0
set tabstop=8
set t_Co=256			  " Support 256 color even if TERM is wrong
set autoindent
set splitright			  " vsplit opens on the right
set number			  " vsplit opens on the right
set completeopt-=preview	  " Hide preview window for things like racer

colorscheme monokai-papertigers

if has("nvim")
	set guicursor= "Don't use | in insert mode
	if !empty(glob("~/.vim/rust-support"))
		set runtimepath+=~/.vim/LanguageClient-neovim
	endif
endif

" Copy to system clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" Paste from system clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

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
	command Mdcat !mdcat % | less -R
endif

" Open ctag in a new tab/buffer
nnoremap <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
nnoremap <leader><C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
nnoremap <leader><C-]> :sp <CR>:exec("tag ".expand("<cword>"))<CR>

" Taken from https://github.com/pfmooney/dotfiles/blob/master/vim/vimrc
" map space-bar to toggle folding
noremap <space> za

function! MyFoldText() " {{{
	let line = getline(v:foldstart)

	let nucolwidth = &fdc + &number * &numberwidth
	let windowwidth = winwidth(0) - nucolwidth
	let foldedlinecount = 1 + v:foldend - v:foldstart

	" expand tabs into spaces
	let onetab = strpart('          ', 0, &tabstop)
	let line = substitute(line, '\t', onetab, 'g')

	let linemsg = '…[' . foldedlinecount . ']'
	let linelimit = (windowwidth  > 80) ? (80 - len(linemsg)) : (windowwidth - len(linemsg))
	let line = strpart(line, 0, linelimit)
	return line . repeat(' ', 80 - len(line) - len(linemsg)) . linemsg
endfunction " }}}
set foldtext=MyFoldText()


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
    au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown spell spelllang=en_us
augroup END

augroup rust
    "au FileType rust nmap gd <Plug>(rust-def)
    au FileType rust nmap gd :LspDefinition<CR>
    au FileType rust nmap gh :LspHover<CR>
    au FileType rust nmap gH <C-w>o<CR>
    au FileType rust nmap gR :LspRename<CR>
    au FileType rust nmap gs <Plug>(rust-def-split)
    au FileType rust nmap gx <Plug>(rust-def-vertical)
    au FileType rust nmap <leader>gd <Plug>(rust-doc)
    au FileType rust nmap <F8> :TagbarToggle<CR>
augroup END

" Taken from https://github.com/pfmooney/dotfiles/blob/master/vim/vimrc
augroup ft_c
	au!

	"colorscheme pmolokai

	" Don't fold comments or '#if 0' blocks
	let c_no_comment_fold = 1
	let c_no_if0_fold = 1

	au FileType c setlocal foldmethod=syntax
	au FileType c setlocal list!
	" shiftround messes with block comments and illumos continuation style
	au FileType c setlocal noshiftround
	au FileType c setlocal ts=8 sw=8 list
	"au FileType c setlocal ts=8 sw=8

augroup END


" Character Listing
set list
set listchars=tab:\>\-
set fillchars=fold:\ ,vert:\|


augroup trailing
	au!
	au BufReadPre * :match ErrorMsg '\s\+$'
	au InsertEnter * :highlight clear ErrorMsg
	au InsertLeave * :highlight ErrorMsg term=reverse cterm=reverse ctermfg=124 guifg=White guibg=Red
augroup END


"Highlight long lines
call lengthmatters#highlight('ctermbg=4 ctermfg=14')

"Highlight whitespace
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

" rust
let g:rustfmt_autosave = 1
if executable('rls')
    let g:lsp_signs_enabled = 1         " enable signs
    let g:lsp_signs_error = {'text': '✗'}
    let g:lsp_signs_warning = {'text': '‼'}
    let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
    inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rls']},
        \ 'whitelist': ['rust'],
        \ })
endif
