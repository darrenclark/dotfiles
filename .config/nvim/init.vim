"""""""
" Basics
"""""""

syntax on

set mouse=a

set hidden

set ruler

set guicursor=

set completeopt-=preview

" better backspace
set backspace=indent,eol,start

" higlight trailing whitespace + tabs
set list listchars=trail:•,tab:--❭

" Relative line numbers when focused, otherwise regular line numbers
set number
set relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Indentation
set autoindent
set shiftwidth=4
set tabstop=4

" Search - highlight, ignore case (unless search term contains capitals, ENTER
" in normal mode to dismiss
set hlsearch
set ignorecase
set smartcase
nnoremap <CR> :nohlsearch<CR>/<BS><CR>

" Persistent undo
set undofile

" Live substitution
set inccommand=split

"""""""
" Colors
"""""""

set termguicolors
color jellybeans

"""""""
" Language specific
"""""""

"let g:LanguageClient_loggingFile = expand('/tmp/LanguageClient.log')
let g:LanguageClient_serverCommands = {
	\ 'elixir': ['/Users/dclark/bin/elixir-ls/language_server.sh'],
	\ 'eelixir': ['/Users/dclark/bin/elixir-ls/language_server.sh'],
	\ 'kotlin': ['/Users/dclark/bin/KotlinLanguageServer/build/install/kotlin-language-server/bin/kotlin-language-server'],
	\ 'go': ['gopls', '-rpc.trace', '-logfile', '/tmp/gopls.log'],
	\ }

let g:LanguageClient_settingsPath = '/Users/dclark/.config/nvim/settings.json'
let g:LanguageClient_loggingFile = expand('/tmp/nvim-LanguageClient.log')

" Java
autocmd Filetype java setlocal ts=2 sw=2 expandtab

" Ruby
autocmd Filetype ruby setlocal ts=2 sw=2 expandtab

" Javascript
autocmd Filetype javascript setlocal ts=2 sw=2 expandtab

" ejson
au BufRead,BufNewFile *.ejson set filetype=ejson
autocmd Filetype ejson setlocal ts=2 sw=2 expandtab

" Elixir
au BufRead,BufNewFile *.leex set filetype=eelixir
au BufRead,BufNewFile *.heex set filetype=eelixir
autocmd Filetype elixir setlocal ts=2 sw=2 expandtab
autocmd Filetype eelixir setlocal ts=2 sw=2 expandtab

" YAML
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" JSON
autocmd FileType json setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType json syntax match Comment +\/\/.\+$+

" HTML
autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab

" Proto
autocmd FileType proto setlocal ts=2 sts=2 sw=2 expandtab

" CSS
autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab

" Python
autocmd FileType python setlocal tabstop=8 expandtab shiftwidth=4 softtabstop=4

" Kotlin
autocmd FileType kotlin setlocal ts=2 sts=2 sw=2 expandtab

" Shell
autocmd FileType sh setlocal ts=2 sts=2 sw=2 expandtab

" Go
" Run gofmt on save
" autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

" Markdown
autocmd BufRead,BufNewFile *.md setlocal spell

" Jenkinsfile
au BufRead,BufNewFile Jenkinsfile set filetype=groovy
au BufRead,BufNewFile Jenkinsfile setlocal ts=4 sts=4 sw=4 expandtab


"""""""
" Keybindings
"""""""

" Toggle NERDTree
noremap <C-F> :NERDTreeToggle<CR>
vnoremap <C-F> <C-C>:NERDTreeToggle<CR>
inoremap <C-F> <C-O>:NERDTreeToggle<CR>

" Previous tab (Ctrl-H or Ctrl-J)
noremap <C-J> :bp<CR>
noremap <C-H> :bp<CR>
vnoremap <C-J> <C-C>:bp<CR>
vnoremap <C-H> <C-C>:bp<CR>
inoremap <C-J> <C-O>:bp<CR>
inoremap <C-H> <C-O>:bp<CR>

" Next tab (Ctrl-L or Ctrl-K)
noremap <C-K> :bn<CR>
noremap <C-L> :bn<CR>
vnoremap <C-K> <C-C>:bn<CR>
vnoremap <C-L> <C-C>:bn<CR>
inoremap <C-K> <C-O>:bn<CR>
inoremap <C-L> <C-O>:bn<CR>

" Close buffer Ctrl-Q
nnoremap <C-Q> :bd<CR>

" Ctrl-space - fzf / omnicomplete 
nnoremap <C-space> :FZF<CR>
inoremap <C-space> <C-X><C-O>

nnoremap <C-G> :call LanguageClient_textDocument_definition()<CR>

" Running tests
nnoremap <C-P> :call ExRunMixTest()<CR>
"nnoremap <C-[> :call ExRunMixTestFile()<CR>
nnoremap <C-N> :TestLast<CR>
" Flip between source & test files
nnoremap <C-A> :A<CR>

""" Coc.nvim

let g:coc_global_extensions = ['coc-elixir', 'coc-yank']

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Format code
command! -nargs=0 Format :call CocAction('format')

" Organize imports
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Yank list
nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>

"""""""
" Auto reload
"""""""

" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None


"""""""
" FZF / Rg
"""""""

set rtp+=/usr/local/opt/fzf
set rtp+=/usr/share/doc/fzf/examples
set rtp+=/opt/homebrew/opt/fzf
let g:fzf_layout = { 'down': '40%' }

" Ripgrep
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

"""""""
" Git Co-authored-by (w/ FZF)
"""""""

command! -nargs=0 GitCoAuthoredBy
  \ call fzf#run({
  \   'source': 'git log --pretty="Co-authored-by: %an <%ae>" -n 200 | sort -u',
  \   'sink': 'InsertGitCoAuthoredBy'
  \ })

function! InsertGitCoAuthoredBy(author)
  exe "normal! a" . substitute(a:author, "\\", "", "g") . "\<Esc>"
endfunction

command! -nargs=1 InsertGitCoAuthoredBy call InsertGitCoAuthoredBy(<q-args>)

"""""""
" Run test under cursor
"""""""

"function ExRunMixTest()
"  let l:ln = line(".")
"  if l:ln == 1
"    let g:ExRunLastCommand = ":sp term://mix test " . expand("%")
"  else
"    let g:ExRunLastCommand = ":sp term://mix test " . expand("%") . ":" . line(".")
"  end
"  call ExRunMixTestPrev()
"endfunction

let test#strategy = "neovim"

function ExRunMixTest()
  if line(".") == 1
    TestFile
  else
    TestNearest
  end
endfunction

"function! ExMan()
"  echom "ExMan"
"endfunction

"command EM 1delete
command! -nargs=? EM call ExMan(<q-args>)

function! ExMan(...) abort
  if a:0 == 1 && a:1 != ""
	call s:ExManOpen(a:1)
  else
	let first_term = expand("<cword>")
	if first_term =~# '^[A-Z]'
	  call s:ExManOpen(first_term)
	else
	  let oldisk = &iskeyword
	  set iskeyword+=:
	  set iskeyword+=.

	  let term = expand("<cword>")

	  let &iskeyword = oldisk
      call s:ExManOpen(term)
	endif
  endif
endfunction

function s:ExManOpen(term)
  let cmd = "iex -e 'require IEx.Helpers; IEx.Helpers.h(" . a:term . "); exit(:normal)'"
  if a:term =~# '^:'
	let erl_mod = split(a:term, '[\.:]')[0]
	let cmd = "erl -man " . erl_mod . " | cat"
  endif

  execute 'botright new'
  "let cmd = "iex -e 'require IEx.Helpers; IEx.Helpers.h(" . a:term . "); exit(:normal)'"
  call termopen(cmd)
  "au BufDelete <buffer> wincmd p " switch back to last window
  "startinsert
endfunction

  

"function ExRunMixTestPrev()
"  execute g:ExRunLastCommand
"  startinsert
"endfunction
"

""""""
" Projectionist
""""""

let g:projectionist_heuristics = {
      \   "apps/*/mix.exs": {
      \     "apps/*.ex": {"alternate": "apps/{}_test.exs"},
      \     "apps/*_test.exs": {"alternate": "apps/{}.ex"}
      \   },
      \   "mix.exs": {
      \     "lib/*.ex": {"alternate": "test/{}_test.exs"},
      \     "lib/*.html.leex": {"type": "leex", "related": "lib/{}.ex", "alternate": "lib/{}.ex"},
      \     "test/*_test.exs": {"alternate": "lib/{}.ex"}
      \   },
      \   "gradlew": {
      \     "src/main/*.kt": {"alternate": "src/test/{dirname}/Test{basename}.kt"},
      \     "src/test/**/Test*.kt": {"alternate": "src/main/{}.kt"}
      \   }
      \ }

" Open in Github (ruanyl/vim-gh-line)

" Use commit hash instead of branch name
let g:gh_use_canonical = 1
