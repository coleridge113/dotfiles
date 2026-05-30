# App launcher
function app() {
    local mac_name="$1"
    local linux_bin="$2"

    shift 2

    #######################################
    # macOS
    #######################################
    if command -v open >/dev/null 2>&1; then
        open -a "$mac_name" "$@" >/dev/null 2>&1 &
        return
    fi

    #######################################
    # Linux
    #######################################
    if command -v "$linux_bin" >/dev/null 2>&1; then
        setsid "$linux_bin" "$@" >/dev/null 2>&1 &
        return
    fi

    echo "❌ App not found: $mac_name / $linux_bin"
}

# System aliases
alias la='ls -la'
alias ll='ls -l'

# App aliases
alias chrome='app "Google Chrome" google-chrome'
alias brave='app "Brave Browser" brave-browser'
alias discord='app "Discord" discord'
alias viber='app "Viber" viber'
alias postman='app "Postman" postman'
alias ghostty='app "Ghostty" ghostty'
alias spotify='app "Spotify" spotify'
alias steam='app "Steam" steam'
alias bitwarden='app "Bitwarden" bitwarden'
alias naut='app "Nautilus" nautilus'

# Vim aliases
alias nv='cd ~/.config/nvim'
alias nvn='nv && nvim .'
alias nvb='nvim $DOT_HOME/shell_configs'
alias svb='source ~/.bashrc'
alias svz='source ~/.zshrc'
alias nvz='nvim ~/.zshrc'
alias nvi='nvim ~/.ideavimrc'
alias nvg='nvim ~/.config/ghostty'
alias nvt='nvim ~/.tmux.conf'
alias dots='cd ~/.dotfiles'
alias leet='nvim leetcode.nvim'
alias nvk='nvim ~/.config/karabiner'
alias nvc='nvim ~/.config/caelestia'
alias nvl='live_log ~/.local/state/nvim/lsp.log'
alias nvs='nvim ~/.config/starship.toml'

# Git aliases
alias gs='git status'
alias ga='git add .'
alias gb='git branch'
alias gp='git push -u origin HEAD'
alias lg='lazygit'

# Script aliases
alias leet_login='$DOT_SCRIPTS/leet_login.sh'
alias dmg_install='$DOT_SCRIPTS/dmg_install.sh'
alias run_cs='$DOT_SCRIPTS/android_run.sh assembleCs_stg_Debug'
alias run_rs='$DOT_SCRIPTS/android_run.sh assembleRs_stg_Debug'
alias run_debug='$DOT_SCRIPTS/android_run.sh assembleDebug'

# Navigation aliases
alias books='cd ~/Documents/books'
alias notes='cd $NOTES'
alias scripts='cd $DOT_HOME/.scripts'
alias ss='cd $HOME/dev/personal/scripting'

# Bluetooth aliases
alias bt='$DOT_SCRIPTS/bluetooth.sh'

# Tar aliases
alias install_discord='$DOT_SCRIPTS/install_discord.sh'
