#!/bin/bash

PACKAGE="com.luna.budgetapp"
DB_NAME="budget_db"   # change if needed

if ! adb get-state 1>/dev/null 2>&1; then
    echo "❌ No adb device detected."
    exit 1
fi

if [ ! -f "$DB_NAME" ]; then
    echo "❌ $DB_NAME not found in current directory."
    exit 1
fi

echo "⛔ Force stopping app..."
adb shell am force-stop $PACKAGE

echo "📁 Ensuring databases directory exists..."
adb shell "run-as $PACKAGE mkdir -p /data/data/$PACKAGE/databases"

echo "⬆️ Installing main DB..."
cat "$DB_NAME" | adb shell "run-as $PACKAGE sh -c 'cat > /data/data/$PACKAGE/databases/$DB_NAME'"

if [ -f "$DB_NAME-wal" ]; then
    echo "⬆️ Installing WAL..."
    cat "$DB_NAME-wal" | adb shell "run-as $PACKAGE sh -c 'cat > /data/data/$PACKAGE/databases/$DB_NAME-wal'"
fi

if [ -f "$DB_NAME-shm" ]; then
    echo "⬆️ Installing SHM..."
    cat "$DB_NAME-shm" | adb shell "run-as $PACKAGE sh -c 'cat > /data/data/$PACKAGE/databases/$DB_NAME-shm'"
fi

echo "🚀 Restarting app..."
adb shell monkey -p $PACKAGE -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1

echo ""
echo "✅ Database installed successfully."
