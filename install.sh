#!/bin/bash

DOT_HOME="$HOME/.dotfiles/home"
CONFIG_DIR="$DOT_HOME/.bash.configs"
BASHRC="$HOME/.bashrc"
SOURCE_BLOCK="if [ -d \"$DOT_HOME/.bash.configs\" ]; then
for file in \"$DOT_HOME\"/.bash.configs/*.sh; do
    [ -r \"\$file\" ] && source \"\$file\"
done
fi"

if [ ! -d "$CONFIG_DIR" ]; then
    echo "Please clone your dotfiles first!"
    echo "run the following command:"
    echo "git clone git@github.com:coleridge113/dotfiles.git ~/.dotfiles"
    exit 1
fi

# Check if .bashrc already contains the source block
if grep -Fq "$CONFIG_DIR" "$BASHRC"; then
    echo ".bashrc already sources $CONFIG_DIR/*.sh"
else
    echo "Appending source block to .bashrc..."
    echo -e "\n# Load custom shell configs\n$SOURCE_BLOCK" >> "$BASHRC"
    echo "Done. Reload your shell or run: source ~/.bashrc"
fi

# TMUX
if [ -f "$DOT_HOME/.tmux.conf" ]; then
    ln -sfn "$DOT_HOME/.tmux.conf" "$HOME/.tmux.conf"
    if [ -n "$TMUX" ]; then
        tmux source-file "$HOME/.tmux.conf"
        echo "Linked tmux config"
    fi
else
    echo "error sourcing .tmux.conf"
    echo "check if tmux is installed or if path is correct!"
fi

# NVIM
if [ -d "$DOT_HOME/.config/nvim" ]; then
    mkdir -p "$HOME/.config"
    ln -sfn "$DOT_HOME/.config/nvim" "$HOME/.config/nvim"
    echo "Linked nvim config"
else
    echo "error linking nvim config"
fi

# IDEAVIMRC
if [ -f "$DOT_HOME/.ideavimrc" ]; then
    ln -sfn "$DOT_HOME/.ideavimrc" "$HOME/.ideavimrc"
    echo "Linked .ideavimrc"
fi

# Ghostty
if [ -d "$DOT_HOME/.config/ghostty" ]; then
    mkdir -p "$HOME/.config"
    ln -sfn "$DOT_HOME/.config/ghostty" "$HOME/.config"
    echo "Linked ghostty config"
else
    echo "error linking ghostty config"
fi

# Btop
if [ -f "$DOT_HOME/.config/btop.conf" ]; then
    ln -sfn "$DOT_HOME/.config/btop.conf" "$HOME/.config/btop/"
    echo "Linked btop.conf"
fi

# Hyprland
if [ -d "$DOT_HOME/.config/hypr" ]; then
    ln -sfn "$DOT_HOME/.config/hypr" "$HOME/.config/"
    echo "Linked Hyprland"
fi

# Waybar
if [ -d "$DOT_HOME/.config/waybar" ]; then
    ln -sfn "$DOT_HOME/.config/waybar" "$HOME/.config/"
    echo "Linked waybar"
fi

# Kitty
if [ -d "$DOT_HOME/.config/kitty" ]; then
    ln -sfn "$DOT_HOME/.config/kitty" "$HOME/.config/"
    echo "Linked kitty"
fi

# Starship
if [ -d "$DOT_HOME/.config/starship" ]; then
    ln -sfn "$DOT_HOME/.config/starship/starship.toml" "$HOME/.config/"
    echo "Linked starship"
fi

# TMUX Plugin
if [ -d "$DOT_HOME/.tmux/" ]; then
    ln -sfn "$DOT_HOME/.tmux" "$HOME/"
    echo "Linked tmux plugins"
fi

# Wofi
if [ -d "$DOT_HOME/.config/wofi" ]; then
    ln -sfn "$DOT_HOME/.config/wofi" "$HOME/.config/"
    echo "Linked tmux plugins"
fi
