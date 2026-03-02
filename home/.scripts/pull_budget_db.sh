#!/bin/bash

PACKAGE="com.luna.budgetapp"
DB_NAME="budget_db"
OUTPUT_DIR="$BUDGET/db_backup_$(date +%Y%m%d_%H%M%S)"

echo "Creating output directory: $OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

echo "Pulling main database..."
adb shell "run-as $PACKAGE cat /data/data/$PACKAGE/databases/$DB_NAME" > "$OUTPUT_DIR/$DB_NAME"

echo "Pulling WAL file..."
adb shell "run-as $PACKAGE cat /data/data/$PACKAGE/databases/$DB_NAME-wal" > "$OUTPUT_DIR/$DB_NAME-wal"

echo "Pulling SHM file..."
adb shell "run-as $PACKAGE cat /data/data/$PACKAGE/databases/$DB_NAME-shm" > "$OUTPUT_DIR/$DB_NAME-shm"

echo ""
echo "✅ Done!"
echo "Files saved in: $OUTPUT_DIR"
