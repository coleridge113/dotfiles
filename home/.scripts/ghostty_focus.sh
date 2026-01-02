#!/bin/bash

# This script shows the desktop whenever ghostty is focused.

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

      # Toggle "Show Desktop" to minimize all windows
      wmctrl -k on

      # Re-activate the ghostty window, which brings it back from being minimized
      wmctrl -i -a "$ghostty_win_id"
    fi
    ghostty_was_active=1
  else
    ghostty_was_active=0
  fi

  # Wait for a bit before checking again to avoid high CPU usage
  sleep 0.5
done
