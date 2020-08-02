" Change default config
set number
set relativenumber
set numberwidth=5
set spell
set nuw=4   " InCRease space between line number and text
set clipboard=unnamed
set cmdheight=1
hi Normal guibg=NONE ctermbg=NONE

" set wildmode=longest

" My keybindings
nnoremap <C-l> $
nnoremap <C-h> ^
" nnoremap jj G
nnoremap <C-j> G
nnoremap <C-k> gg
nnoremap <C-n> :vnew<CR>
nnoremap <C-q> :bd<CR>
filetype plugin indent on

" Split
map <leader>sp :split<CR>
map <leader>vs :vsplit<CR>

" Misc shortcut
nnoremap <leader>a ggVG
map      <leader>q :q<CR>
map      <leader>sq :wq<CR>
map      <leader>s :w<CR>
map      <leader><backspace> :left<CR>

" Move line up and down
nnoremap <Down> :m .+1<CR>==
nnoremap <Up> :m .-2<CR>==
vnoremap <Down> :m '>+1<CR>gv=gv
vnoremap <Up> :m '<-2<CR>gv=gv

" Kill polybar and rerun when polybar config are updated.
autocmd BufWritePost ~/.config/polybar/config !~/.config/polybar/launch.sh &

" Kill sxhkd and rerun when sxhkd config are updated.
" autocmd BufWritePost ~/sxhkdrc !killall sxhkd && sxhkd &

" allow multiple indentation/deindentation in visual mode
vnoremap < <gv
vnoremap > >gv

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)k"

" New delimiters
let g:easy_align_delimiters = {'>':{'pattern':'>>\|=>\|>'},
                              \'<':{'pattern':'<','right_margin':0}}

" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map  <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>W <Plug>(easymotion-bd-w)
nmap <Leader>W <Plug>(easymotion-overwin-w)"

" Insearch
set hlsearch
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
nnoremap <silent> <Esc><Esc> :noh<CR> :call clearmatches()<CR>
" let g:incsearch#auto_nohlsearch = 1

" Lightline
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             ['fugitive', 'readonly', 'filename', 'modified'] ],
      \   'right': [ [ 'filetype' ], [ 'lineinfo' ], ['percent'] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*FugitiveHead")?FugitiveHead():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*FugitiveHead") && ""!=FugitiveHead())'
      \ }
      \ }

function! LightlineFilename()
    return &filetype ==# 'vimfiler' ? vimfiler#get_status_string() :
        \  &filetype ==# 'denite' ? denite#get_status_string() :
        \  &filetype ==# 'vimshell' ? vimshell#get_status_string() :
        \  expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

" Denite
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR>
    \ denite#do_map('do_action')
    nnoremap <silent><buffer><expr> d
    \ denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p
    \ denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> q
    \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> i
    \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <Space>
    \ denite#do_map('toggle_select').'j'
endfunction

" Smart way to move between windows
map h <C-W>h
map l <C-W>l
map j <C-W>j
map k <C-W>k
map <Tab> <C-W><C-W>
map <S-Tab> <C-W>W

" NERDTree
autocmd StdinReadPre * let s:std_in=1
" autocmd vimenter * NERDTree
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
let NERDTreeShowHidden=1
let g:NERDTreeWinPos = "left"

" Folding rules
set foldenable               " enable folding
set foldcolumn=2             " add a fold column
set foldmethod=marker        " detect triple-{ style fold markers
set foldlevelstart=99        " start out with everything unfolded
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
                             " which commands trigger auto-unfold
function! MyFoldText()
    let line = getline(v:foldstart)
    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 4
    return line . ' …' . repeat(" ",fillcharcount) . foldedlinecount . ' '
endfunction
set foldtext=MyFoldText()

" Mappings to easily toggle fold levels
nnoremap z0 :set foldlevel=0<CR>
nnoremap z1 :set foldlevel=1<CR>
nnoremap z2 :set foldlevel=2<CR>
nnoremap z3 :set foldlevel=3<CR>
nnoremap z4 :set foldlevel=4<CR>
nnoremap z5 :set foldlevel=5<CR>

" Cycle through all buffers
map zbn :bnext<CR>
map zpr :bprevious<CR>

" Terminal
" map <leader>` :vert term ++cols=15<CR>

" Resize equal split
map <leader>= <C-W>=

" Auto reload zsh
" autocmd BufWritePost ~/.zshrc execute "normal! :term\<CR>reload\<CR>exit\<CR>"

" Vim comment
nmap <leader>c <Plug>CommentaryLine
vmap <leader>c <Plug>Commentary

" My MaCRo
let @m=":term\<CR>reload\<CR>exit\<CR>"

" Bug fix for ALT key in terminal
" let c='a'
" while c <= 'z'
"     exec "set <A-".c.">=\e".c
"     exec "imap \e".c." <A-".c.">"
"     let c = nr2char(1+char2nr(c))
" endw

" set timeout ttimeoutlen=50

" Tab
nmap <leader>tn :tabnew<CR>
nmap <leader>tc :tabclose<CR>
nmap t :tabnext<CR>
nmap T :tabprevious<CR>

" CTRL-P
" let g:ctrlp_custom_ignore = ''
noremap <C-p> :CtrlPMixed<CR>
set wildignore+=*/tmp/*,*.so,*.o,*.a,*.obj,*.swp,*.zip,*.pyc,*.pyo,*.class,.DS_Store
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'

" FloatTerm
" noremap <leader>` :FloatermNew --wintype=normal --position=right<CR>
nnoremap <silent> <F7>  :FloatermNew --floaterm_autoclose=2 --wintype=floating<CR>
tnoremap <silent> <F7>  <C-\><C-n>:FloatermNew<CR>
nnoremap <silent> <F8>  :FloatermPrev<CR>
tnoremap <silent> <F8>  <C-\><C-n>:FloatermPrev<CR>
nnoremap <silent> <F9>  :FloatermNext<CR>
tnoremap <silent> <F9>  <C-\><C-n>:FloatermNext<CR>
nnoremap <silent> <F12> :FloatermToggle<CR>
tnoremap <silent> <F12> <C-\><C-n>:FloatermToggle<CR>

" fzf
nnoremap f :Files<CR>
nnoremap F :Tags<CR>
" nnoremap <leader>. :Tags<CR>
" nnoremap <A-b> :Buffers<CR>
nnoremap b :Buffers<CR>
nnoremap m :Maps<CR>
" nnoremap <A-m> :Maps<CR>

" Indentline
let g:indentLine_enabled = 1
let g:indentLine_char = '¦'
let g:indentLine_color_term = 239
let g:indentLine_setConceal = 0

" Automatically deletes all trailing whitespace on save.
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e

" Copy and Paste
map <C-c> "+y
" Paste from buffer of terminal
nmap y "*p
" Paste from clipboard (except terminal buffer)
imap <C-y> <ESC>"+pa
nmap <C-y> "+pa

" Gundo
nnoremap <F5> :GundoToggle<CR>
" Fix for Gundo
if has('python3')
    let g:gundo_prefer_python3 = 1
endif

" Upper and lower
function! TwiddleCase(str)
  if a:str ==# toupper(a:str)
    let result = tolower(a:str)
  elseif a:str ==# tolower(a:str)
    let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
  else
    let result = toupper(a:str)
  endif
  return result
endfunction
vnoremap <F3> y:call setreg('', TwiddleCase(@"), getregtype(''))<CR>gv""Pgv

" MDPreview
let g:md_pdf_viewer="zathura"

" Vimtex
nnoremap <leader>v :VimtexView<CR>

" COC completion
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
