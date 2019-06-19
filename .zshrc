#------------------------------------------------------------------------------
# zsh
#------------------------------------------------------------------------------

# zsh-completions
if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
    autoload -U compinit
    compinit
fi

#------------------------------------------------------------------------------
# alias
#------------------------------------------------------------------------------

alias ls='ls -FG'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -la'

#------------------------------------------------------------------------------
# path
#------------------------------------------------------------------------------

PATH=$HOME/bin:$PATH
export PATH

#------------------------------------------------------------------------------
# python
#------------------------------------------------------------------------------

# pyenv
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

# pipenv
if command -v pipenv 1>/dev/null 2>&1; then
    eval "$(pipenv --completion)"
    export PIPENV_VENV_IN_PROJECT=true
fi

# direnv
if command -v direnv 1>/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi

#------------------------------------------------------------------------------
# color
#------------------------------------------------------------------------------

# $fg[color]のフォーマットで色を指定する
autoload -Uz colors
colors

# デフォルト、リセット
DEFAULT=$'%{\e[0;0m%}'
RESET="%{$reset_color%}"

# 0: black
BLACK="%{${fg[black]}%}"
BOLD_BLACK="%{${fg_bold[black]}%}"

# 1: red
RED="%{${fg[red]}%}"
BOLD_RED="%{${fg_bold[red]}%}"

# 2: green
GREEN="%{${fg[green]}%}"
BOLD_GREEN="%{${fg_bold[green]}%}"

# 3: yellow
YELLOW="%{${fg[yellow]}%}"
BOLD_YELLOW="%{${fg_bold[yellow]}%}"

# 4: blue
BLUE="%{${fg[blue]}%}"
BOLD_BLUE="%{${fg_bold[blue]}%}"

# 5: magenta
MAGENTA="%{${fg[magenta]}%}"
BOLD_MAGENTA="%{${fg_bold[magenta]}%}"

# 6: cyan
CYAN="%{${fg[cyan]}%}"
BOLD_CYAN="%{${fg_bold[cyan]}%}"

# 7: white
WHITE="%{${fg[white]}%}"
BOLD_WHITE="%{${fg_bold[white]}%}"

#------------------------------------------------------------------------------
# prompt
#------------------------------------------------------------------------------

case ${UID} in
    # root user
    0)
        PROMPT="${WHITE}[${RESET}${BOLD_RED}%n${RESET}${RED}@${RESET}%m %B%~%b${WHITE}]%#${RESET} "
        PROMPT2="%B${WHITE}%_%#${RESET}%b "
        #SPROMPT="%B${RED}Do you mean %r? [No(n),Yes(y),Abort(a),Edit(e)]:${RESET}%b "
        # SSH
        [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
            PROMPT="${WHITE}[${RESET}${BOLD_RED}%n${RESET}${RED}@${RESET}${BOLD_CYAN}%m${RESET} %B%~%b${WHITE}]%#${RESET} "
        ;;
    # general users
    *)
        PROMPT="${WHITE}[${RESET}%n${RED}@${RESET}%m %B%~%b${WHITE}]%#${RESET} "
        PROMPT2="%B${WHITE}%_%#${RESET}%b "
        #SPROMPT="%B${WHITE}Do you mean ${RED}%r${WHITE}? [No(n),Yes(y),Abort(a),Edit(e)]:${RESET}%b "
        # SSH
        [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
            PROMPT="${WHITE}[${RESET}%n${RED}@${RESET}${BOLD_CYAN}%m${RESET} %B%~%b${WHITE}]%#${RESET} "
        ;;
esac

#------------------------------------------------------------------------------
# git
# http://d.hatena.ne.jp/yonchu/20120506/1336335973
#------------------------------------------------------------------------------

setopt prompt_subst
autoload -Uz add-zsh-hook

#
# Gitの状態表示
#
# 記号について
#   - : WorkingTreeに変更がある場合(Indexにaddしていない変更がある場合)
#   + : Indexに変更がある場合(commitしていない変更がIndexにある場合)
#   ? : Untrackedなファイルがある場合
#   * : remoteにpushしていない場合
#
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true

autoload -Uz is-at-least
if is-at-least 4.3.10; then
    # zshが4.3.10以上の場合
    zstyle ':vcs_info:git:*' check-for-changes true
    zstyle ':vcs_info:git:*' stagedstr "+"
    zstyle ':vcs_info:git:*' unstagedstr "-"
    zstyle ':vcs_info:git:*' formats '%s,%u%c,%b'
    zstyle ':vcs_info:git:*' actionformats '%s,%u%c,%b|%a'
fi

function _update_vcs_info_msg() {
psvar=()
LANG=en_US.UTF-8 vcs_info
local _vcs_name _status  _branch_action
if [ -n "$vcs_info_msg_0_" ]; then
    _vcs_name=$(echo "$vcs_info_msg_0_" | cut -d , -f 1)
    _status=$(_git_untracked_or_not_pushed $(echo "$vcs_info_msg_0_" | cut -d , -f 2))
    _branch_action=$(echo "$vcs_info_msg_0_" | cut -d , -f 3)
    psvar[1]="(${_vcs_name})-[${_status}${_branch_action}]"
fi

# 右側プロンプト
RPROMPT="${RESET}%1(v|${RED}%1v|)${RESET}${BOLD_YELLOW}${VIRTUAL_ENV:+($(basename "$VIRTUAL_ENV"))}${RESET}"
#RPROMPT="${RESET}%1(v|${RED}%1v|)${RESET}${BOLD_YELLOW}${VIRTUAL_ENV:+($(basename "$VIRTUAL_ENV"))}${RESET}[${MAGENTA}%D{%Y/%m/%d %H:%M:%S}${RESET}]${RESET}"
}
add-zsh-hook precmd _update_vcs_info_msg

#
# Untrackedなファイルが存在するか未PUSHなら記号を出力
#   Untracked: ?
#   未PUSH: *
#
function _git_untracked_or_not_pushed() {
local git_status head remotes stagedstr
local  staged_unstaged=$1 not_pushed="*" untracked="?"
# カレントがgitレポジトリ下かどうか判定
if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = "true" ]; then
    # statusをシンプル表示で取得
    git_status=$(git status -s 2> /dev/null)
    # git status -s の先頭が??で始まる行がない場合、Untrackedなファイルは存在しない
    if ! echo "$git_status" | grep "^??" > /dev/null 2>&1; then
        untracked=""
    fi

    # stagedstrを取得
    zstyle -s ":vcs_info:git:*" stagedstr stagedstr
    # git status -s の先頭がAで始まる行があればstagedと判断
    if [ -n "$stagedstr" ] && ! printf "$staged_unstaged" | grep "$stagedstr" > /dev/null 2>&1 \
        && echo "$git_status" | grep "^A" > /dev/null 2>&1; then
    staged_unstaged=${staged_unstaged}${stagedstr}
fi

# HEADのハッシュ値を取得
#  --verify 有効なオブジェクト名として使用できるかを検証
#  --quiet  --verifyと共に使用し、無効なオブジェクトが指定された場合でもエラーメッセージを出さない
#           そのかわり終了ステータスを0以外にする
head=$(git rev-parse --verify -q HEAD 2> /dev/null)
if [ $? -eq 0 ]; then
    # HEADのハッシュ値取得に成功
    # リモートのハッシュ値を配列で取得
    remotes=($(git rev-parse --remotes 2> /dev/null))
    if [ "$remotes[*]" ]; then
        # リモートのハッシュ値取得に成功(リモートが存在する)
        for x in ${remotes[@]}; do
            # リモートとHEADのハッシュ値が一致するか判定
            if [ "$head" = "$x" ]; then
                # 一致した場合はPUSH済み
                not_pushed=""
                break
            fi
        done
    else
        # リモートが存在しない場合
        not_pushed=""
    fi
else
    # HEADが存在しない場合(init直後など)
    not_pushed=""
fi

# Untrackedなファイルが存在するか未PUSHなら記号を出力
if [ -n "$staged_unstaged" -o -n "$untracked" -o -n "$not_pushed" ]; then
    printf "${staged_unstaged}${untracked}${not_pushed}"
fi
    fi
    return 0
}
