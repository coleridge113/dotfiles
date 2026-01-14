#!/bin/bash

# System functions
function naut() {
    setsid nautilus "$@" > /dev/null 2>&1 &
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
    elif command -v studio.sh >/dev/null 2>&1; then
        # Manual install
        setsid studio.sh "$@" >/dev/null 2>&1 &
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
    rm -rf .gradle/ kls_database.db build/
}
