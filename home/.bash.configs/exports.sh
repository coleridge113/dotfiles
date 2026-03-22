# PATH exports
export PATH="$HOME/.local/bin:$PATH"

# Project exports
export DEV="$HOME/dev/personal"
export BUDGET="$DEV/budget"
export CHAL="$HOME/dev/personal/challenges"
export CRYPTO="$HOME/dev/personal/challenges/cryptomonitoring"

# --- Universal JAVA_HOME ---
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS: Use the system utility to find the path
    if [ -x /usr/libexec/java_home ]; then
        # Tries 17 first (Android stable), then 21, then any
        export JAVA_HOME=$(/usr/libexec/java_home -v 17 2>/dev/null || /usr/libexec/java_home -v 21 2>/dev/null || /usr/libexec/java_home)
    fi
else
    # Arch Linux: Use the standard 'default' symlink 
    # This prevents the "invalid directory" error when versions increment
    if [ -d "/usr/lib/jvm/default" ]; then
        export JAVA_HOME="/usr/lib/jvm/default"
    elif [ -d "/usr/lib/jvm/java-17-openjdk" ]; then
        export JAVA_HOME="/usr/lib/jvm/java-17-openjdk"
    fi
fi

# Add to PATH safely
if [ -n "$JAVA_HOME" ] && [ -d "$JAVA_HOME/bin" ]; then
    export PATH="$JAVA_HOME/bin:$PATH"
fi

export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"

# Node exports
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# App exports
export STEAM="$HOME/snap/steam/common/.local/share/Steam/steamapps/common"

# Dotfiles exports
export DOTFILES="$HOME/.dotfiles"
export DOT_HOME="$DOTFILES/home"
export DOT_SCRIPTS="$DOT_HOME/.scripts"

# Other exports
export NOTES="$HOME/dev/notes"

# Yazi exports
export EDITOR=nvim
export VISUAL=nvim
