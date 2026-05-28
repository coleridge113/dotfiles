#
# ~/.bashrc
#

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = "1" ]; then
    exec start-hyprland
fi

eval "$(starship init bash)"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland

# Load custom shell configs
if [ -d "/home/josem/.dotfiles/home/shell_configs" ]; then
  for file in "/home/josem/.dotfiles/home"/shell_configs/*.sh; do
    [ -r "$file" ] && source "$file"
  done
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export XDG_RUNTIME_DIR=/run/user/$(id -u)
export _JAVA_AWT_WM_NONREPARENTING=1

alias ssh_jerry="ssh root@72.60.236.111"
eval "$(zoxide init bash)"

export PATH=$(echo -n $PATH | perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, <>))')
