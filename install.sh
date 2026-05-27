#!/bin/bash

DOT_HOME="$HOME/.dotfiles/home"
CONFIG_DIR="$DOT_HOME/shell_configs"
BASHRC="$HOME/.bashrc"
ZSHRC="$HOME/.zshrc"
SOURCE_BLOCK="if [ -d \"$CONFIG_DIR\" ]; then
for file in \"$CONFIG_DIR/*.sh; do
    [ -r \"\$file\" ] && source \"\$file\"
done
fi"

OS="$(uname)"

if [ ! -d "$CONFIG_DIR" ]; then
    echo "Please clone your dotfiles first!"
    echo "run the following command:"
    echo "git clone git@github.com:coleridge113/dotfiles.git ~/.dotfiles"
    exit 1
fi

# Check if .bashrc already contains the source block
if [[ $OS == "Darwin" ]]; then
    if grep -Fq "$CONFIG_DIR" "$ZSHRC"; then
        echo ".zshrc already sources $CONFIG_DIR/*.sh"
    else
        echo "Appending source block to .zshrc..."
        echo -e "\n# Load custom shell configs\n$SOURCE_BLOCK" >> "$ZSHRC"
        echo "Done. Reload your shell or run: source ~/.zshrc"
    fi
else
    if grep -Fq "$CONFIG_DIR" "$BASHRC"; then
        echo ".bashrc already sources $CONFIG_DIR/*.sh"
    else
        echo "Appending source block to .bashrc..."
        echo -e "\n# Load custom shell configs\n$SOURCE_BLOCK" >> "$BASHRC"
        echo "Done. Reload your shell or run: source ~/.bashrc"
    fi
fi

# BREW
if [[ $OS == "Darwin" ]]; then
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Please install with:"
        echo "/bin/bash -c '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)'"
        exit 1
    fi

    local brewfile="$DOT_HOME/brew/Brewfile"
    if [ -f "$brewfile"]; then
        echo "Brewfile found."
        echo "Installing dependencies..."
        brew bundle --file="$brewfile"
    else
        echo "Brewfile not found..."
        exit 1
    fi
fi

# ~/.local
if [ ! -d "$HOME/.local/bin" ]; then
    mkdir -p "$HOME/.local/bin"
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
    ln -sfn "$DOT_HOME/.config/starship/starship.toml" "$HOME/.config/starship.toml"
    echo "Linked starship"


    if [ -f "$HOME/.bashrc" ]; then
    STARSHIP_EVAL='eval "$(starship init bash)"'
        if ! grep -q "starship init" "$HOME/.bashrc"; then
            echo "$STARSHIP_EVAL" >> "$HOME/.bashrc"
            echo "Added starship initialization to .bashrc"
        else
            echo "Starship init already exists in .bashrc, skipping."
        fi

    elif [ -f "$HOME/.zshrc" ]; then
    STARSHIP_EVAL='eval "$(starship init zsh)"'
        if ! grep -q "starship init" "$HOME/.zshrc"; then
            echo "$STARSHIP_EVAL" >> "$HOME/.zshrc"
            echo "Added starship initialization to .zshrc"
        else
            echo "Starship init already exists in .zshrc, skipping."
        fi
    else
        echo "bashrc or zshrc not found..."
    fi
fi

# TMUX Plugin
if [ -d "$DOT_HOME/.tmux/" ]; then
    ln -sfn "$DOT_HOME/.tmux" "$HOME/"
    echo "Linked tmux plugins"
fi

# Wofi
if [ -d "$DOT_HOME/.config/wofi" ]; then
    ln -sfn "$DOT_HOME/.config/wofi" "$HOME/.config/"
    echo "Linked wofi"
fi

# Zathura
if [ -d "$DOT_HOME/.config/zathura" ]; then
    ln -sfn "$DOT_HOME/.config/zathura" "$HOME/.config/"
    echo "Linked zathura"
fi

# Yazi
if [ -d "$DOT_HOME/.config/yazi" ]; then
    ln -sfn "$DOT_HOME/.config/yazi" "$HOME/.config/"
    echo "Linked yazi"
fi

# Zoxide
if command -v zoxide > /dev/null; then
    echo "eval '$(zoxide init zsh)'"
fi

# Caelestia
if [ -d "$DOT_HOME/.config/caelestia" ]; then
    ln -sfn "$DOT_HOME/.config/caelestia" "$HOME/.config/"
    echo "Linked caelestia"
fi

# Flameshot
if [ -d "$DOT_HOME/.config/flameshot" ]; then
    ln -sfn "$DOT_HOME/.config/flameshot" "$HOME/.config/"
    echo "Linked flameshot"
fi
