#!/bin/bash

# System functions
function naut() {
    setsid nautilus "$@" > /dev/null 2>&1 &
}

function timer() {
    local MINUTES="$1"

    [[ "$MINUTES" =~ ^[0-9]+$ ]] || {
        echo "Usage: timer <minutes>"
        return 1
    }

    local END_TIME
    END_TIME=$(date -d "+$MINUTES minutes" +"%H:%M")

    (
        set +m   # disable job control in this subshell
        nohup bash -c "
            sleep $((MINUTES * 60))
            notify-send '⏱  Timer finished' '$MINUTES minute(s) have passed'
        " >/dev/null 2>&1 &
    )

    echo "⏱  Timer set for $MINUTES minute(s) — ends at $END_TIME"
}

# App functions
function spotify() {
    setsid spotify > /dev/null 2>&1 &
    sleep 5
    pactl set-sink-volume @DEFAULT_SINK@ 50%
}

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
    local candidates=(
        "android-studio"
        "/Applications/Android Studio.app/Contents/MacOS/studio"
        "$HOME/Applications/Android Studio.app/Contents/MacOS/studio"
        "$HOME/.local/bin/studio"
    )

    for cmd in "${candidates[@]}"; do
        if command -v "$cmd" >/dev/null 2>&1 || [ -x "$cmd" ]; then

            # Linux has setsid, macOS doesn't
            if command -v setsid >/dev/null 2>&1; then
                setsid "$cmd" "$@" >/dev/null 2>&1 &
            else
                nohup "$cmd" "$@" >/dev/null 2>&1 &
            fi

            return
        fi
    done

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
