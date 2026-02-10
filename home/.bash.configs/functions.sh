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
    if command -v snap >/dev/null 2>&1 && snap list android-studio >/dev/null 2>&1; then
        # Ubuntu Snap
        setsid snap run android-studio "$@" >/dev/null 2>&1 &
    elif command -v android-studio >/dev/null 2>&1; then
        # Arch package or AUR build
        setsid android-studio "$@" >/dev/null 2>&1 &
    elif command -v studio >/dev/null 2>&1; then
        # Manual install
        setsid studio "$@" >/dev/null 2>&1 &
    else
        echo "Android Studio not found."
        return 1
    fi
}

function clean_build() {
    ./gradlew clean assembleDebug
}

# Nvim functions
function lsp_clean() {
    rm -rf .gradle/ kls_database.db build/ .kotlin/ app/build/
}
