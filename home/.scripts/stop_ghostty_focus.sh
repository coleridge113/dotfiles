#!/bin/bash

PID_FILE="/tmp/ghostty_focus.pid"

if [ -f "$PID_FILE" ]; then
  PID=$(cat "$PID_FILE")
  # Check if a process with that PID is running and is the ghostty_focus.sh script
  if ps -p "$PID" -o cmd= | grep -q "ghostty_focus.sh"; then
    echo "Stopping ghostty_focus (PID: $PID)..."
    kill "$PID"
  else
    echo "No running ghostty_focus script found with PID $PID. Removing stale PID file."
    rm -f "$PID_FILE"
  fi
else
  echo "ghostty_focus is not running (PID file not found)."
fi
