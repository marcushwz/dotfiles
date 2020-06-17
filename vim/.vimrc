call plug#begin('~/.vim/plugged')
:Plug 'sheerun/vim-polyglot'
:Plug 'itchyny/lightline.vim'
:Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = [
  \ 'coc-tsserver'
  \ ]
:Plug 'prettier/vim-prettier', { 'do': 'yarn install', 'for': ['css', 'less', 'scss', 'json', 'graphql', 'vue', 'yaml', 'html', 'ruby', 'javascript', 'typescript'] }
:autocmd BufWritePre *.mjs,*.css,*.less,*.scss,*.json,*.graphql,*.vue,*.yaml,*.html,*.rb,*.tsx,*.jsx,*.ts,*.js PrettierAsync
:Plug 'tpope/vim-fugitive'
:Plug 'preservim/nerdtree'
:Plug 'terryma/vim-multiple-cursors'
:Plug 'preservim/nerdcommenter'
:Plug 'alvan/vim-closetag'
:Plug 'jiangmiao/auto-pairs'
:Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
:Plug 'junegunn/fzf.vim'
:Plug 'Yggdroot/indentLine'
:Plug 'dense-analysis/ale'
:Plug 'slim-template/vim-slim'
:Plug 'maximbaz/lightline-ale'
:Plug 'josa42/vim-lightline-coc'
:Plug 'drewtempelmeyer/palenight.vim'
:Plug 'vimwiki/vimwiki'
:Plug 'haishanh/night-owl.vim'
:Plug 'majutsushi/tagbar'
:Plug 'mileszs/ack.vim'
:Plug 'tpope/vim-rails'
:Plug 'thoughtbot/vim-rspec'
call plug#end()

"Basic
set number
syntax on
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on

" On pressing tab, insert 2 spaces
set expandtab
" show existing tab with 2 spaces width
set tabstop=2
set softtabstop=2
" when indenting with '>', use 2 spaces width
set shiftwidth=2

" To support true color
if (empty($TMUX))
  if (has("nvim"))
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif


"let g:onedark_hide_endofbuffer=1
"let g:onedark_termcolors=256
"let g:onedark_terminal_italics=1
set background=dark
" colorscheme palenight
colorscheme night-owl
let g:palenight_terminal_italics=1
"colorscheme onedark

" Comment's color
hi Comment guifg=orange

" Cursor Line
set cursorline
hi CursorLine guibg=grey33
hi Terminal ctermbg=black ctermfg=green guibg=black guifg=green

set tags=./tags,/home/marcushwz/workspace/postco/tags,/home/marcushwz/workspace/project-tapir/tags
nmap <F8> :TagbarToggle<CR>

" Vim lightline
set laststatus=2
set noshowmode
let g:shades_of_purple_airline = 1
let g:lightline = {
      \ 'colorscheme': 'palenight',
      \ 'component_function': {
      \ 'filename': 'LightlineFilename',
      \}
      \}

let g:lightline.component_expand = {
      \  'ale_linter_checking': 'lightline#ale#checking',
      \  'ale_linter_info': 'lightline#ale#infos',
      \  'ale_linter_warnings': 'lightline#ale#warnings',
      \  'ale_linter_errors': 'lightline#ale#errors',
      \  'ale_linter_ok': 'lightline#ale#ok',
      \ }
let g:lightline.component_type = {
      \     'ale_linter_checking': 'right',
      \     'ale_linter_in': 'right',
      \     'ale_linter_warnings': 'warning',
      \     'ale_linter_errors': 'error',
      \     'ale_linter_ok': 'right',
      \ }
let g:lightline.active = { 
      \  'right': [
      \              ['ale_linter_checking', 'ale_linter_errors', 'ale_linter_warnings', 'ale_linter_in', 'ale_linter_ok' ],
      \               [ 'coc_errors', 'coc_warnings', 'coc_ok' ], ['filetype']
      \                  ] }

call lightline#coc#register()
function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

" Typescript
let g:typescript_indent_disable = 1

" Highlighting for large files
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" Coc display diagnostic
nnoremap <silent> K :call CocAction('doHover')<CR>

" Go to action, definition and reference
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Jumping between errors
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Show error in list
nnoremap <space>d :<C-u>CocList diagnostics<cr>

" Performing code action
nmap <space>f <Plug>(coc-codeaction)

" Open nerd tree at the current file or close nerd tree if pressed again
nnoremap <silent> <expr> <space>n g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"

" use tab to move between autocomplete
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
"if exists('*complete_info')
"  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
"else
"  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"endif

"Auto close tag config
let g:closetag_filenames = '*.html,*.tsx,*.jsx'
let g:closetag_xhtml_filenames = '*.jsx,*.tsx'
let g:closetag_filetypes = 'html,jsx,tsx'
let g:closetag_xhtml_filetypes = 'jsx,tsx'
let g:closetag_regions =  {
\ 'typescript.tsx': 'jsxRegion,tsxRegion',
\ 'javascript.jsx': 'jsxRegion',
\ }
let g:closetag_shortcut = '>'
let g:closetag_close_shortcut = '<leader>>'

" Fzf searching file
nnoremap <C-p> :Files<Cr>

" ripgrep to search for words
nnoremap <C-f> :Rg<Cr>

" indent line dont break by cursorline
let g:indentLine_concealcursor=0

" fugitive short cuts
" fixing conflicts
nnoremap gh :diffget //2<CR>
nnoremap gl :diffget //3<CR>

" opening short preview Gstatus
nmap <space>s :12split<CR>
nmap <space>g :0Git<CR>

" copy to clipboard
set clipboard=unnamedplus

" Nerd commenter follow by space
let NERDSpaceDelims=1
" Align at left
let g:NERDDefaultAlign = 'left'

" Rubocop linting using ale
let g:ale_linters = {
      \   'ruby': ['rubocop'],
      \}
" Only run linters named above
let g:ale_linters_explicit = 1
let g:ale_set_highlights = 0 " Disable highligting

nmap <C-k> :Ack!<space>
nmap <C-l> :ccl<CR>

" close all buffle
nmap <space>q :wqa<CR>

"" Coc Eslint and Prettier
"if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
"  let g:coc_global_extensions += ['coc-prettier']
"endif
"
"if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
"  let g:coc_global_extensions += ['coc-eslint']
"endif

command! -nargs=0 Tsc :call CocAction('runCommand', 'tsserver.watchBuild')

" Ale warning sign
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
highlight ALEWarningSign guifg=yellow
highlight ALEErrorSign guifg=red

" Syntax highligting for config file
au BufEnter,BufRead *conf* setf dosini

let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'
let g:prettier#autoformat_require_pragma = 0
let g:typescript_ignore_typescriptdoc = 1
let g:typescript_ignore_browserwords = 1
 
let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.wiki'}]

autocmd BufNewFile,BufRead *.tsx set ft=typescriptreact
autocmd BufNewFile,BufRead *.ts set ft=typescript

" Vim Rspec
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

if has('terminal')
  command! -nargs=? Term belowright terminal ++rows=10 <args>
  nnoremap <silent> <Leader><c-t> :Term<CR>
  nnoremap <silent> <space>vt :vert term<CR>
  tnoremap <Leader><c-t> exit<CR>
  tnoremap <esc> <c-\><c-n>
end

autocmd InsertEnter * silent !echo -ne "\e[5 q"
autocmd InsertLeave * silent !echo -ne "\e[2 q"
