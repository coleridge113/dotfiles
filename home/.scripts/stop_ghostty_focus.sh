#!/bin/bash

PID_FILE="/tmp/ghostty_focus_wayland.pid"

if [ -f "$PID_FILE" ]; then
  PID=$(cat "$PID_FILE")
  echo "Stopping ghostty focus script with PID $PID..."
  kill "$PID"
  # The trap in the main script will handle cleanup and restore opacity.
  echo "Stop signal sent."
else
  echo "PID file not found. Is the script running?"
  exit 1
fi