# System aliases
# For GNOME
alias logout='gnome-session-quit --logout --no-prompt'

# App aliases
alias chrome='setsid google-chrome > /dev/null 2>&1 &'
alias goverlay='setsid goverlay > /dev/null 2>&1 &'
alias bitwarden='setsid bitwarden > /dev/null 2>&1 &'
alias brave='setsid brave > /dev/null 2>&1 &'
alias postman='setsid postman > /dev/null 2>&1 &'
alias discord='setsid discord > /dev/null 2>&1 &'
alias kdenlive='setsid kdenlive > /dev/null 2>&1 &'
alias spotify='setsid spotify > /dev/null 2>&1 &'
alias pdf='zathura'
alias steam='setsid steam > /dev/null 2>&1 &'

# Vim aliases
alias nv='cd ~/.config/nvim'
alias nvn='nv && nvim .'
alias nvb='nvim $DOT_HOME/.bash.configs'
alias svb='source ~/.bashrc'
alias nvi='nvim ~/.ideavimrc'
alias nvg='nvim ~/.config/ghostty'
alias nvt='nvim ~/.tmux.conf'
alias dot='cd ~/.dotfiles'

# Git aliases
alias gs='git status'
alias ga='git add .'
alias gb='git branch'
alias gp='git push -u origin HEAD'

# Script aliases
alias ghostty_focus='$DOT_HOME/.scripts/ghostty_focus.sh &'
alias ghostty_focus_stop='$DOT_HOME/.scripts/stop_ghostty_focus.sh'

# Hyprland
alias nvh='nvim ~/.config/hypr'
alias nvw='nvim ~/.config/waybar'

# Navigation aliases
alias books='cd ~/Documents/books'
alias notes='cd $NOTES'
