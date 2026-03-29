# System functions
function timer() {
    local MINUTES="$1"

    [[ "$MINUTES" =~ ^[0-9]+$ ]] || {
        echo "Usage: timer <minutes>"
        return 1
    }

    local OS="$(uname)"
    local END_TIME=""

    #######################################
    # Calculate end time (cross-platform)
    #######################################
    if [[ "$OS" == "Darwin" ]]; then
        END_TIME=$(date -v+"$MINUTES"M +"%H:%M")
    else
        END_TIME=$(date -d "+$MINUTES minutes" +"%H:%M")
    fi

    #######################################
    # Background timer
    #######################################
    (
        sleep $((MINUTES * 60))

        if [[ "$OS" == "Darwin" ]]; then
            osascript -e "display notification \"$MINUTES minute(s) have passed\" with title \"⏱ Timer finished\""
        else
            notify-send "⏱ Timer finished" "$MINUTES minute(s) have passed"
        fi

    ) >/dev/null 2>&1 &

    echo "⏱ Timer set for $MINUTES minute(s) — ends at $END_TIME"
}

function set_wallpaper() {
    local img="$1"

    if [[ "$(uname)" != "Darwin" ]]; then
        echo "Must be in OSX"
        return 1
    fi

    if [[ ! -f "$img" ]]; then
        echo "File not found: $img"
        return 1
    fi

    # Convert to absolute path
    local abs_path=$(abspath "$img")

    # Use a more robust AppleScript syntax
    osascript -e "tell application \"System Events\" to set picture of every desktop to \"$abs_path\""
}

# Helper function to ensure path is absolute
function abspath() {
    python3 -c "import os, sys; print(os.path.abspath(sys.argv[1]))" "$1"
}
alias sw="set_wallpaper "$1""

# App functions
function studio() {
    local OS="$(uname)"

    #######################################
    # macOS
    #######################################
    if [[ "$OS" == "Darwin" ]]; then
        local APP="/Applications/Android Studio.app"

        if [[ -d "$APP" ]]; then
            open -a "$APP" "$@" >/dev/null 2>&1 &
            return
        fi

        echo "❌ Android Studio not found"
        return 1
    fi

    #######################################
    # Linux / Ubuntu
    #######################################
    local STUDIO_BIN

    STUDIO_BIN=$(
        command -v studio \
        || command -v android-studio \
        || command -v android-studio.sh
    )

    if [[ -z "$STUDIO_BIN" ]]; then
        echo "❌ Android Studio binary not found"
        return 1
    fi

    setsid "$STUDIO_BIN" "$@" >/dev/null 2>&1 &
}

function idea() {
    local OS="$(uname)"

    if [[ "$OS" == "Darwin" ]]; then
        # macOS
        open -a "IntelliJ IDEA" "$@" >/dev/null 2>&1 &
    else
        # Ubuntu / Linux
        setsid idea "$@" >/dev/null 2>&1 &
    fi
}

function zathura() {
    setsid zathura "$@" >/dev/null 2>&1 &
}

# Git functions
function gc() {
    git commit -m "$1"
}


function select-java() {
    local os
    os="$(uname)"

    echo "Available Java Versions:"
    echo

    #######################################
    # macOS
    #######################################
    if [[ "$os" == "Darwin" ]]; then
        /usr/libexec/java_home -V 2>&1 \
            | awk -F '"' '/version/ {print $2}' \
            | sort -u

        echo
        read -rp "Enter version (17, 21, etc): " version

        if [[ -n "$version" ]]; then
            JAVA_HOME=$(/usr/libexec/java_home -v "$version" 2>/dev/null)
        fi

    #######################################
    # Linux (Ubuntu, Arch)
    #######################################
    else
        local jvm_dir="/usr/lib/jvm"

        if [[ ! -d "$jvm_dir" ]]; then
            echo "❌ $jvm_dir not found"
            return 1
        fi

        # Extract versions from directory names
        ls "$jvm_dir" \
            | grep -Ei 'jdk|java|temurin|zulu' \
            | sed -E 's/.*([0-9]{2}).*/\1/' \
            | sort -u

        echo
        read -rp "Enter version (17, 21, etc): " version

        if [[ -n "$version" ]]; then
            JAVA_HOME=$(
                find "$jvm_dir" -maxdepth 1 -type d \
                | grep -E "$version" \
                | head -n1
            )
        fi
    fi

    #######################################
    # Apply selection
    #######################################
    if [[ -z "$JAVA_HOME" ]]; then
        echo "❌ Java $version not found"
        return 1
    fi

    export JAVA_HOME
    export PATH="$JAVA_HOME/bin:$PATH"

    echo
    echo "☕ Switched to:"
    echo "$JAVA_HOME"
    java -version
}

function sketch() {
    local dir="$HOME/Documents"
    local name="sketch.md"
    local path="$dir/$name"

    if [[ -f $path ]]; then
        rm $path
    fi

    cd $dir
    nvim $name
}
