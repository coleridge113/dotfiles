#!/bin/bash

function leet_login() {
    # Validate args
    if [[ -z "$1" || -z "$2" ]]; then
        echo "❌ Missing arguments."
        echo "Usage: leet_login <TOKEN> <SESSION>"
        return 1
    fi

    local TOKEN="$1"
    local SESSION="$2"
    local BODY="csrftoken=$TOKEN; LEETCODE_SESSION=$SESSION"

    # Wayland clipboard (Ubuntu default on newer installs)
    if command -v wl-copy >/dev/null 2>&1; then
        echo -n "$BODY" | wl-copy
        echo "✅ Copied to clipboard (wl-copy)"

    # X11 fallback
    elif command -v xclip >/dev/null 2>&1; then
        echo -n "$BODY" | xclip -selection clipboard
        echo "✅ Copied to clipboard (xclip)"

    else
        echo "⚠️ Clipboard tool not found."
        echo "$BODY"
        echo ""
        echo "Install one of:"
        echo "  sudo apt install wl-clipboard"
        echo "  sudo apt install xclip"
        return 1
    fi
}

leet_login "$1" "$2"
