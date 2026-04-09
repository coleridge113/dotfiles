#!/usr/bin/env bash

readonly bt_dir="$HOME/.config/bluetooth"
readonly filepath="$bt_dir/devices.conf"

function bt_save_paired() {
    local cmd

    if [[ $(uname) == "Darwin" ]]; then
        cmd=(blueutil --paired)
    else
        cmd=(bluetoothctl paired-devices)
    fi

    if ! command -v ${cmd[0]} &> /dev/null; then
        echo "${cmd[0]} not found..." >&2
        return 1
    fi

    declare -A devices
    local regex='([0-9a-f-]{17}).*"([^"]+)"'

    if [[ ! -f $filepath ]]; then
        mkdir -p $(dirname $filepath) || \
            {
                echo "Failed to create directory..." >&2
                return 1
            }
    fi

    while IFS= read -r line; do
        if [[ $line =~ $regex ]]; then
            devices["${BASH_REMATCH[2]}"]="${BASH_REMATCH[1]//-/:}"
        fi
    done < <("${cmd[@]}")


    {
        for key in "${!devices[@]}"; do
            echo "$key=${devices[$key]}" >> "$filepath"
        done
    } > "$filepath" || \
        {
            echo "Failed to write paired devices to $(basename $filepath)..." >&2
            return 1
        }


    echo "Successfully saved ${#devices[@]} devices"
    return 0
}

function bt_find_paired() {
    local keyword="$1"

    while IFS="=" read -r key value; do
        if [[ "${key,,}" =~ ${keyword,,} ]]; then
            echo "$value"
        fi
    done < "$filepath"
}

function bcon() {
    local cmd
    local mac_address=$(bt_find_paired "$1") 

    if [[ $(uname) == "Darwin" ]]; then
        cmd=(blueutil --connect) 
    else
        cmd=(bluetoothctl connect) 
    fi

    if [[ -z $mac_address ]]; then
        echo "Device not found..."
        return 1
    fi

    if "${cmd[@]}" "$mac_address" &> /dev/null; then
        echo "Connected to device successfully"
    else
        echo "Failed to connect..."
        return 1
    fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    "$@"
fi
