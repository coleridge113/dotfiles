#!/bin/bash

function leet_login() {
    # Check if we are missing any arguments
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Error: Missing arguments."
        echo "Usage: leet_login <TOKEN> <SESSION>"
        exit 1
    fi

    local TOKEN="$1"
    local SESSION="$2"
    local BODY="csrftoken=$TOKEN; LEETCODE_SESSION=$SESSION"  

    # Detect clipboard and copy
    if [[ "$XDG_SESSION_TYPE" == "wayland" ]] || [[ -n "$WAYLAND_DISPLAY" ]]; then
        if command -v wl-copy &> /dev/null; then
            echo -n "$BODY" | wl-copy
            echo "Copied to Wayland clipboard."
        else
            echo "Error: wl-copy not found."
        fi
    elif command -v xclip &> /dev/null; then
        echo -n "$BODY" | xclip -selection clipboard
        echo "Copied to X11 clipboard (xclip)."
    elif command -v xsel &> /dev/null; then
        echo -n "$BODY" | xsel --clipboard --input
        echo "Copied to X11 clipboard (xsel)."
    else
        echo "Error: No clipboard manager found. String is:"
        echo "$BODY"
    fi
}

leet_login "$1" "$2"
