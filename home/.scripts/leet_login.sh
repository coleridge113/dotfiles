#!/usr/bin/env zsh

function leet_login() {
    # Check arguments
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Usage: leet_login <TOKEN> <SESSION>"
        return 1
    fi

    local TOKEN="$1"
    local SESSION="$2"
    local BODY="csrftoken=$TOKEN; LEETCODE_SESSION=$SESSION"

    # copy to macOS clipboard
    echo -n "$BODY" | pbcopy

    echo "📋 Copied LeetCode session cookie to clipboard"
}

leet_login "$@"
