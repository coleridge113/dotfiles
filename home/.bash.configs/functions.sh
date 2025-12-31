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

# Git functions
function gc() {
    git commit -m "$1"
}

# Android Studio functions
function studio() {
    setsid snap run android-studio "$@" >/dev/null 2>&1 &
}

function clean_build() {
    ./gradlew clean assembleDebug
}
