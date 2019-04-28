"------------------------------------------------------------------------------
" Vundle.vim
"------------------------------------------------------------------------------
" おまじない
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" プラグイン
Plugin 'VundleVim/Vundle.vim'
Plugin 'w0ng/vim-hybrid'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'scrooloose/nerdcommenter'
Plugin 'tpope/vim-surround'
Plugin 'vim-syntastic/syntastic'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'davidhalter/jedi-vim'

" おなじない
call vundle#end()
filetype plugin indent on

"------------------------------------------------------------------------------
" nerdtree
"------------------------------------------------------------------------------
" ffキーでON/OFF
nnoremap <silent>ff :NERDTreeToggle<CR>

"------------------------------------------------------------------------------
" vim-fugitive
"------------------------------------------------------------------------------
" gb, gd, gsキーで操作
nnoremap <silent>gb :Gblame<CR>
nnoremap <silent>gd :Gdiff<CR>
nnoremap <silent>gs :Gstatus<CR>

"------------------------------------------------------------------------------
" vim-airline
"------------------------------------------------------------------------------
" カラースキーマ
let g:airline_theme = 'badwolf'

" -- INSERT --などのモード表示をしない
set noshowmode

"------------------------------------------------------------------------------
" vim-indent-guides
"------------------------------------------------------------------------------
" 機能ON/OFF
let g:indent_guides_enable_on_vim_startup = 1

" ガイドラインの幅
let g:indent_guides_guide_size = 1

"------------------------------------------------------------------------------
" nerdcommenter
"------------------------------------------------------------------------------
" コメントした後に挿入するスペースの数
let NERDSpaceDelims = 1

" 空行もコメントアウトする
let g:NERDCommentEmptyLines = 1

" トグル時に全行チェックする
let g:NERDToggleCheckAllLines = 1

" ,,でコメントアウト／アンコメントをトグルする
nmap <silent>,, <Plug>NERDCommenterToggle
vmap <silent>,, <Plug>NERDCommenterToggle

"------------------------------------------------------------------------------
" syntastic
"------------------------------------------------------------------------------
" syntastic推奨設定
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Pythonのチェッカー（flake8, pylintのインストールが必要）
let g:syntastic_python_checkers = ['python', 'flake8', 'pylint']

"------------------------------------------------------------------------------
" jedi-vim
"------------------------------------------------------------------------------
autocmd FileType python setlocal completeopt-=preview

"------------------------------------------------------------------------------
" 表示
"------------------------------------------------------------------------------
" カラースキーマ
let g:hybrid_custom_term_colors = 1
colorscheme hybrid

" 構文ごとに色を変化
syntax on

" 256色モード
set t_Co=256

" 行番号表示
set number

" カーソルがある行・文字位置を表示
set ruler

" 括弧の対応をハイライト
set showmatch

" 不可視文字の表示
set list

" 不可視文字の表示形式
set listchars=tab:▸\ ,trail:_,eol:↵,extends:»,precedes:«,nbsp:%

" 全角スペースの表示
highlight ZenkakuSpace ctermfg=237 cterm=underline
match ZenkakuSpace /　/

" 印字不可文字を16進数で表示
set display=uhex

" □などの文字を全角1文字サイズで表示
if exists('&ambiwidth')
    set ambiwidth=double
endif

" TABの代わりに空白を利用する
set expandtab

" TABが対応する空白の数（表示量）
set tabstop=4

" 自動インデントに使われる空白の数
set shiftwidth=4

" TABの代わりに挿入される空白の数
set softtabstop=4

" 行頭でTABを入力したときにshiftwidthの数だけインデントする
set smarttab

" 自動インデント
set autoindent

" 新しい行を開始したときに現在の行と同じインデントにする
set smartindent

" C言語ライクなインデント
set cindent

" カーソル行をハイライト
set cursorline

" カレントウィンドウにのみ罫線を引く
augroup cch
    autocmd! cch
    autocmd WinLeave * set nocursorline
    autocmd WinEnter,BufRead * set cursorline
augroup END

" 横分割したら新しいウィンドウは下に
set splitbelow

" 縦分割したら新しいウィンドウは右に
set splitright

" 折り返しをしない
" set nowrap

"------------------------------------------------------------------------------
" 検索
"------------------------------------------------------------------------------
" 最後まで検索したら先頭へ戻る
set wrapscan

" 大文字小文字無視
set ignorecase

" 大文字ではじめたら大文字小文字無視しない
set smartcase

" インクリメンタルサーチ
set incsearch

" 検索文字をハイライト
set hlsearch

"------------------------------------------------------------------------------
" システム
"------------------------------------------------------------------------------
" ヤンクとハイライトをクリップボードにコピー
set clipboard=unnamed,autoselect

" 他で書き換えられたら自動で読み直し
set autoread

" バックスペースで改行削除
set backspace=2

" コマンド入力時のファイル名保管
set wildmode=longest,list,full

"------------------------------------------------------------------------------
" 文字コード
"------------------------------------------------------------------------------
" Vim内部エンコーディング
set encoding=utf-8

" Vimの端末出力エンコーディング（default: encodingと同じ）
"set termencoding=utf-8

" エンコーディング判別順序
set fileencodings=utf-8,cp932,euc-jp,iso-2022-jp

"------------------------------------------------------------------------------
" キーマップ
"------------------------------------------------------------------------------
" 表示行単位で上下移動する
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up>   gk
vnoremap j gj
vnoremap k gk
vnoremap <Down> gj
vnoremap <Up>   gk

" C-jをエスケープの代わりに使用する
inoremap <C-j> <esc>
vnoremap <C-j> <esc>

" 括弧の入力を完了したら括弧内に移動する
inoremap {} {}<LEFT>
inoremap [] []<LEFT>
inoremap () ()<LEFT>
inoremap <> <><LEFT>
inoremap "" ""<LEFT>
inoremap '' ''<LEFT>

" インサートモードで左右に移動する
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-b> <Left>
inoremap <C-f> <Right>

"------------------------------------------------------------------------------
" バックアップ
"------------------------------------------------------------------------------
" hoge.txt~のようなバックアップファイルの保存先
"set backupdir=~/.vim/backup

" hoge.txt~のようなバックアップファイルを作成しない
set nobackup

" .swpで表されるスワップファイルの保存先
"set directory=~/.vim/backup

" .swpで表されるスワップファイルを作成しない
set noswapfile

" 前回の編集位置から再開
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\""

"------------------------------------------------------------------------------
" プログラミング
"------------------------------------------------------------------------------
" python
" インデント設定
autocmd FileType python setl autoindent
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl tabstop=8 shiftwidth=4 softtabstop=4 expandtab smarttab

" # を入力したときに自動的に行頭に移動するのを防ぐ
autocmd FileType python :inoremap # X#

" Execute python script C-P 
"function! s:ExecPy()
"    exe "!" . &ft . " %"
":endfunction
"command! Exec call <SID>ExecPy()
"autocmd FileType python map <silent> <C-P> :call <SID>ExecPy()<CR>

" markdown
autocmd! BufNewFile,BufRead *.md,*.mkd setlocal ft=mkd

"------------------------------------------------------------------------------
" テンプレート
"------------------------------------------------------------------------------
" 新しくファイルを作成した時のテンプレート
"augroup templateload
"    autocmd!
"    autocmd BufNewFile *.py 0r ~/.vim/template/template.py
"    autocmd BufNewFile *.py %substitute#__DATE__#\=strftime('%Y-%m-%d')#ge
"augroup end

" カラースキーム用
"function! s:get_syn_id(transparent)
"    let synid = synID(line("."), col("."), 1)
"    if a:transparent
"        return synIDtrans(synid)
"    else
"        return synid
"    endif
"endfunction
"function! s:get_syn_attr(synid)
"    let name = synIDattr(a:synid, "name")
"    let ctermfg = synIDattr(a:synid, "fg", "cterm")
"    let ctermbg = synIDattr(a:synid, "bg", "cterm")
"    let guifg = synIDattr(a:synid, "fg", "gui")
"    let guibg = synIDattr(a:synid, "bg", "gui")
"    return {
"        \ "name": name,
"        \ "ctermfg": ctermfg,
"        \ "ctermbg": ctermbg,
"        \ "guifg": guifg,
"        \ "guibg": guibg}
"endfunction
"function! s:get_syn_info()
"    let baseSyn = s:get_syn_attr(s:get_syn_id(0))
"    echo "name: " . baseSyn.name .
"        \ " ctermfg: " . baseSyn.ctermfg .
"        \ " ctermbg: " . baseSyn.ctermbg .
"        \ " guifg: " . baseSyn.guifg .
"        \ " guibg: " . baseSyn.guibg
"    let linkedSyn = s:get_syn_attr(s:get_syn_id(1))
"    echo "link to"
"    echo "name: " . linkedSyn.name .
"        \ " ctermfg: " . linkedSyn.ctermfg .
"        \ " ctermbg: " . linkedSyn.ctermbg .
"        \ " guifg: " . linkedSyn.guifg .
"        \ " guibg: " . linkedSyn.guibg
"endfunction
"command! SI call s:get_syn_info()

