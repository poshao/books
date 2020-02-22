# VIM 配置C/C++开发环境

### 基础环境
Linux Mint 19.3 Cinnomon(x64)

### 插件安装
1. vim-plug 插件管理器
2. universal-ctags 编译安装

``` sh
git clone --depth=1 https://github.com/universal-ctags/ctags.git
cd ./ctags
./autogen.sh
make
make install
```

### 配置文件
修改~/.vimrc文件

```
" 显示行号
set number

" 高亮代码
syntax on

" 设置中文帮助文档
set helplang=cn

" 禁用兼容模式
set nocompatible

" 使用鼠标
"set mouse=a

"设置编码
set encoding=utf-8

"插件列表(开始)
call plug#begin('~/.vim/plugged')
"==========================================

" 侧边栏(文档目录)
Plug 'scrooloose/nerdtree', { 'on':'NERDTreeToggle' }


"==========================================
call plug#end()

" 目录显示快捷键
nnoremap <F3> :NERDTreeToggle<CR>

```