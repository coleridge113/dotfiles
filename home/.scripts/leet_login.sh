#!/usr/bin/env bash

function leet_login() {
    #######################################
    # validate args
    #######################################
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Usage: leet_login <TOKEN> <SESSION>"
        return 1
    fi

    local TOKEN="$1"
    local SESSION="$2"
    local BODY="csrftoken=$TOKEN; LEETCODE_SESSION=$SESSION"

    #######################################
    # copy to clipboard (cross-platform)
    #######################################
    if command -v pbcopy >/dev/null 2>&1; then
        # macOS
        echo -n "$BODY" | pbcopy

    elif command -v wl-copy >/dev/null 2>&1; then
        # Linux Wayland
        echo -n "$BODY" | wl-copy

    elif command -v xclip >/dev/null 2>&1; then
        # Linux X11
        echo -n "$BODY" | xclip -selection clipboard

    else
        echo "⚠️ No clipboard tool found"
        echo
        echo "$BODY"
        return 1
    fi

    echo "📋 Copied LeetCode session cookie to clipboard"
}

leet_login "$@"
