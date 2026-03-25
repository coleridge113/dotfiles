# App launcher
app() {
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

# Vim aliases
alias nv='cd ~/.config/nvim'
alias nvn='nv && nvim .'
alias nvb='nvim $DOT_HOME/shell_configs'
alias svz='source ~/.zshrc'
alias nvz='nvim ~/.zshrc'
alias nvi='nvim ~/.ideavimrc'
alias nvg='nvim ~/.config/ghostty'
alias nvt='nvim ~/.tmux.conf'
alias dots='cd ~/.dotfiles'
alias leet='nvim leetcode.nvim'

# Git aliases
alias gs='git status'
alias ga='git add .'
alias gb='git branch'
alias gp='git push -u origin HEAD'
alias lg='lazygit'

# Script aliases
alias leet_login='$DOT_SCRIPTS/leet_login.sh'
alias dmg_install='$DOT_SCRIPTS/dmg_install.sh'

# Navigation aliases
alias books='cd ~/Documents/books'
alias notes='cd $NOTES'
