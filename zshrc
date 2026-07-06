#
# ~/.zshrc
#
# 構成:
#   1. PATH
#   2. 履歴
#   3. 補完 (fish 風のリッチな補完)
#   4. プラグイン
#        - zsh-autosuggestions (fish 風の履歴サジェスト)
#        - oh-my-zsh 由来の clipcopy / copyfile / copypath (自作せず既存資産を利用)
#   5. プロンプト (git ブランチ表示)
#   6. エイリアス
#   7. 関数 (activate / proxy / proxyoff)
#   8. Emacs (vterm) 連携
#   9. プラグイン: zsh-syntax-highlighting (必ず最後に読み込む)
#  10. 依存コマンドチェック
#

# ---------------------------------------------------------------------------
# 1. PATH
# ---------------------------------------------------------------------------

typeset -U path PATH   # 重複を自動的に除去する
path=("$HOME/.local/bin" $path)


# ---------------------------------------------------------------------------
# 2. 履歴
# ---------------------------------------------------------------------------

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt EXTENDED_HISTORY       # タイムスタンプを記録
setopt HIST_IGNORE_DUPS       # 直前と同じコマンドは記録しない
setopt HIST_IGNORE_SPACE      # 先頭がスペースのコマンドは記録しない
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_VERIFY            # !$ などの展開結果を確認してから実行
setopt SHARE_HISTORY          # 複数シェル間で履歴を共有
setopt INC_APPEND_HISTORY     # コマンド実行直後に履歴へ追記

# ---------------------------------------------------------------------------
# 3. 補完 (fish 風のリッチな補完)
# ---------------------------------------------------------------------------
#   apt のパッケージ名補完やサブコマンド補完は、システムに入っている
#   補完関数 (/usr/share/zsh/functions/... 等) が fpath 上にあれば
#   compinit だけで有効になる。

autoload -Uz compinit
compinit -d "$HOME/.zcompdump"

zmodload zsh/complist

zstyle ':completion:*' menu select                          # Tab で選択式メニュー
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'    # 大文字小文字を区別しない
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*' verbose yes

bindkey -M menuselect '^[[Z' reverse-menu-complete  # Shift-Tab で逆順に選択

# ---------------------------------------------------------------------------
# 4. プラグイン: zsh-autosuggestions
# ---------------------------------------------------------------------------
#   fish のような「薄い文字での過去履歴からのサジェスト」を実現する。
#   未インストールなら自動で clone する (git がない環境ではスキップ)。

ZSH_PLUGIN_DIR="$HOME/.zsh/plugins"

_zsh_plugin_load() {
    local repo="$1" name="$2" entry="$3"
    local dir="$ZSH_PLUGIN_DIR/$name"

    if [[ ! -d "$dir" ]] && command -v git &>/dev/null; then
        mkdir -p "$ZSH_PLUGIN_DIR"
        git clone --depth=1 "https://github.com/${repo}.git" "$dir" 2>/dev/null
    fi

    [[ -f "$dir/$entry" ]] && source "$dir/$entry"
}

_zsh_plugin_load "zsh-users/zsh-autosuggestions" "zsh-autosuggestions" "zsh-autosuggestions.zsh"

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'   # 薄いグレーで表示

# --- クリップボード / copyfile / copypath -----------------------------------

_zsh_fetch_source() {
    local url="$1" dest="$2"

    if [[ ! -f "$dest" ]] && command -v curl &>/dev/null; then
        mkdir -p "${dest:h}"
        curl -fsSL "$url" -o "$dest" 2>/dev/null
    fi

    [[ -f "$dest" ]] && source "$dest"
}

OMZ_RAW_BASE="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master"
OMZ_CACHE_DIR="$ZSH_PLUGIN_DIR/ohmyzsh"

_zsh_fetch_source "$OMZ_RAW_BASE/lib/clipboard.zsh"                       "$OMZ_CACHE_DIR/clipboard.zsh"
_zsh_fetch_source "$OMZ_RAW_BASE/plugins/copyfile/copyfile.plugin.zsh"    "$OMZ_CACHE_DIR/copyfile.plugin.zsh"
_zsh_fetch_source "$OMZ_RAW_BASE/plugins/copypath/copypath.plugin.zsh"    "$OMZ_CACHE_DIR/copypath.plugin.zsh"


# ---------------------------------------------------------------------------
# 5. プロンプト (git ブランチ表示 + fish 風のパス短縮)
# ---------------------------------------------------------------------------

autoload -Uz vcs_info
setopt PROMPT_SUBST

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' (%b)'
zstyle ':vcs_info:git:*' actionformats ' (%b|%a)'

precmd_functions+=(vcs_info)

# fish のように、最後のディレクトリ以外は先頭1文字に短縮する
_prompt_pwd() {
    local pwd_short="${PWD/#$HOME/~}"
    local -a parts
    parts=("${(s:/:)pwd_short}")

    local n=${#parts[@]}
    local i
    for (( i = 1; i < n; i++ )); do
        if [[ "${parts[$i]}" == .* ]]; then
            parts[$i]="${parts[$i]:0:2}"
        else
            parts[$i]="${parts[$i]:0:1}"
        fi
    done

    print -n "${(j:/:)parts}"
}


PROMPT='%F{cyan}%n@%m%f %F{blue}$(_prompt_pwd)%f%F{green}${vcs_info_msg_0_}%f %# '


# ---------------------------------------------------------------------------
# 6. エイリアス
# ---------------------------------------------------------------------------

alias ls='eza --group-directories-first --color=auto --icons'
alias ll='eza -lah'
alias cat='bat --style=plain'

# ---------------------------------------------------------------------------
# 7. 関数
# ---------------------------------------------------------------------------

# copyfile / copypath は 4 章で oh-my-zsh から読み込み済み (ここでは定義しない)

# --- Python 仮想環境 ---------------------------------------------------------

# カレントディレクトリから上に遡って .venv を探し、有効化する
activate() {
    local dir="$PWD"

    while [[ "$dir" != "/" ]]; do
        if [[ -f "$dir/.venv/bin/activate" ]]; then
            source "$dir/.venv/bin/activate"
            echo "venv を有効化しました: $dir/.venv"
            return 0
        fi
        dir="$(dirname "$dir")"
    done

    echo "activate: .venv が見つかりませんでした ($PWD より上の階層を探索)" >&2
    return 1
}

# --- プロキシ ---------------------------------------------------------------

readonly PROXY_HOST="po.cc.ibaraki-ct.ac.jp"
readonly PROXY_PORT="3128"
readonly PROXY_URL="http://${PROXY_HOST}:${PROXY_PORT}"

proxy() {
    export http_proxy="$PROXY_URL"
    export https_proxy="$PROXY_URL"
    export ftp_proxy="$PROXY_URL"
    export HTTP_PROXY="$PROXY_URL"
    export HTTPS_PROXY="$PROXY_URL"
    export FTP_PROXY="$PROXY_URL"
    export no_proxy="localhost,127.0.0.1"

    if command -v gsettings &>/dev/null; then
        gsettings set org.gnome.system.proxy mode 'manual'
        gsettings set org.gnome.system.proxy.http host "$PROXY_HOST"
        gsettings set org.gnome.system.proxy.http port "$PROXY_PORT"
        gsettings set org.gnome.system.proxy.https host "$PROXY_HOST"
        gsettings set org.gnome.system.proxy.https port "$PROXY_PORT"
        gsettings set org.gnome.system.proxy.ftp host "$PROXY_HOST"
        gsettings set org.gnome.system.proxy.ftp port "$PROXY_PORT"
    fi

    echo "プロキシを有効化しました: $PROXY_URL"
}

proxyoff() {
    unset http_proxy https_proxy ftp_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY no_proxy

    if command -v gsettings &>/dev/null; then
        gsettings set org.gnome.system.proxy mode 'none'
    fi

    echo "プロキシを無効化しました"
}

# ---------------------------------------------------------------------------
# 8. Emacs (vterm) 連携
# ---------------------------------------------------------------------------
#   emacs-libvterm 公式が配布している etc/emacs-vterm-zsh.sh の推奨実装に
#   ほぼ準拠 (https://github.com/akermu/emacs-libvterm/blob/master/etc/emacs-vterm-zsh.sh)。
#   - vterm_printf: emacs へエスケープシーケンスを送る低レベル関数
#   - vterm_prompt_end: プロンプト末尾に埋め込み、カレントディレクトリを emacs 側と同期
#   - vterm_cmd: emacs 側で任意の elisp コマンドを実行させる
#   - e: vterm 内なら find-file を emacs 上で実行し、新規バッファで開く。
#        vterm の外 (通常のターミナル等) では emacsclient にフォールバックする。
#
#   注意: 公式ファイルには chpwd 毎にターミナルのタイトルバーを同期する
#   add-zsh-hook も含まれるが、zsh-autosuggestions と衝突する既知の不具合が
#   報告されている (https://github.com/akermu/emacs-libvterm/issues/574) ため、
#   今回の要件にない機能でもあり、ここでは意図的に含めていない。

vterm_printf() {
    if [[ -n "$TMUX" ]] && { [[ "${TERM%%-*}" == "tmux" ]] || [[ "${TERM%%-*}" == "screen" ]]; }; then
        # tmux 経由でも emacs までエスケープシーケンスを通す
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [[ "${TERM%%-*}" == "screen" ]]; then
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

# vterm 内で clear を打つと、画面外のスクロールバックごと完全に消去する
if [[ "$INSIDE_EMACS" == "vterm" ]]; then
    alias clear='vterm_printf "51;Evterm-clear-scrollback"; tput clear'
fi

vterm_prompt_end() {
    vterm_printf "51;A$(printf "%s" "$PWD" | sed 's|\\|\\\\|g;s/"/\\"/g')"
}

vterm_cmd() {
    local vterm_elisp=""
    while [[ $# -gt 0 ]]; do
        vterm_elisp+=$(printf '"%s" ' "$(printf "%s" "$1" | sed 's|\\|\\\\|g;s/"/\\"/g')")
        shift
    done
    vterm_printf "51;E$vterm_elisp"
}

# vterm (INSIDE_EMACS に "vterm" を含む) の場合のみ、プロンプトに同期用シーケンスを付与
if [[ -n "$INSIDE_EMACS" && "$INSIDE_EMACS" == *"vterm"* ]]; then
    precmd_functions+=(vterm_prompt_end)
fi

# `e filename` でファイルを開く
e() {
    if [[ -n "$INSIDE_EMACS" && "$INSIDE_EMACS" == *"vterm"* ]]; then
        vterm_cmd find-file "$(realpath "${1:-.}")"
    elif command -v emacsclient &>/dev/null; then
        emacsclient -n "${1:-.}"
    else
        echo "e: emacsclient が見つかりません" >&2
        return 1
    fi
}


# ---------------------------------------------------------------------------
# linuxbrew
# ---------------------------------------------------------------------------

export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";
export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar";
export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew";
fpath[1,0]="/home/linuxbrew/.linuxbrew/share/zsh/site-functions";
export FPATH;
export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin${PATH+:$PATH}";
[ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:${INFOPATH:-}";


# ---------------------------------------------------------------------------
# 9. プラグイン: zsh-syntax-highlighting (必ず一番最後に読み込む)
# ---------------------------------------------------------------------------

_zsh_plugin_load "zsh-users/zsh-syntax-highlighting" "zsh-syntax-highlighting" "zsh-syntax-highlighting.zsh"

# ---------------------------------------------------------------------------
# 10. 依存コマンドチェック
# ---------------------------------------------------------------------------
#   起動時に一度だけ、設定が前提としている外部コマンドの有無を確認する。

_zsh_check_deps() {
    local missing=()
    local cmd
    for cmd in eza bat git curl emacsclient; do
        command -v "$cmd" &>/dev/null || missing+=("$cmd")
    done

    if (( ${#missing[@]} > 0 )); then
        echo "警告: 次のコマンドが見つかりません: ${missing[*]}" >&2
    fi
}

_zsh_check_deps

cd "$HOME"

