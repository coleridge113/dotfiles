#!/usr/bin/env bash

function install_discord() {
    local tarball="$1"
    local output_dir="$HOME/.local/share"
    
    if [[ ! -f "$tarball" || ! "$tarball" =~ discord.*\.tar\.gz$ ]]; then
        echo "Error: Please select a valid Discord tarball (.tar.gz)"
        return 1
    fi

    local folder_name=$(tar -tf "$tarball" | head -1 | cut -f1 -d"/")
    local discord_dir="$(dirname "$(realpath "$tarball")")/$folder_name"

    echo "Extracting Discord..."
    tar -xf "$tarball" -C "$(dirname "$tarball")"
    
    if mv "$discord_dir" "$output_dir/"; then
        echo "Discord installed successfully to $output_dir/$folder_name"
        return 0
    else
        echo "Error: Failed to move Discord to $output_dir"
        return 1
    fi
}
install_discord "$1"
