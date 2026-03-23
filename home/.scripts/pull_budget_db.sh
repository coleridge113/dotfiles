#!/usr/bin/env zsh

PACKAGE="com.luna.budgetapp"
DB_NAME="budget_db"
OUTPUT_DIR="$BUDGET/db_backup_$(date +%Y%m%d_%H%M%S)"

# check adb
if ! command -v adb >/dev/null 2>&1; then
    echo "❌ adb not found. Install Android platform-tools."
    exit 1
fi

echo "📁 Creating output directory: $OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

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

echo "📦 Pulling database files..."

pull_file "/data/data/$PACKAGE/databases/$DB_NAME" "$OUTPUT_DIR/$DB_NAME"
pull_file "/data/data/$PACKAGE/databases/$DB_NAME-wal" "$OUTPUT_DIR/$DB_NAME-wal"
pull_file "/data/data/$PACKAGE/databases/$DB_NAME-shm" "$OUTPUT_DIR/$DB_NAME-shm"

echo ""
echo "✅ Done!"
echo "Files saved in:"
echo "$OUTPUT_DIR"
