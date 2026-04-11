#!/usr/bin/env bash

readonly bt_dir="$HOME/.config/bluetooth"
readonly filepath="$bt_dir/devices.conf"
readonly OS="$(uname -s)"

function main() {
    local cmd="$1"
    shift

    case "$cmd" in
        connect|con)
            bt_connect "$@"
            ;;

        disconnect|dis|dc)
            bt_disconnect "$@"
            ;;

        status|st)
            bt_is_connected "$@"
            ;;

        find)
            bt_find_paired "$@"
            ;;

        save)
            bt_save_paired
            ;;

        list)
            bt_list_paired
            ;;

        help|"")
            bt_help
            ;;

        *)
            echo "Unknown command $cmd"
            bt_help
            return 1
            ;;

    esac
}

function bt_save_paired() {
    local cmd
    local regex

    if [[ $OS == "Darwin" ]]; then
        cmd=(blueutil --paired)
        regex='([0-9a-f-]{17}).*"([^"]+)"'
    else
        cmd=(bluetoothctl devices)
        regex='^Device[[:space:]]+([0-9A-F:]{17})[[:space:]]+(.+)$'
    fi

    if ! command -v ${cmd[0]} &> /dev/null; then
        echo "${cmd[0]} not found..." >&2
        return 1
    fi

    declare -A devices

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

function bt_list_paired() {

    if [[ $OS == "Darwin" ]]; then
        cmd=(blueutil --paired)
    else
        cmd=(bluetoothctl devices)
    fi

    "${cmd[@]}"
}

function bt_find_paired() {
    local keyword="$1"

    while IFS="=" read -r key value; do
        if [[ "${key,,}" =~ "${keyword,,}" ]]; then
            echo "$value"
        fi
    done < "$filepath"
}

function bt_connect() {
    local cmd
    local mac_address=$(bt_find_paired "$1") 

    if [[ $OS == "Darwin" ]]; then
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

function bt_disconnect() {
    local mac
    mac="$(bt_find_paired "$1")"

    if [[ -z $mac ]]; then
        echo "Device not found..."
        return 1
    fi

    if bt_is_connected "$mac" &> /dev/null; then
        if [[ $OS == "Darwin" ]]; then
            blueutil --disconnect "$mac" &> /dev/null
        else
            bluetoothctl disconnect "$mac" &> /dev/null
        fi

        if [[ $? -eq 0 ]]; then
            echo "Disconnected device successfully"
        else
            echo "Error disconnecting device..."
            return 1
        fi
    else
        echo "Device is not connected..."
        return 1
    fi
}

function bt_is_connected() {
    local mac="$1"
    local output

    if [[ $OS == "Darwin" ]]; then
        [[ $(blueutil --is-connected "$mac") == 1 ]]
    else
        output="$(bluetoothctl info "$mac")"
        [[ $output == *"Connected: yes"* ]]
    fi
}

function bt_help() {
    cat <<EOF
    Bluetooth helper

    Usage:
      bt connect <device>
      bt disconnect <device>
      bt status <device>
      bt list
      bt save

    Aliases:
      connect     con
      disconnect  dis dc
      status      st
EOF
}

main "$@"
