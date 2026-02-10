# Java exports
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
export PATH=$JAVA_HOME/bin:$PATH

# Project exports
export DEV="$HOME/dev/personal"
export BUDGET="$DEV/budget"
export CHAL="$HOME/dev/personal/challenges"
export CRYPTO="$HOME/dev/personal/challenges/cryptomonitoring"

# Android Studio exports
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export ANDROID_SDK_HOME="$HOME/.config/"
export ANDROID_AVD_HOME="$HOME/.config/.android/avd"

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
