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
    local studio_cmd="/opt/android-studio/bin/studio.sh"

    # fallback to snap command if manual install not found
    if [ ! -x "$studio_cmd" ]; then
        studio_cmd="android-studio"
    fi

    if command -v "$studio_cmd" >/dev/null 2>&1 || [ -x "$studio_cmd" ]; then
        setsid "$studio_cmd" "$@" >/dev/null 2>&1 &
    else
        echo "❌ Android Studio not found."
        echo "Install with:"
        echo "  sudo snap install android-studio --classic"
        return 1
    fi
}
