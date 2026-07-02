if status is-interactive
    # --- Environment Variables ---
    set -gx MOZ_ENABLE_WAYLAND 1
    set -gx LANG en_US.UTF-8
    set -gx LC_ALL en_US.UTF-8
    set -gx CHROME_EXECUTABLE /usr/sbin/google-chrome-stable

    set -gx OLLAMA 0.0.0.0
    set -gx OLLAMA_HOST "0.0.0.0"

    # Android
    set -gx ANDROID_HOME $HOME/Android/Sdk
    set -gx ANDROID_SDK_ROOT $ANDROID_HOME

    # --- External Tool Inits ---
    # Homebrew
    if test -f /home/linuxbrew/.linuxbrew/bin/brew
        eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    end
    # FNM (Fast Node Manager)
    if type -q fnm
        fnm env --use-on-cd --shell fish | source
    end

    # --- Path Management ---
    fish_add_path /home/mt/.cargo/bin
    fish_add_path /home/mt/.develop/flutter/bin
    fish_add_path /home/mt/.develop/android-studio/bin
    fish_add_path /home/mt/.local/bin
    fish_add_path $ANDROID_HOME/platform-tools
    fish_add_path $ANDROID_HOME/cmdline-tools/latest/bin
    fish_add_path /home/mt/Android/Sdk/emulator
    fish_add_path /home/mt/.lmstudio/bin

    # --- Aliases ---
    alias v='nvim'
    alias e='emacsclient -t -a ""'
    alias screenshot='grim -g (slurp)'
    alias ls='eza --group-directories-first --color=auto --icons'
    alias ll='eza -lah'
    alias cat='bat --style=plain'

    # Proxy Toggle
    function proxy
        set -gx HTTP_PROXY http://po.cc.ibaraki-ct.ac.jp:3128
        set -gx HTTPS_PROXY http://po.cc.ibaraki-ct.ac.jp:3128
        set -gx FTP_PROXY http://po.cc.ibaraki-ct.ac.jp:3128
        set -gx http_proxy http://po.cc.ibaraki-ct.ac.jp:3128
        set -gx https_proxy http://po.cc.ibaraki-ct.ac.jp:3128
        set -gx ftp_proxy http://po.cc.ibaraki-ct.ac.jp:3128
        echo "Proxy settings enabled."
    end

    function proxyoff
        set -e HTTP_PROXY HTTPS_PROXY FTP_PROXY http_proxy https_proxy ftp_proxy
        echo "Proxy settings cleared."
    end

    # --- Custom Functions (Replicating Oh-My-Zsh) ---

    # copyfile: Copy file content to clipboard
    function copyfile
        if test (count $argv) -eq 0
            echo "Usage: copyfile <file>"
            return 1
        end
        cat $argv[1] | wl-copy
    end

    # copypath: Copy absolute path to clipboard
    function copypath
        set -l target_path $argv[1]
        if test -z "$target_path"
            set target_path (pwd)
        end
        realpath $target_path | tr -d '\n' | wl-copy
    end

    # activate: Python venv shortcut
    function activate
        if test -f .venv/bin/activate.fish
            source .venv/bin/activate.fish
        else
            echo "Error: .venv/bin/activate.fish not found."
        end
    end

end
