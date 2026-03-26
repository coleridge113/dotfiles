# PATH exports
export PATH="$HOME/.local/bin:$PATH"

# Project exports
export DEV="$HOME/dev/personal"
export BUDGET="$DEV/budget"
export CHAL="$HOME/dev/personal/challenges"
export CRYPTO="$HOME/dev/personal/challenges/cryptomonitoring"

# JAVA exports (macOS + Ubuntu)
if command -v /usr/libexec/java_home >/dev/null 2>&1; then
    # macOS
    export JAVA_HOME=$(
        /usr/libexec/java_home -v 17 2>/dev/null \
        || /usr/libexec/java_home -v 21 2>/dev/null \
        || /usr/libexec/java_home 2>/dev/null
    )

elif [[ -d "/usr/lib/jvm" ]]; then
    # Ubuntu / Linux common locations
    for v in 17 21 ""; do
        if [[ -d "/usr/lib/jvm/java-${v}-openjdk-amd64" ]]; then
            export JAVA_HOME="/usr/lib/jvm/java-${v}-openjdk-amd64"
            break
        fi
    done

    # fallback: pick first JVM found
    [[ -z "$JAVA_HOME" ]] && export JAVA_HOME="$(ls -d /usr/lib/jvm/* 2>/dev/null | head -n1)"
fi

# Add java to PATH if found
if [[ -n "$JAVA_HOME" ]]; then
    export PATH="$JAVA_HOME/bin:$PATH"
fi

# Android exports
if [[ "$(uname)" == "Darwin" ]]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
else
    export ANDROID_HOME="$HOME/Android/Sdk"
fi

export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$ANDROID_HOME/emulator:$PATH"

# Node exports
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Dotfiles exports
export DOTFILES="$HOME/.dotfiles"
export DOT_HOME="$DOTFILES/home"
export DOT_SCRIPTS="$DOT_HOME/.scripts"

# Other exports
export NOTES="$HOME/dev/notes"

# Yazi exports
export EDITOR=nvim
export VISUAL=nvim
