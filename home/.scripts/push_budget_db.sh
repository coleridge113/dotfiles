#!/usr/bin/env zsh

PACKAGE="com.luna.budgetapp"
DB_NAME="budget_db"   # change if needed

# check adb
if ! command -v adb >/dev/null 2>&1; then
    echo "❌ adb not found. Install Android platform-tools."
    exit 1
fi

# check device
if ! adb get-state >/dev/null 2>&1; then
    echo "❌ No adb device detected."
    exit 1
fi

# check db file
if [[ ! -f "$DB_NAME" ]]; then
    echo "❌ $DB_NAME not found in current directory."
    exit 1
fi

echo "⛔ Force stopping app..."
adb shell am force-stop "$PACKAGE"

echo "📁 Ensuring databases directory exists..."
adb shell "run-as $PACKAGE mkdir -p /data/data/$PACKAGE/databases"

push_file() {
    local file="$1"
    local remote="$2"

    if [[ -f "$file" ]]; then
        echo "⬆️ Installing $(basename "$file")..."
        cat "$file" | adb shell "run-as $PACKAGE sh -c 'cat > $remote'"
    fi
}

echo "📦 Installing database..."

push_file "$DB_NAME" "/data/data/$PACKAGE/databases/$DB_NAME"
push_file "$DB_NAME-wal" "/data/data/$PACKAGE/databases/$DB_NAME-wal"
push_file "$DB_NAME-shm" "/data/data/$PACKAGE/databases/$DB_NAME-shm"

echo "🚀 Restarting app..."
adb shell monkey -p "$PACKAGE" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1

echo ""
echo "✅ Database installed successfully."

# optional macOS notification
osascript -e 'display notification "Database restore complete" with title "Budget DB"'
