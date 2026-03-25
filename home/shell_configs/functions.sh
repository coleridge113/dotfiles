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
    local OS="$(uname)"

    echo "Available Java Versions:"

    #######################################
    # macOS
    #######################################
    if [[ "$OS" == "Darwin" ]]; then
        /usr/libexec/java_home -V 2>&1 | grep -E "\d+\."

        echo -n "Enter the version you want (e.g., 17, 21): "
        read version

        if [[ -n "$version" ]]; then
            JAVA_HOME=$(/usr/libexec/java_home -v "$version" 2>/dev/null)
        fi

    #######################################
    # Ubuntu / Linux
    #######################################
    else
        local jvm_dir="/usr/lib/jvm"

        ls "$jvm_dir" | grep -E "java-.*" || {
            echo "❌ No JVMs found in $jvm_dir"
            return 1
        }

        echo -n "Enter the version you want (e.g., 17, 21): "
        read version

        if [[ -n "$version" ]]; then
            JAVA_HOME=$(ls -d "$jvm_dir"/*"$version"* 2>/dev/null | head -n1)
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

    echo "☕ Switched to Java $version"
    java -version
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
