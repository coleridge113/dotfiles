#!/bin/bash

# Save PID to a file for easy stopping
PID_FILE="/tmp/ghostty_focus.pid"
echo $$ > "$PID_FILE"
trap "rm -f \"$PID_FILE\"" EXIT

# This script shows the desktop whenever ghostty is focused.
# It minimizes other windows on the current workspace, requiring xdotool.

# Check for dependencies
for cmd in xdotool wmctrl xprop; do
  if ! command -v "$cmd" &> /dev/null; then
    echo "Error: Command '$cmd' is not installed." >&2
    echo "Please install '$cmd' to use this script." >&2
    exit 1
  fi
done

GHOSTTY_WM_CLASS="com.mitchellh.ghostty"
ghostty_was_active=0

while true; do
  # Get the ID of the active window
  active_win_id=$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $5}')

  # Get the class of the active window
  # Redirect stderr to /dev/null to hide errors if the window disappears too quickly
  active_win_class_info=$(xprop -id "$active_win_id" WM_CLASS 2>/dev/null)

  # Check if ghostty is the active window
  if echo "$active_win_class_info" | grep -q "$GHOSTTY_WM_CLASS"; then
    if [ $ghostty_was_active -eq 0 ]; then
      # Store the active ghostty window ID
      ghostty_win_id=$active_win_id

      # Get current workspace
      current_ws=$(wmctrl -d | grep '*' | awk '{print $1}')

      # Minimize all other normal windows on the current workspace to avoid flicker.
      wmctrl -l | while read -r win_id win_ws _; do
        # Process only windows on the current workspace (or sticky windows, ws=-1)
        if [ "$win_ws" = "$current_ws" ] || [ "$win_ws" = "-1" ]; then
          # Compare window IDs as numbers to handle different hex formats (0x... vs 0x0...)
          if [ $((win_id)) -ne $((ghostty_win_id)) ]; then
            # Check if it is a normal window, to avoid minimizing panels, docks, etc.
            if xprop -id "$win_id" _NET_WM_WINDOW_TYPE 2>/dev/null | grep -q "_NET_WM_WINDOW_TYPE_NORMAL"; then
              xdotool windowminimize "$win_id" 2>/dev/null
            fi
          fi
        fi
      done
    fi
    ghostty_was_active=1
  else
    ghostty_was_active=0
  fi

  # Wait for a bit before checking again to avoid high CPU usage
  sleep 0.5
done
