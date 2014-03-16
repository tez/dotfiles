"===============================================================================
" Basic
"===============================================================================
" VimをなるべくVi互換にしない
set nocompatible
" キーマップリーダー
let mapleader = ","
" スクロール時の余白確保
set scrolloff=5
" 一行に長い文章を書いていても自動折り返しをしない
set textwidth=0
" バックアップ取らない
set nobackup
" スワップファイル作らない
set noswapfile
" 編集中でも他のファイルを開けるようにする
set hidden
" バックスペースでなんでも消せるようにする
set backspace=indent,eol,start
" テキスト整形オプション，マルチバイトを追加
set formatoptions=lmoq
" ビープをならさない
set vb t_vb=
" Exploreの初期ディレクトリ
set browsedir=buffer
" カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]
" コマンドをステータス行に表示
set showcmd
" 現在のモードを表示
set showmode
" viminfoファイルの設定
set viminfo='50,<1000,s100,\"50
" モードラインは無効
set modelines=0
" Vimを使ってくれてありがとうの非表示
set notitle
" ターミナルでマウスを使用できるようにする
set mouse=a
set guioptions+=a
set ttymouse=xterm2
" ファイルタイプ判定をon
filetype plugin on
" OSのクリップボードを使用する
set clipboard+=unnamed
" ビジュアルモードで選択したテキストが、クリップボードに入るようにする
set clipboard+=autoselect
" 無名レジスタに入るデータを、*レジスタにも入れる。
set clipboard+=unnamedplus
" helpを日本語優先に表示する
set helplang=ja
" MacVimとGVimで挿入モードから抜けるとIMEをOFF
set imdisable
"===============================================================================
" View
"===============================================================================
" 括弧の対応をハイライト
set showmatch
" 行番号表示
set number
" 不可視文字表示
set list
" 不可視文字の表示形式
set listchars=tab:>.,trail:_,extends:>,precedes:<
" 印字不可能文字を16進数で表示
set display=uhex
" 全角スペースの表示
function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction
if has('syntax')
  augroup ZenkakuSpace
    autocmd!
    autocmd ColorScheme       * call ZenkakuSpace()
    autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
  augroup END
  call ZenkakuSpace()
endif
" カーソル行をハイライト
set cursorline
" カレントウィンドウにのみ罫線を引く
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter, BufRead * set cursorline
augroup END
" 全てのハイライトを削除する
" highlight clear CursorLine
" highlight CursorLine gui=underline
" highlight CursorLine ctermbg=black guibg=black
" TODO: 挿入モードの時のみ、カーソル行をハイライトする
set nocursorline
autocmd InsertEnter, InsertLeave * set cursorline
" コマンド実行中は再描画しない
set lazyredraw
" 高速ターミナル接続を行う
set ttyfast
"===============================================================================
" Edit
"===============================================================================
" TODO: ESCでIMEをオフ
set noimdisable
set iminsert=0 imsearch=0
set noimcmdline
inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
" Tabキーを空白に変換
set expandtab
" コンマの後に自動的にスペースを挿入
inoremap , ,<Space>
" Insert mode中で単語単位/行単位の削除をアンドゥ可能にする
inoremap <C-u>  <C-g>u<C-u>
inoremap <C-w>  <C-g>u<C-w>
" :Ptでインデントモード切替
command! Pt :set paste!
" インサートモード中に<C-o>でyankした内容をputする
inoremap <C-o> <ESC>:<C-U>YRPaste 'p'<CR>i
" カーソルから行頭まで削除(インサートモード)
inoremap <silent> <C-k> <Esc>lc^
" カーソルから行末まで削除(インサートモード)
inoremap <silent> <C-d> <Esc>lc$
" カーソルから行頭までヤンク(インサートモード)
inoremap <silent> <C-y>e <Esc>ly0<Insert>
" カーソルから行末までヤンク(インサートモード)
inoremap <silent> <C-y>0 <Esc>ly$<Insert>
" 保存時に行末の空白を除去する
autocmd BufWritePre * :%s/\s\+$//ge
" 保存時にtabをスペースに変換する
autocmd BufWritePre * :%s/\t/  /ge
" 日時の自動入力
inoremap <expr> ,df strftime('%Y/%m/%d %H:%M:%S')
inoremap <expr> ,dd strftime('%Y/%m/%d')
inoremap <expr> ,dt strftime('%H:%M:%S')
"===============================================================================
" Move
"===============================================================================
" カーソルを表示行で移動する
nnoremap h <Left>
nnoremap j gj
nnoremap k gk
nnoremap l <Right>
nnoremap <Down> gj
nnoremap <Up>   gk
" 挿入モードでCtrl+hjklで移動する
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
" 前回終了したカーソル行に移動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
" 最後に編集された位置に移動
nnoremap gb '[
nnoremap gp ']
" 対応する括弧に移動
nnoremap ( %
nnoremap ) %
" 最後に変更されたテキストを選択する
nnoremap gc  `[v`]
vnoremap gc <C-u>normal gc<Enter>
onoremap gc <C-u>normal gc<Enter>
" カーソル位置の単語をyankする
nnoremap vy vawy
" 矩形選択で自由に移動する
set virtualedit+=block
"ビジュアルモード時vで行末まで選択
vnoremap v $h
" CTRL-hjklでウィンドウ移動
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
"===============================================================================
" Find
"===============================================================================
" 最後まで検索したら先頭へ戻る
set wrapscan
" 大文字小文字無視
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" インクリメンタルサーチ
set incsearch
" 検索文字をハイライト
set hlsearch
"選択した文字列を検索
vnoremap <silent> // y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
"選択した文字列を置換
vnoremap /r "xy;%s/<C-R>=escape(@x, '\\/.*$^~[]')<CR>//gc<Left><Left><Left>
"s*置換後文字列/g<Cr>でカーソル下のキーワードを置換
nnoremap <expr> s* ':%substitute/\<' . expand('<cword>') . '\>/'
" Ctrl-iでヘルプ
nnoremap <C-i>  :<C-u>help<Space>
" カーソル下のキーワードをヘルプでひく
nnoremap <C-i><C-i> :<C-u>help<Space><C-r><C-w><Enter>
" :Gb <args> でGrepBufferする
command! -nargs=1 Gb :GrepBuffer <args>
" カーソル下の単語をGrepBufferする
nnoremap <C-g><C-b> :<C-u>GrepBuffer<Space><C-r><C-w><Enter>
" :Gr <args>でカレントディレクトリ以下を再帰的にgrepする
command! -nargs=1 Gr :Rgrep <args> *<Enter><CR>
" カーソル下の単語をgrepする
nnoremap <silent> <C-g><C-r> :<C-u>Rgrep<Space><C-r><C-w> *<Enter><CR>
let Grep_Skip_Dirs = '.svn .git'
let Grep_Skip_Files = '*.bak *~'
" 検索結果のハイライトをEsc連打でクリアする
nnoremap <ESC><ESC> :nohlsearch<CR>
"===============================================================================
" Comptetion
"===============================================================================
set wildmenu               " コマンド補完を強化
set wildchar=<tab>         " コマンド補完を開始するキー
set wildmode=list:full     " リスト表示，最長マッチ
set history=1000           " コマンド・検索パターンの履歴数
set complete+=k            " 補完に辞書ファイル追加
" Ex-modeでの<C-p><C-n>をzshのヒストリ補完っぽくする
cnoremap <C-p> <Up>
cnoremap <Up>  <C-p>
cnoremap <C-n> <Down>
cnoremap <Down>  <C-n>

"===============================================================================
" Encodeing
"===============================================================================
set ffs=unix,dos,mac  " 改行文字
set encoding=utf-8    " デフォルトエンコーディング
" 文字コードをutf-8に設定
autocmd FileType svn :set fileencoding=utf-8
autocmd FileType js :set fileencoding=utf-8
autocmd FileType css :set fileencoding=utf-8
autocmd FileType html :set fileencoding=utf-8
autocmd FileType xml :set fileencoding=utf-8
autocmd FileType java :set fileencoding=utf-8
autocmd FileType scala :set fileencoding=utf-8
" ワイルドカードで表示するときに優先度を低くする拡張子
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
" 指定文字コードで強制的にファイルを開く
command! Cp932 edit ++enc=cp932
command! Eucjp edit ++enc=euc-jp
command! Iso2022jp edit ++enc=iso-2022-jp
command! Utf8 edit ++enc=utf-8
command! Jis Iso2022jp
command! Sjis Cp932
"===============================================================================
" Indent
"===============================================================================
" 自動インデント
set autoindent
" スマートインデント
set smartindent
" C言語ライクなインデント
set cindent
" softtabstopはTabキー押し下げ時の挿入される空白の量，0の場合はtabstopと同じ，BSにも影響する
set tabstop=2 shiftwidth=2 softtabstop=0
if has("autocmd")
  "ファイルタイプの検索を有効にする
  filetype plugin on
  "そのファイルタイプにあわせたインデントを利用する
  filetype indent on
  " これらのftではインデントを無効に
  "autocmd FileType php filetype indent off

  autocmd FileType apache     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType aspvbs     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType c          setlocal sw=4 sts=4 ts=4 et
  autocmd FileType cpp        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType cs         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType css        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType diff       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType eruby      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType html       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType java       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType javascript setlocal sw=2 sts=2 ts=2 et
  autocmd FileType perl       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType php        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType haml       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType sh         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType sql        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType vb         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType vim        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType wsh        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType xhtml      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType xml        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType yaml       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType zsh        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType scala      setlocal sw=2 sts=2 ts=2 et
endif
"===============================================================================
" Bundles
"===============================================================================
" Let NeoBundle manage NeoBundle
if has('vim_starting')
   set runtimepath+=~/.vim/bundle/neobundle.vim/
   call neobundle#rc(expand('~/.vim/bundle/'))
endif
NeoBundleFetch 'Shougo/neobundle.vim'
"-------------------------------------------------------------------------------
" 編集
"-------------------------------------------------------------------------------
" NERD_commenter.vim :最強コメント処理 (<Leader>c<space>でコメントをトグル)
NeoBundle 'scrooloose/nerdcommenter.git'
" -- でメソッドチェーン整形
NeoBundle 'c9s/cascading.vim'
" visually indent guide
NeoBundle 'nathanaelkane/vim-indent-guides'
" XMLとかHTMLとかの編集機能を強化する
NeoBundle 'xmledit'
" Align : 高機能整形・桁揃えプラグイン
NeoBundle 'Align'
" フィルタリングと整形
NeoBundle 'godlygeek/tabular'
" マルチバイト対応の整形
NeoBundle 'h1mesuke/vim-alignta'
" undo履歴を追える (need python support)
NeoBundle 'sjl/gundo.vim'
" surround.vim : テキストを括弧で囲む／削除する
NeoBundle 'tpope/vim-surround'
" smartchr.vim : ==などの前後を整形
NeoBundle 'smartchr'
" vim-operator-user : 簡単にoperatorを定義できるようにする
NeoBundle 'operator-user'
" operator-camelize : camel-caseへの変換
NeoBundle 'operator-camelize'
" operator-replace : yankしたものでreplaceする
NeoBundle 'operator-replace'
" textobj-user : 簡単にVimエディタのテキストオブジェクトをつくれる
NeoBundle 'textobj-user'
" vim-textobj-syntax : syntax hilightされたものをtext-objectに
NeoBundle 'kana/vim-textobj-syntax.git'
" vim-textobj-plugins : いろんなものをtext-objectにする
NeoBundle 'thinca/vim-textobj-plugins.git'
" vim-textobj-lastpat : 最後に検索されたパターンをtext-objectに
NeoBundle 'kana/vim-textobj-lastpat.git'
" vim-textobj-indent : インデントされたものをtext-objectに
NeoBundle 'kana/vim-textobj-indent.git'
" vim-textobj-function : 関数の中身をtext-objectに
NeoBundle 'kana/vim-textobj-function.git'
NeoBundle 'textobj-rubyblock'
" vim-textobj-entire : buffer全体をtext-objectに
NeoBundle 'textobj-entire'
" 「foo」 or 【bar】などをtext-objectに
NeoBundle 'textobj-jabraces'
" <C-a>でtrue/false切替。他色々
NeoBundle 'taku-o/vim-toggle'
"
NeoBundle 'AndrewRadev/switch.vim'
"-------------------------------------------------------------------------------
" 補完
"-------------------------------------------------------------------------------
" Neocomplcache : 究極のVim的補完環境
NeoBundle 'Shougo/neocomplcache.vim'
" Neocomplcacheのsinpet補完
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
" various langueages snippets
NeoBundle 'honza/vim-snippets'
" for rsense
NeoBundle 'alpaca-tc/vim-rsense'

"-------------------------------------------------------------------------------
" 検索／移動
"-------------------------------------------------------------------------------
" smooth_scroll.vim : スクロールを賢く
NeoBundle 'Smooth-Scroll'
" vim-smartword : 単語移動がスマートな感じで
NeoBundle 'smartword'
" camelcasemotion : CamelCaseやsnake_case単位でのワード移動
NeoBundle 'camelcasemotion'
" <Leader><Leader>w/fなどで、motion先をhilightする
NeoBundle 'EasyMotion'
" matchit.vim : 「%」による対応括弧へのカーソル移動機能を拡張
NeoBundle 'matchit.zip'
" ruby用のmatchit拡張
NeoBundle 'ruby-matchit'
" grep.vim : 外部のgrep利用。:Grepで対話形式でgrep :Rgrepは再帰
NeoBundle 'grep.vim'
" eregex.vim : vimの正規表現をrubyやperlの正規表現な入力でできる :%S/perlregex/
NeoBundle 'eregex.vim'
" open-browser.vim : カーソルの下のURLを開くor単語を検索エンジンで検索
NeoBundle 'tyru/open-browser.vim'
"-------------------------------------------------------------------------------
" プログラミング
"-------------------------------------------------------------------------------
" quickrun.vim : 編集中のファイルを簡単に実行できるプラグイン
NeoBundle 'thinca/vim-quickrun'
" perldocやphpmanual等のリファレンスをvim上で見る
NeoBundle 'thinca/vim-ref'
" SQLUtilities : SQL整形、生成ユーティリティ
NeoBundle 'SQLUtilities'
" vim-ruby : VimでRubyを扱う際の最も基本的な拡張機能
NeoBundle 'vim-ruby/vim-ruby'
" rails.vim : rails的なアレ
NeoBundle 'tpope/vim-rails'
" Pydiction : Python用の入力補完
NeoBundle 'Pydiction'
" ソースコード上のメソッド宣言、変数宣言の一覧を表示
NeoBundle 'taglist.vim'
" エラーがある場所をhilight
NeoBundle 'errormarker.vim'
" rubycomplete
NeoBundle 'scrooloose/syntastic'
"-------------------------------------------------------------------------------
" 言語
"-------------------------------------------------------------------------------
" haml
NeoBundle 'haml.zip'
" slim
NeoBundle 'slim-template/vim-slim'
" JavaScript
NeoBundle 'JavaScript-syntax'
" jQuery
NeoBundle 'jQuery'
" nginx conf
NeoBundle 'nginx.vim'
" markdown
NeoBundle 'tpope/vim-markdown'
" coffee script
NeoBundle 'kchmck/vim-coffee-script'
" python
" flake8
NeoBundleLazy 'hynek/vim-python-pep8-indent', {
    \ "autoload": {"insert": 1, "filetypes": ["python", "python3", "djangohtml"]}}
" scala
NeoBundle 'derekwyatt/vim-scala'
" clojure
NeoBundle 'jondistad/vimclojure'
" ghc-mod
NeoBundle 'eagletmt/ghcmod-vim'
" syntax checking plugins exist for eruby, haml, html, javascript, php, python, ruby and sass.
NeoBundle 'scrooloose/syntastic'
"-------------------------------------------------------------------------------
" ファイラ
"-------------------------------------------------------------------------------
" DumbBuf.vim : quickbufっぽくbufferを管理。 "<Leader>b<Space>でBufferList
NeoBundle 'DumbBuf'
" minibufexpl.vim : タブエディタ風にバッファ管理ウィンドウを表示
NeoBundle 'minibufexpl.vim'
" NERDTree : ツリー型エクスプローラ
NeoBundle 'The-NERD-tree'
" vtreeexplorer.vim : ツリー状にファイルやディレクトリの一覧を表示
NeoBundle 'vtreeexplorer'
"-------------------------------------------------------------------------------
" エンコード
"-------------------------------------------------------------------------------
NeoBundle 'banyan/recognize_charcode.vim'
"-------------------------------------------------------------------------------
" ユーティリティ
"-------------------------------------------------------------------------------
" vimshell : vimのshell
NeoBundle 'Shougo/vimshell.git'
" vimproc : vimから非同期実行。vimshelleで必要
NeoBundle 'Shougo/vimproc', {
    \ 'build' : {
    \     'windows' : 'make -f make_mingw32.mak',
    \     'cygwin' : 'make -f make_cygwin.mak',
    \     'mac' : 'make -f make_mac.mak',
    \     'unix' : 'make -f make_unix.mak',
    \    },
    \ }
" vim-altercmd : Ex command拡張
NeoBundle 'tyru/vim-altercmd'
" vim Interface to Web API
NeoBundle 'mattn/webapi-vim'
" cecutil.vim : 他のpluginのためのutillity1
NeoBundle 'cecutil'
" urilib.vim : vim scriptからURLを扱うライブラリ
NeoBundle 'tyru/urilib.vim'
" utillity
NeoBundle 'L9'
" Buffer管理のLibrary
NeoBundle 'thinca/vim-openbuf'
" vimdoc 日本語
NeoBundle 'yuroyoro/vimdoc_ja'
" vim上のtwitter client
" NeoBundle 'TwitVim'
" Lingrのclient
NeoBundle 'tsukkee/lingr-vim'
" vimからGit操作する
NeoBundle 'tpope/vim-fugitive'
" ステータスラインをカッコよくする
NeoBundle 'itchyny/lightline.vim'
" A framework to read/write fake:path
NeoBundle 'kana/vim-metarw'
" shows a git diff in the 'gutter' (sign column)
NeoBundle 'airblade/vim-gitgutter'
" git-vim: Plugin files for calling git functions from inside Vim and Syntax files for git displays
NeoBundle 'motemen/git-vim'
" imeを制御
NeoBundle 'bouzuya/vim-ibus'
"-------------------------------------------------------------------------------
" テーマ
"-------------------------------------------------------------------------------
NeoBundle 'desert256.vim'
NeoBundle 'zenorocha/dracula-theme'
NeoBundle 'tomasr/molokai'
NeoBundle 'jpo/vim-railscasts-theme'
"-------------------------------------------------------------------------------
" Unite
"-------------------------------------------------------------------------------
" unite.vim : - すべてを破壊し、すべてを繋げ - vim scriptで実装されたanythingプラグイン
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'tsukkee/unite-help'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'basyura/unite-rails'
NeoBundle 'thinca/vim-unite-history'
NeoBundle 'tsukkee/unite-tag'
NeoBundle 'choplin/unite-vim_hacks'

filetype plugin indent on
NeoBundleCheck

"===============================================================================
" Plugins
"===============================================================================
"-------------------------------------------------------------------------------
" YankRing.vim
"-------------------------------------------------------------------------------
" Yankの履歴参照
nmap ,y ;YRShow<CR>

"-------------------------------------------------------------------------------
" MiniBufExplorer
"-------------------------------------------------------------------------------
"set minibfexp
let g:miniBufExplMapWindowNavVim=1 "hjklで移動
let g:miniBufExplSplitBelow=0  " Put new window above
let g:miniBufExplMapWindowNavArrows=1
let g:miniBufExplMapCTabSwitchBufs=1
let g:miniBufExplModSelTarget=1
let g:miniBufExplSplitToEdge=1
let g:miniBufExplMaxSize = 10

":MtでMiniBufExplorerの表示トグル
command! Mt :TMiniBufExplorer

"-------------------------------------------------------------------------------
" Align
"-------------------------------------------------------------------------------
" Alignを日本語環境で使用するための設定
let g:Align_xstrlen = 3

"-------------------------------------------------------------------------------
" VTreeExplorer
"-------------------------------------------------------------------------------
" 縦に表示する
let g:treeExplVertical=1

"-------------------------------------------------------------------------------
" NERD_commenter.vim
"-------------------------------------------------------------------------------
" コメントの間にスペースを空ける
let NERDSpaceDelims = 1
"<Leader>xでコメントをトグル(NERD_commenter.vim)
map <Leader>x, c<space>
""未対応ファイルタイプのエラーメッセージを表示しない
let NERDShutUp=1

" ------------------------------------
" grep.vim
"-------------------------------------------------------------------------------
" 検索外のディレクトリ、ファイルパターン
let Grep_Skip_Dirs = '.svn .git .hg'
let Grep_Skip_Files = '*.bak *~'

"-------------------------------------------------------------------------------
" surround.vim
"-------------------------------------------------------------------------------
" s, ssで選択範囲を指定文字でくくる
nmap s <Plug>Ysurround
nmap ss <Plug>Yssurround
let g:surround_{char2nr('e')} = "begin \r end"
let g:surround_{char2nr('d')} = "do \r end"
let g:surround_{char2nr("-")} = ":\r"

"-------------------------------------------------------------------------------
" smartchr.vim
"-------------------------------------------------------------------------------
" inoremap <expr> = smartchr#loop('=', '==', '=>')
" inoremap <expr> . smartchr#loop('.',  '->', '=>')

"
" " 演算子の間に空白を入れる
" inoremap <buffer><expr> + smartchr#one_of(' + ', ' ++ ', '+')
" inoremap <buffer><expr> +=  smartchr#one_of(' += ')
" " inoremap <buffer><expr> - smartchr#one_of(' - ', ' -- ', '-')
" inoremap <buffer><expr> -=  smartchr#one_of(' -= ')
" " inoremap <buffer><expr> / smartchr#one_of(' / ', ' // ', '/')
" inoremap <buffer><expr> /=  smartchr#one_of(' /= ')
" inoremap <buffer><expr> * smartchr#one_of(' * ', ' ** ', '*')
" inoremap <buffer><expr> *=  smartchr#one_of(' *= ')
" inoremap <buffer><expr> & smartchr#one_of(' & ', ' && ', '&')
" inoremap <buffer><expr> % smartchr#one_of(' % ', '%')
" inoremap <buffer><expr> =>  smartchr#one_of(' => ')
" inoremap <buffer><expr> <-   smartchr#one_of(' <-  ')
" inoremap <buffer><expr> <Bar> smartchr#one_of(' <Bar> ', ' <Bar><Bar> ', '<Bar>')
" inoremap <buffer><expr> , smartchr#one_of(', ', ',')
" " 3項演算子の場合は、後ろのみ空白を入れる
" inoremap <buffer><expr> ? smartchr#one_of('? ', '?')
" " inoremap <buffer><expr> : smartchr#one_of(': ', '::', ':')

" " =の場合、単純な代入や比較演算子として入力する場合は前後にスペースをいれる。
" " 複合演算代入としての入力の場合は、直前のスペースを削除して=を入力
" inoremap <buffer><expr> = search('¥(&¥<bar><bar>¥<bar>+¥<bar>-¥<bar>/¥<bar>>¥<bar><¥) ¥%#', 'bcn')? '<bs>= '  : search('¥(*¥<bar>!¥)¥%#', 'bcn') ? '= '  : smartchr#one_of(' = ', ' == ', '=')

" " 下記の文字は連続して現れることがまれなので、二回続けて入力したら改行する
" inoremap <buffer><expr> } smartchr#one_of('}', '}<cr>')
" inoremap <buffer><expr> ; smartchr#one_of(';', ';<cr>')
" "()は空白入れる
" inoremap <buffer><expr> ( smartchr#one_of('( ')
" inoremap <buffer><expr> ) smartchr#one_of(' )')

" " if文直後の(は自動で間に空白を入れる
" inoremap <buffer><expr> ( search('¥<¥if¥%#', 'bcn')? ' (': '('


"-------------------------------------------------------------------------------
" Fugitive.vim
"-------------------------------------------------------------------------------
nnoremap <Space>gd :<C-u>Gdiff<Enter>
nnoremap <Space>gs :<C-u>Gstatus<Enter>
nnoremap <Space>gl :<C-u>Glog<Enter>
nnoremap <Space>ga :<C-u>Gwrite<Enter>
nnoremap <Space>gc :<C-u>Gcommit<Enter>
nnoremap <Space>gC :<C-u>Git commit --amend<Enter>
nnoremap <Space>gb :<C-u>Gblame<Enter>


"-------------------------------------------------------------------------------
" BufExplorer
"-------------------------------------------------------------------------------
"<Leader>l<Space>でBufferList
nnoremap <Leader>l<Space> :BufExplorer<CR>

"-------------------------------------------------------------------------------
" VTreeExplorer
"-------------------------------------------------------------------------------
let g:treeExplVertical=1
"<Leader>t<Space>でディレクトリツリー表示
noremap <Leader>t<Space> :VSTreeExplore<CR>
"分割したウィンドウのサイズ
let g:treeExplWinSize=30

"-------------------------------------------------------------------------------
" DumbBuf.vim
"-------------------------------------------------------------------------------
"<Leader>b<Space>でBufferList
let dumbbuf_hotkey = '<Leader>b<Space>'
let dumbbuf_mappings = {
    \ 'n': {
        \'<Esc>': { 'opt': '<silent>', 'mapto': ':<C-u>close<CR>' }
    \}
\}
let dumbbuf_single_key  = 1
let dumbbuf_updatetime  = 1    " &updatetimeの最小値
let dumbbuf_wrap_cursor = 0
let dumbbuf_remove_marked_when_close = 1

"-------------------------------------------------------------------------------
" vim-indent-guides
"-------------------------------------------------------------------------------
nnoremap <silent> <Space>id :<C-u>IndentGuidesToggle<Enter>
let g:indent_guides_auto_colors = 0
let g:indent_guides_start_level = 4
let g:indent_guides_guide_size = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4
if 'dark' == &background
    hi IndentGuidesOdd  ctermbg=black
    hi IndentGuidesEven ctermbg=darkgrey
else
    hi IndentGuidesOdd  ctermbg=white
    hi IndentGuidesEven ctermbg=lightgrey
endif


"-------------------------------------------------------------------------------
" smooth_scroll.vim
"-------------------------------------------------------------------------------
map  :call SmoothScroll("d",1, 1)<CR>
map  :call SmoothScroll("u",1, 1)<CR>

"-------------------------------------------------------------------------------
" gundo.Vim
"-------------------------------------------------------------------------------
" nmap U :<C-u>GundoToggle<CR>

"-------------------------------------------------------------------------------
" taglist.Vim
"-------------------------------------------------------------------------------
" 関数一覧
set tags=tags
"set tags+=~/.tags
let Tlist_Show_One_File = 1               " 現在編集中のソースのタグしか表示しない
let Tlist_Exit_OnlyWindow = 1             " taglistのウィンドーが最後のウィンドーならばVimを閉じる
let Tlist_Enable_Fold_Column = 1          " 折りたたみ
let Tlist_Auto_Open = 1                   " 自動表示
let Tlist_Auto_Update = 1
let Tlist_WinWidth = 30
"map <silent> <leader>tl :Tlist<CR>        " taglistを開くショットカットキー
nmap <F7> :CMiniBufExplorer<CR>:TrinityToggleTagList<CR>:TMiniBufExplorer<CR>
nmap <Leader>tl :CMiniBufExplorer<CR>:TrinityToggleTagList<CR>:TMiniBufExplorer<CR>

"-------------------------------------------------------------------------------
" Srcexp
"-------------------------------------------------------------------------------
" [Srcexpl] tagsを利用したソースコード閲覧・移動補助機能
let g:SrcExpl_UpdateTags    = 1         " tagsをsrcexpl起動時に自動で作成（更新）
let g:SrcExpl_RefreshTime   = 0         " 自動表示するまでの時間(0:off)
let g:SrcExpl_WinHeight     = 9         " プレビューウインドウの高さ
let g:SrcExpl_RefreshMapKey = "<Space>" " 手動表示のMAP
let g:SrcExpl_GoBackMapKey  = "<C-b>"   " 戻る機能のMAP
" Source Explorerの機能ON/OFF
" nmap <F8> :CMiniBufExplorer<CR>:SrcExplToggle<CR>:TMiniBufExplorer<CR>

"-------------------------------------------------------------------------------
" open-blowser.vim
"-------------------------------------------------------------------------------
" カーソル下のURLをブラウザで開く
nmap <Leader>fu <Plug>(openbrowser-open)
vmap <Leader>fu <Plug>(openbrowser-open)
" カーソル下のキーワードをググる
nnoremap <Leader>fs :<C-u>OpenBrowserSearch<Space><C-r><C-w><Enter>

"-------------------------------------------------------------------------------
" operator-camelize.vim
"-------------------------------------------------------------------------------
" camel-caseへの変換
map <Leader>u <Plug>(operator-camelize)
map <Leader>U <Plug>(operator-decamelize)

"-------------------------------------------------------------------------------
" operator-replace.vim
"-------------------------------------------------------------------------------
" RwなどでYankしてるもので置き換える
map R <Plug>(operator-replace)

"-------------------------------------------------------------------------------
" sumartword.vim
"-------------------------------------------------------------------------------
noremap ,w  w
noremap ,b  b
noremap ,e  e
noremap ,ge  ge

map W  <Plug>(smartword-w)
map B  <Plug>(smartword-b)
map E  <Plug>(smartword-e)
map ge  <Plug>(smartword-ge)


"-------------------------------------------------------------------------------
" camelcasemotion.vim
"-------------------------------------------------------------------------------

" <Shift-wbe>でCameCaseやsnake_case単位での単語移動
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
" text-objectで使用できるように
omap <silent> iw <Plug>CamelCaseMotion_iw
xmap <silent> iw <Plug>CamelCaseMotion_iw
omap <silent> ib <Plug>CamelCaseMotion_ib
xmap <silent> ib <Plug>CamelCaseMotion_ib
omap <silent> ie <Plug>CamelCaseMotion_ie
xmap <silent> ie <Plug>CamelCaseMotion_ie

"-------------------------------------------------------------------------------
" errormarker.vim
"-------------------------------------------------------------------------------
" disable default shortcut mapping and re-define to <Leader>ec
let g:errormarker_disablemappings = 1
nmap <silent> <unique> <Leader>ec :ErrorAtCursor<CR>

"-------------------------------------------------------------------------------
" syntastic.vim
"-------------------------------------------------------------------------------
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby'] }
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_quiet_messages = {'level': 'warnings'}

"-------------------------------------------------------------------------------
" vimshell
"-------------------------------------------------------------------------------
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_right_prompt = 'vimshell#vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
let g:vimshell_enable_smart_case = 1

if has('win32') || has('win64')
  " Display user name on Windows.
  let g:vimshell_prompt = $USERNAME."% "
else
  " Display user name on Linux.
  let g:vimshell_prompt = $USER."% "

  call vimshell#set_execute_file('bmp,jpg,png,gif', 'gexe eog')
  call vimshell#set_execute_file('mp3,m4a,ogg', 'gexe amarok')
  let g:vimshell_execute_file_list['zip'] = 'zipinfo'
  call vimshell#set_execute_file('tgz,gz', 'gzcat')
  call vimshell#set_execute_file('tbz,bz2', 'bzcat')
endif

function! g:my_chpwd(args, context)
  call vimshell#execute('echo "chpwd"')
endfunction
function! g:my_emptycmd(cmdline, context)
  call vimshell#execute('echo "emptycmd"')
  return a:cmdline
endfunction
function! g:my_preprompt(args, context)
  call vimshell#execute('echo "preprompt"')
endfunction
function! g:my_preexec(cmdline, context)
  call vimshell#execute('echo "preexec"')

  if a:cmdline =~# '^\s*diff\>'
    call vimshell#set_syntax('diff')
  endif
  return a:cmdline
endfunction

function! VimShellCustomKeyMapping()
  nnoremap <buffer> <C-j> <C-w>j
  nnoremap <buffer> <C-k> <C-w>k
  nnoremap <buffer> <C-l> <C-w>l
  nnoremap <buffer> <C-h> <C-w>h
  inoremap <buffer> <C-j> <C-w>j
  inoremap <buffer> <C-k> <C-w>k
  inoremap <buffer> <C-l> <C-w>l
  inoremap <buffer> <C-h> <C-w>h
endfunction

autocmd FileType vimshell
\ call vimshell#altercmd#define('g', 'git')
\| call vimshell#altercmd#define('i', 'iexe')
\| call vimshell#altercmd#define('l', 'll')
\| call vimshell#altercmd#define('ll', 'ls -l')
\| call vimshell#hook#set('chpwd', ['g:my_chpwd'])
\| call vimshell#hook#set('emptycmd', ['g:my_emptycmd'])
\| call vimshell#hook#set('preprompt', ['g:my_preprompt'])
\| call vimshell#hook#set('preexec', ['g:my_preexec'])

autocmd FileType vimshell call VimShellCustomKeyMapping()
autocmd FileType int-rails call VimShellCustomKeyMapping()
command! Vs :VimShell
command! Vsrc :VimShellInteractive rails console
nmap <Leader>pry :VimShellInteractive pry<CR>
nmap <Leader>irb :VimShellInteractive irb<CR>

"-------------------------------------------------------------------------------
" ime-ibus
"-------------------------------------------------------------------------------
:inoremap <silent> <Esc> <Esc>:<C-u>call ibus#disable()<CR>
:inoremap <silent> <C-j> <C-\><C-o>:<C-u>call ibus#toggle()<CR>

"-------------------------------------------------------------------------------
" unite.vim
"-------------------------------------------------------------------------------
" The prefix key.
nnoremap    [unite]   <Nop>
nmap    f [unite]

nnoremap [unite]u  :<C-u>Unite -no-split<Space>

" 全部乗せ
nnoremap <silent> [unite]a  :<C-u>UniteWithCurrentDir -no-split -buffer-name=files buffer file_mru bookmark file<CR>
" ファイル一覧
nnoremap <silent> [unite]f  :<C-u>Unite -no-split -buffer-name=files file<CR>
" バッファ一覧
nnoremap <silent> [unite]b  :<C-u>Unite -no-split buffer<CR>
" 常用セット
nnoremap <silent> [unite]u  :<C-u>Unite -no-split buffer file_mru<CR>
" 最近使用したファイル一覧
nnoremap <silent> [unite]m  :<C-u>Unite -no-split file_mru<CR>
" 現在のバッファのカレントディレクトリからファイル一覧
nnoremap <silent> [unite]d  :<C-u>UniteWithBufferDir -no-split file<CR>
" snippet一覧
nnoremap <silent> [unite]s  :<C-u>Unite snippet<CR>

" nnoremap <silent> [unite]b  :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>

let g:yankring_zap_keys = ""
" from basyura/unite-rails
nnoremap <silent> [unite]rm  :<C-u>Unite -no-split rails/model<CR>
nnoremap <silent> [unite]rc  :<C-u>Unite -no-split rails/controller<CR>
nnoremap <silent> [unite]rv  :<C-u>Unite -no-split rails/view<CR>
nnoremap <silent> [unite]rl  :<C-u>Unite -no-split rails/lib<CR>
nnoremap <silent> [unite]rj  :<C-u>Unite -no-split rails/javascript<CR>
nnoremap <silent> [unite]rs  :<C-u>Unite -no-split rails/spec<CR>


autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
  " Overwrite settings.

  " ESCキーを2回押すと終了する
  nmap <buffer> <ESC>      <Plug>(unite_exit)
  nmap <buffer> <ESC><ESC> <Plug>(unite_exit)
  imap <buffer> jj      <Plug>(unite_insert_leave)
  nnoremap <silent><buffer> <C-k> :<C-u>call unite#mappings#do_action('preview')<CR>
  imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
  " Start insert.
  let g:unite_enable_start_insert = 1

  " ウィンドウを分割して開く
  nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('split')
  inoremap <silent> <buffer> <expr> <C-l> unite#do_action('split')

  " ウィンドウを縦に分割して開く
  nnoremap <silent> <buffer> <expr> <C-v> unite#do_action('vsplit')
  inoremap <silent> <buffer> <expr> <C-v> unite#do_action('vsplit')
endfunction"}}}

let g:unite_source_file_mru_limit = 200

" unite-plugins
cnoremap UH Unite help<Enter>
cnoremap UO Unite outline<Enter>

"-------------------------------------------------------------------------------
" quickrun.vim
"-------------------------------------------------------------------------------
let g:quickrun_config = {}
let g:quickrun_config._ = {
  \ 'runner' : 'vimproc',
  \ "runner/vimproc/updatetime" : 60,
  \ 'outputter/buffer/split' : ':botright 8sp',
  \ 'outputter/buffer/close_on_empty' : 1
  \}

let g:quickrun_config['rspec/bundle'] = {
  \ 'type': 'rspec/bundle',
  \ 'command': "rspec",
  \ 'cmdopt': "-l %{line('.')}",
  \ 'exec': "bundle exec %c %o %s ",
  \ 'outputter/buffer/filetype': 'rspec-result',
  \ 'filetype': 'rspec-result'
  \}
let g:quickrun_config['rspec/normal'] = {
  \ 'type': 'rspec/normal',
  \ 'command': "rspec",
  \ 'cmdopt': "-l %{line('.')}",
  \ 'exec': '%c %o %s',
  \ 'outputter/buffer/filetype': 'rspec-result',
  \ 'filetype': 'rspec-result'
  \}
function! RSpecQuickrun()
  let b:quickrun_config = {'type' : 'rspec/bundle'}
endfunction

" <C-c> で実行を強制終了させる
" quickrun.vim が実行していない場合には <C-c> を呼び出す
nnoremap <expr><silent> <C-c> quickrun#is_running() ?  quickrun#sweep_sessions() : "\<C-c>"

autocmd BufReadPost *_spec.rb call RSpecQuickrun()
"-------------------------------------------------------------------------------
" Pydiction
"-------------------------------------------------------------------------------
let g:pydiction_location = '~/.vim/bundle/pydiction/complete-dict'

"-------------------------------------------------------------------------------
" Syntastic
"-------------------------------------------------------------------------------
" エラー行をsignで表示する
let g:syntastic_enable_signs = 1
" 可能ならhighligt表示する
let g:syntastic_enable_highlighting = 1
" 自動的に開いたり閉じたりする
let g:syntastic_auto_loc_list=1

"-------------------------------------------------------------------------------
" switch.vim
"-------------------------------------------------------------------------------
nnoremap ! :Switch<CR>
let hooks = neobundle#get_hooks('switch.vim')
function! hooks.on_source(bundle) "{{{
  "{{{
  let g:switch_no_builtins = 0
  let s:switch_definition_builtins = {
        \ }
  let s:switch_definition = {
        \ '_': [
        \   ['is', 'are'],
        \   { '\Cenable': '\Cdisable' },
        \   { '\CEnable': '\CDisable' },
        \   { '\Ctrue': 'false' },
        \   { '\CTrue': 'False' },
        \   { '\Cfalse': 'true' },
        \   { '\CFalse': 'True' },
        \   { '（\([^）]\+\)）' : '(\1)' },
        \   ['left', 'right'],
        \   ['top', 'bottom'],
        \   ['north', 'south'],
        \   ['east', 'west'],
        \   ['under', 'over'],
        \   ['start', 'stop'],
        \   ['begin', 'end', 'finish'],
        \   ['up', 'down'],
        \   ['next', 'previous'],
        \   ['read', 'write'],
        \   ['draw', 'erase'],
        \   ['old', 'new'],
        \   ['open', 'close'],
        \   ['first', 'last'],
        \   ['minminimun', 'maxmaxinum'],
        \   ['yes', 'no'],
        \   ['head', 'tail'],
        \   ['lose', 'find'],
        \   ['in', 'out'],
        \   ['input', 'output'],
        \   ['export', 'import'],
        \   ['large', 'big', 'small'],
        \   ['parent', 'child'],
        \   ['push', 'pull'],
        \   ['fast', 'slow'],
        \   ['good', 'bad'],
        \   ['same', 'different'],
        \   ['add', 'remove'],
        \   ['insert', 'delete'],
        \   ['create', 'destroy'],
        \   ['prefix', 'suffix'],
        \ ],
        \ 'sass,scss,css' : [
        \   ['solid', 'dotted'],
        \   ['left', 'right'],
        \ ],
        \ 'coffee' : [
        \   ['if', 'unless'],
        \   { '^\(.*\)->': '\1=>' },
        \   { '^\(.*\)=>': '\1->' },
        \ ],
        \ 'Gemfile,Berksfile' : [
        \   ['=', '<', '<=', '>', '>=', '~>'],
        \ ],
        \ 'html,php' : [
        \   { '<!--\([a-zA-Z0-9 /]\+\)--></\(div\|ul\|li\|a\)>' : '</\2><!--\1-->' },
        \ ],
        \ 'liquid' : [
        \   ['if', 'unless'],
        \   ['endif', 'endunless'],
        \ ],
        \ 'Rakefile,Gemfile,ruby,ruby.rspec,eruby,haml' : [
        \   ['if', 'unless'],
        \   ['while', 'until'],
        \   ['.blank?', '.present?'],
        \   ['include', 'extend', 'prepend'],
        \   ['class', 'module'],
        \   ['.inject', '.delete_if'],
        \   ['attr_accessor', 'attr_reader', 'attr_writer'],
        \   { '%r\({[^}]\+\)}' : '/\1/' },
        \   { ':\(\k\+\)\s*=>\s*': '\1: ' },
        \   { '\<\(\k\+\): ':      ':\1 => ' },
        \   { '\.\%(tap\)\@!\(\k\+\)':   '.tap { |o| puts o.inspect }.\1' },
        \   { '\.tap { |o| \%(.\{-}\) }': '' },
        \   { '\(\k\+\)(&:\(\S\+\))': '\1 { |x| x\.\2 }' },
        \   { '\(\k\+\)\s\={ |\(\k\+\)| \2.\(\S\+\) }': '\1(&:\3)' },
        \ ],
        \ 'ruby,rdoc' : [
        \   ['=', '==', '===', '====', '====='],
        \   [':nodoc:', ':doc:', ':notnew:'],
        \ ],
        \ 'ruby.application_template' : [
        \   ['yes?', 'no?'],
        \   ['lib', 'initializer', 'file', 'vendor', 'rakefile'],
        \   ['controller', 'model', 'view', 'migration', 'scaffold'],
        \ ],
        \ 'ruby.rspec': [
        \   ['it_has_behavior', 'it_should_behave_like'],
        \   ['describe', 'context', 'specific', 'example'],
        \   ['before', 'after'],
        \   ['be_true', 'be_false'],
        \   ['be_truthy', 'be_falsy'],
        \   ['get', 'post', 'put', 'delete'],
        \   ['==', 'eql', 'equal'],
        \   { '\.should_not': '\.should' },
        \   ['\.to_not', '\.to'],
        \   { '\([^. ]\+\)\.should\(_not\|\)': 'expect(\1)\.to\2' },
        \   { 'expect(\([^. ]\+\))\.to\(_not\|\)': '\1.should\2' },
        \ ],
        \ 'rails' : [
        \   [100, ':continue', ':information'],
        \   [101, ':switching_protocols'],
        \   [102, ':processing'],
        \   [200, ':ok', ':success'],
        \   [201, ':created'],
        \   [202, ':accepted'],
        \   [203, ':non_authoritative_information'],
        \   [204, ':no_content'],
        \   [205, ':reset_content'],
        \   [206, ':partial_content'],
        \   [207, ':multi_status'],
        \   [208, ':already_reported'],
        \   [226, ':im_used'],
        \   [300, ':multiple_choices'],
        \   [301, ':moved_permanently'],
        \   [302, ':found'],
        \   [303, ':see_other'],
        \   [304, ':not_modified'],
        \   [305, ':use_proxy'],
        \   [306, ':reserved'],
        \   [307, ':temporary_redirect'],
        \   [308, ':permanent_redirect'],
        \   [400, ':bad_request'],
        \   [401, ':unauthorized'],
        \   [402, ':payment_required'],
        \   [403, ':forbidden'],
        \   [404, ':not_found'],
        \   [405, ':method_not_allowed'],
        \   [406, ':not_acceptable'],
        \   [407, ':proxy_authentication_required'],
        \   [408, ':request_timeout'],
        \   [409, ':conflict'],
        \   [410, ':gone'],
        \   [411, ':length_required'],
        \   [412, ':precondition_failed'],
        \   [413, ':request_entity_too_large'],
        \   [414, ':request_uri_too_long'],
        \   [415, ':unsupported_media_type'],
        \   [416, ':requested_range_not_satisfiable'],
        \   [417, ':expectation_failed'],
        \   [422, ':unprocessable_entity'],
        \   [423, ':precondition_required'],
        \   [424, ':too_many_requests'],
        \   [426, ':request_header_fields_too_large'],
        \   [500, ':internal_server_error'],
        \   [501, ':not_implemented'],
        \   [502, ':bad_gateway'],
        \   [503, ':service_unavailable'],
        \   [504, ':gateway_timeout'],
        \   [505, ':http_version_not_supported'],
        \   [506, ':variant_also_negotiates'],
        \   [507, ':insufficient_storage'],
        \   [508, ':loop_detected'],
        \   [510, ':not_extended'],
        \   [511, ':network_authentication_required'],
        \ ],
        \ 'apache': [
        \   ['None', 'All']
        \ ],
        \ 'c' : [
        \   ['signed', 'unsigned'],
        \ ],
        \ 'css,scss,sass': [
        \   ['collapse', 'separate'],
        \   ['margin', 'padding'],
        \ ],
        \ 'gitrebase' : [
        \   ['pick', 'reword', 'edit', 'squash', 'fixup', 'exec'],
        \   ['^p\s', 'pick '],
        \   ['^r\s', 'reword '],
        \   ['^e', 'edit '],
        \   ['^s', 'squash '],
        \   ['^f', 'fixup '],
        \   ['^e', 'exec '],
        \ ],
        \ 'vim,Berksfile,Gemfile' : [
        \   { '\vhttps{,1}://github.com/([^/]+)/([^/]+)(\.git){,1}': '\1/\2' },
        \ ],
        \ 'vim' : [
        \   ['call', 'return', 'echo'],
        \   ['NeoBundle', 'NeoBundleLazy'],
        \   ['echo', 'echomsg'],
        \   ['if', 'else'],
        \   { 'let\s\+\([gstb]:\a\+\|\a\+\)\s*\(.\|+\|-\|*\|\\\)\{,1}=\s*\(\a\+\)\s*.*$' : 'unlet \1' },
        \ ],
        \ 'markdown' : [
        \   ['[ ]', '[x]'],
        \   ['#', '##', '###', '####', '#####'],
        \   { '\(\*\*\|__\)\(.*\)\1': '_\2_' },
        \   { '\(\*\|_\)\(.*\)\1': '__\2__' },
        \ ]
        \ }
  "}}}

endfunction"}}}
unlet hooks

"-------------------------------------------------------------------------------
" vim-rails.vim
"-------------------------------------------------------------------------------
let g:rails_some_option = 1
let g:rails_level = 4
let g:rails_syntax = 1
let g:rails_statusline = 1
let g:rails_url='http://localhost:3000'
let g:rails_subversion=0
" let g:dbext_default_SQLITE_bin = 'mysql2'
let g:rails_default_file='config/database.yml'
" let g:rails_ctags_arguments = ''
function! SetUpRailsSetting()
  nmap <buffer><C-C> <Nop>
  imap <buffer><C-C> <Nop>
  map <buffer><C-_><C-C> <Nop>

  nmap <buffer><Space>r :R<CR>
  nmap <buffer><Space>a :A<CR>
  nmap <buffer><Space>m :Rmodel<Space>
  nmap <buffer><Space>c :Rcontroller<Space>
  nmap <buffer><Space>v :Rview<Space>
  nmap <buffer><Space>s :Rspec<Space>
  nmap <buffer><Space>p :Rpreview<CR>
  nmap <buffer><Space>t :Runittest<CR>
  au FileType ruby,eruby,ruby.rspec let g:neocomplete#sources#dictionary#dictionaries = {
        \'ruby' : $HOME.'/.vim/dict/rails.dict',
        \'eruby' : $HOME.'/.vim/dict/rails.dict'
        \}
  setl dict+=~/.vim/dict/rails.dict
  setl dict+=~/.vim/dict/ruby.dict
endfunction
autocmd User Rails call SetUpRailsSetting()

"-------------------------------------------------------------------------------
" GoLang gocde
"-------------------------------------------------------------------------------
set completeopt=menu,preview

"===============================================================================
" Themes & Colors
"===============================================================================
" テーマの設定
colorscheme railscasts
" ターミナルタイプによるカラー設定
set t_Co=256
" ハイライト on
syntax enable

"===============================================================================
" Statusbar (lightline.vim)
"===============================================================================
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
      \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'MyFugitive',
      \   'filename': 'MyFilename',
      \   'fileformat': 'MyFileformat',
      \   'filetype': 'MyFiletype',
      \   'fileencoding': 'MyFileencoding',
      \   'mode': 'MyMode',
      \   'ctrlpmark': 'CtrlPMark',
      \ },
      \ 'component_expand': {
      \   'syntastic': 'SyntasticStatuslineFlag',
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \ },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }

function! MyModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! MyFilename()
  let fname = expand('%:t')
  return fname == 'ControlP' ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ''  " edit here for cool mark
      let _ = fugitive#head()
      return strlen(_) ? mark._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
  if expand('%:t') =~ 'ControlP'
    call lightline#link('iR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
          \ , g:lightline.ctrlp_next], 0)
  else
    return ''
  endif
endfunction

let g:ctrlp_status_func = {
  \ 'main': 'CtrlPStatusFunc_1',
  \ 'prog': 'CtrlPStatusFunc_2',
  \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.c,*.cpp call s:syntastic()
augroup END
function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

"===============================================================================
" AutoComplete (Neocomplcache)
"===============================================================================
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Enable heavy features.
" Use camel case completion.
"let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
"let g:neocomplcache_enable_underbar_completion = 1

" シンタックスをキャッシュするときの最小文字長
let g:neocomplcache_min_syntax_length = 3
" -入力による候補番号の表示
let g:neocomplcache_enable_quick_match = 1

" ポップアップメニューで表示される候補の数。初期値は100
let g:neocomplcache_max_list = 40

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scala' : $HOME.'/.vim/bundle/vim-scala/dict/scala.dict',
    \ 'java' : $HOME.'/.vim/dict/java.dict',
    \ 'c' : $HOME.'/.vim/dict/c.dict',
    \ 'cpp' : $HOME.'/.vim/dict/cpp.dict',
    \ 'javascript' : $HOME.'/.vim/dict/javascript.dict',
    \ 'ocaml' : $HOME.'/.vim/dict/ocaml.dict',
    \ 'perl' : $HOME.'/.vim/dict/perl.dict',
    \ 'php' : $HOME.'/.vim/dict/php.dict',
    \ 'scheme' : $HOME.'/.vim/dict/scheme.dict',
    \ 'vm' : $HOME.'/.vim/dict/vim.dict'
    \ }

" ユーザー定義スニペット保存ディレクトリ
let g:neocomplcache_snippets_dir = $HOME.'/.vim/snippets'

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
" inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><TAB> pumvisible() ? "\<Down>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"  
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() : "\<Space>"

" <C-n> neocomplcache補完 
inoremap <expr><C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>"
" <C-p> keyword補完
inoremap <expr><C-p> pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"
" 補完候補が出ていたら確定、なければ改行
inoremap <expr><CR>  pumvisible() ? neocomplcache#close_popup() : "<CR>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplcache_enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplcache_enable_insert_char_pre = 1

" AutoComplPop like behavior.
let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" buffer開いたらneoconでcache
autocmd BufReadPost,BufEnter,BufWritePost :NeoComplCacheCachingBuffer <buffer>

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'

"インクルードパスの指定
let g:neocomplcache_include_paths = {
  \ 'cpp'  : '.,/opt/local/include/gcc46/c++,/opt/local/include,/usr/include',
  \ 'c'    : '.,/usr/include',
  \ 'ruby' : '.,$HOME/.rbenv/versions/**/lib/ruby/'
  \ }

"インクルード文のパターンを指定
let g:neocomplcache_include_patterns = {
  \ 'cpp' : '^\s*#\s*include',
  \ 'ruby' : '^\s*require',
  \ 'perl' : '^\s*use',
  \ }

"インクルード先のファイル名の解析パターン
let g:neocomplcache_include_exprs = {
  \ 'ruby' : substitute(v:fname,'::','/','g')
  \ }

" ファイルを探す際に、この値を末尾に追加したファイルも探す。
let g:neocomplcache_include_suffixes = {
  \ 'ruby' : '.rb',
  \ 'haskell' : '.hs'
  \ }

" Rsense omni completion
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:rsenseUseOmniFunc = 1
let g:rsenseHome = expand('~/lib/rsense-0.3')

"===============================================================================
" Snippet (Neosnippet)
"===============================================================================
"  Configuration
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory = '~/.vim/snipmate-snippets/snippets ~/.vim/snippets'
"===============================================================================
" Tags
"===============================================================================
" set tags
if has("autochdir")
  " 編集しているファイルのディレクトリに自動で移動
  set autochdir
  set tags=tags;
else
  set tags=./tags,./../tags,./*/tags,./../../tags,./../../../tags,./../../../../tags,./../../../../../tags
endif
set notagbsearch
"tags-and-searchesを使い易くする
nnoremap t  <Nop>
"「飛ぶ」
nnoremap tt  <C-]>
"「進む」
nnoremap tj  ;<C-u>tag<CR>
"「戻る」
nnoremap tk  ;<C-u>pop<CR>
"履歴一覧
nnoremap tl  ;<C-u>tags<CR>
"-------------------------------------------------------------------------------
" Misc
"-------------------------------------------------------------------------------
" ;でコマンド入力( ;と:を入れ替)
noremap ; :

