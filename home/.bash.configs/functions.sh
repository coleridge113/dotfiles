#!/usr/bin/env zsh

# System functions
function timer() {
    local MINUTES="$1"

    [[ "$MINUTES" =~ ^[0-9]+$ ]] || {
        echo "Usage: timer <minutes>"
        return 1
    }

    local END_TIME
    END_TIME=$(date -v+"$MINUTES"M +"%H:%M")

    (
        sleep $((MINUTES * 60))
        osascript -e "display notification \"$MINUTES minute(s) have passed\" with title \"⏱ Timer finished\""
    ) >/dev/null 2>&1 &

    echo "⏱ Timer set for $MINUTES minute(s) — ends at $END_TIME"
}

# App functions
function idea() {
    setsid idea "$@" >/dev/null 2>&1 &
}

function zathura() {
    setsid zathura "$@" >/dev/null 2>&1 &
}

# Git functions
function gc() {
    git commit -m "$1"
}

# Android Studio functions
function studio() {
    local APP="/Applications/Android Studio.app"

    if [ -d "$APP" ]; then
        if [ $# -gt 0 ]; then
            open -a "$APP" "$@"
        else
            open -a "$APP"
        fi
        return
    fi

    # fallback if installed in user Applications folder
    APP="$HOME/Applications/Android Studio.app"

    if [ -d "$APP" ]; then
        if [ $# -gt 0 ]; then
            open -a "$APP" "$@"
        else
            open -a "$APP"
        fi
        return
    fi

    echo "Android Studio not found."
    return 1
}

function select-java() {
    echo "Available Java Versions:"
    /usr/libexec/java_home -V 2>&1 | grep -E "\d+\.\d+\.\d+"
    
    echo -n "Enter the version you want (e.g., 17, 21): "
    read version
    
    if [ -n "$version" ]; then
        export JAVA_HOME=$(/usr/libexec/java_home -v "$version")
        export PATH="$JAVA_HOME/bin:$PATH"
        echo "Switched to Java $version"
        java -version
    fi
}
