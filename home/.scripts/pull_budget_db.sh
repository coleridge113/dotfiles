#!/usr/bin/env bash

function pull_budget_db() {

    local PACKAGE="com.luna.budgetapp"
    local DB_NAME="budget_db"

    #######################################
    # resolve output directory
    #######################################
    local BASE_DIR="${BUDGET:-$PWD}"
    local OUTPUT_DIR="$BASE_DIR/db_backup_$(date +%Y%m%d_%H%M%S)"

    #######################################
    # check adb
    #######################################
    if ! command -v adb >/dev/null 2>&1; then
        echo "❌ adb not found. Install Android platform-tools."
        return 1
    fi

    #######################################
    # ensure device connected
    #######################################
    if ! adb get-state >/dev/null 2>&1; then
        echo "❌ No adb device detected"
        return 1
    fi

    echo "📁 Creating output directory:"
    echo "$OUTPUT_DIR"

    mkdir -p "$OUTPUT_DIR"

    #######################################
    # helper to pull db files
    #######################################
    pull_file() {
        local remote_path="$1"
        local local_path="$2"

        if adb shell "run-as $PACKAGE test -f $remote_path" >/dev/null 2>&1; then
            adb shell "run-as $PACKAGE cat $remote_path" > "$local_path"
            echo "✔ Pulled $(basename "$remote_path")"
        else
            echo "⚠ Skipped $(basename "$remote_path") (not found)"
        fi
    }

    #######################################
    # pull database files
    #######################################
    echo "📦 Pulling database files..."

    local DB_PATH="/data/data/$PACKAGE/databases"

    pull_file "$DB_PATH/$DB_NAME" "$OUTPUT_DIR/$DB_NAME"
    pull_file "$DB_PATH/$DB_NAME-wal" "$OUTPUT_DIR/$DB_NAME-wal"
    pull_file "$DB_PATH/$DB_NAME-shm" "$OUTPUT_DIR/$DB_NAME-shm"

    #######################################
    # copy path to clipboard
    #######################################
    if command -v pbcopy >/dev/null 2>&1; then
        echo -n "$OUTPUT_DIR" | pbcopy

    elif command -v wl-copy >/dev/null 2>&1; then
        echo -n "$OUTPUT_DIR" | wl-copy

    elif command -v xclip >/dev/null 2>&1; then
        echo -n "$OUTPUT_DIR" | xclip -selection clipboard

    else
        echo "⚠ Clipboard tool not found"
    fi

    #######################################
    # done
    #######################################
    echo ""
    echo "✅ Done!"
    echo "Files saved in:"
    echo "$OUTPUT_DIR"
    echo ""
    echo "📋 Path copied to clipboard"
}

#######################################
# execute
#######################################
pull_budget_db "$@"
