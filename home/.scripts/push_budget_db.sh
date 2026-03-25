function push_budget_db() {

    local PACKAGE="com.luna.budgetapp"
    local DB_NAME="budget_db"

    #######################################
    # checks
    #######################################
    if ! command -v adb >/dev/null 2>&1; then
        echo "❌ adb not found. Install Android platform-tools."
        return 1
    fi

    if ! adb get-state >/dev/null 2>&1; then
        echo "❌ No adb device detected."
        return 1
    fi

    if [[ ! -f "$DB_NAME" ]]; then
        echo "❌ $DB_NAME not found in current directory."
        return 1
    fi

    #######################################
    # stop app
    #######################################
    echo "⛔ Force stopping app..."
    adb shell am force-stop "$PACKAGE"

    #######################################
    # ensure db dir exists
    #######################################
    echo "📁 Ensuring databases directory exists..."
    adb shell "run-as $PACKAGE mkdir -p /data/data/$PACKAGE/databases"

    #######################################
    # helper
    #######################################
    push_file() {
        local file="$1"
        local remote="$2"

        if [[ -f "$file" ]]; then
            echo "⬆️ Installing $(basename "$file")..."
            cat "$file" | adb shell "run-as $PACKAGE sh -c 'cat > $remote'"
        else
            echo "⚠ Skipped $(basename "$file") (not found)"
        fi
    }

    #######################################
    # install db
    #######################################
    echo "📦 Installing database..."

    local DB_PATH="/data/data/$PACKAGE/databases"

    push_file "$DB_NAME" "$DB_PATH/$DB_NAME"
    push_file "$DB_NAME-wal" "$DB_PATH/$DB_NAME-wal"
    push_file "$DB_NAME-shm" "$DB_PATH/$DB_NAME-shm"

    #######################################
    # restart app
    #######################################
    echo "🚀 Restarting app..."
    adb shell monkey -p "$PACKAGE" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1

    #######################################
    # notification (cross-platform)
    #######################################
    if command -v pbcopy >/dev/null 2>&1; then
        osascript -e 'display notification "Database restore complete" with title "Budget DB"'

    elif command -v notify-send >/dev/null 2>&1; then
        notify-send "Budget DB" "Database restore complete"
    fi

    #######################################
    # done
    #######################################
    echo ""
    echo "✅ Database installed successfully."
}

#######################################
# execute
#######################################
push_budget_db "$@"
