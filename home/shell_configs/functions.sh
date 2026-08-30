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
        command -v android-studio \
        || command -v android-studio.sh \
        || command -v studio
    )
    echo "Running $STUDIO_BIN"

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
    local version="$1" # Capture the immediate argument if provided

    #######################################
    # macOS
    #######################################
    if [[ "$os" == "Darwin" ]]; then
        # If no argument was passed, show the menu and prompt the user
        if [[ -z "$version" ]]; then
            echo "Available Java Versions:"
            echo
            /usr/libexec/java_home -V 2>&1 \
                | awk -F '"' '/version/ {print $2}' \
                | sort -u
            echo
            printf "Enter version (17, 21, etc): "
            read -r version
        fi

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

        # If no argument was passed, show the menu and prompt the user
        if [[ -z "$version" ]]; then
            echo "Available Java Versions:"
            echo
            # Extract versions from directory names
            ls "$jvm_dir" \
                | grep -Ei 'jdk|java|temurin|zulu' \
                | sed -E 's/.*([0-9]{2}).*/\1/' \
                | sort -u
            echo
            printf "Enter version (17, 21, etc): "
            read -r version
        fi

        if [[ -n "$version" ]]; then
            # On Arch, we want to match something like 'java-21-openjdk' or 'jdk-21' safely
            JAVA_HOME=$(
                find "$jvm_dir" -maxdepth 1 -mindepth 1 -type d \
                    | grep -E "(^|[^0-9])$version([^0-9]|$)" \
                    | head -n1
            )
        fi
    fi

    #######################################
    # Apply selection
    #######################################
    if [[ -z "$JAVA_HOME" ]]; then
        echo "❌ Java '$version' not found"
        return 1
    fi

    export JAVA_HOME
    # Remove previous JAVA_HOME/bin from PATH if you switch multiple times in one session
    if [[ -n "$OLD_JAVA_HOME" ]]; then
        PATH=$(echo "$PATH" | sed "s|${OLD_JAVA_HOME}/bin:||g")
    fi
    
    export PATH="$JAVA_HOME/bin:$PATH"
    export OLD_JAVA_HOME="$JAVA_HOME" # Track it for clean swapping later

    echo
    echo "☕ Switched to:"
    echo "$JAVA_HOME"
    java -version
}

function sketch() {
    local dir="$HOME/Documents"
    local name="sketch.md"
    local file="$dir/$name"

    if [[ -f "$file" ]]; then
        rm "$file"
    fi

    cd $dir
    nvim $name
}

# Yazi functions
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

function copy() {
    if command -v pbcopy >/dev/null 2>&1; then
        pbcopy
    elif command -v xclip >/dev/null 2>&1; then
        xclip -selection clipboard
    elif command -v wl-copy >/dev/null 2>&1; then
        wl-copy
    else
        echo "Error: No clipboard utility found (pbcopy, xclip, or wl-copy)." >&2
        return 1
    fi
}

function clean_build() {
    echo "🚀 Starting Gradle build..."
    
    ./gradlew clean assembleDebug
    
    local status=$?
    
    if [ $status -eq 0 ]; then
        echo -e "\n✅ Build completed successfully!"
        notify-send "Gradle Build" "✅ Build completed successfully!" 
    else
        echo -e "\n❌ Build failed with exit code $status"
        notify-send "Gradle Build" "❌ Build failed with exit code $status" 
        return $status
    fi
}

function wdb() {
    adb pair "192.168.100.74:$1"
}

function flush_lsp_log() {
    echo > $HOME/.local/state/nvim/lsp.log
}

function live_log() {
    tail -f "$1" | bat --paging=never -l log --unbuffered
}

function removeClDelay() {
    sudo hidutil property --set '{"CapsLockDelayOverride":0}'
}

function c_compile_run() {
    local output="${1:-main}"
    g++ -std=c++23 *.cpp -o $output && ./$output
}
alias ccr="c_compile_run $1"

function kotlin_compile_run() {
    # 1. Ensure kotlinc is installed
    if ! command -v kotlinc &> /dev/null; then
        echo "Error: 'kotlinc' is not installed or not in your PATH."
        return 1
    fi

    # 2. Check if any .kt files exist in the current directory
    if ! ls *.kt &> /dev/null; then
        echo "Error: No .kt files found in $(pwd)"
        return 1
    fi

    # 3. Create a temporary file for the compiled output
    local jar_file
    jar_file=$(mktemp /tmp/kt_app_XXXXXX.jar)

    # 4. Compile all .kt files in the current folder
    echo "Compiling..."
    if kotlinc *.kt -include-runtime -d "$jar_file"; then
        echo -e "Compilation successful.\n--- Output ---"
        # 5. Run the compiled JAR
        java -jar "$jar_file" "$@"

        # 6. Clean up the temp file after execution
        rm -f "$jar_file"
    else
        echo "Compilation failed."
        rm -f "$jar_file"
        return 1
    fi
}
alias kcr="kotlin_compile_run"
