#!/bin/bash

# This script adjusts the opacity of inactive windows when a ghostty window is
# focused, creating a "focus mode". It is designed for the Hyprland compositor.
#
# Dependencies: hyprctl (comes with Hyprland), socat

# --- Configuration ---
GHOSTTY_WM_CLASS="com.mitchellh.ghostty"
# Your default inactive opacity.
# Most users have this at 1.0, but change if your config is different.
DEFAULT_INACTIVE_OPACITY=1.0
# The opacity of inactive windows when ghostty is focused.
FOCUSED_INACTIVE_OPACITY=0.2
# --- End Configuration ---


# Check for dependencies
if ! command -v socat &> /dev/null; then
  echo "Error: Command 'socat' is not installed." >&2
  echo "Please install 'socat' to use this script."
  exit 1
fi
if ! command -v hyprctl &> /dev/null; then
  echo "Error: Command 'hyprctl' is not installed or not in your PATH." >&2
  echo "This script is designed for the Hyprland compositor."
  exit 1
fi


# Save PID to a file for easy stopping
PID_FILE="/tmp/ghostty_focus_wayland.pid"
echo $$ > "$PID_FILE"
trap "rm -f \"$PID_FILE\"; hyprctl keyword decoration:inactive_opacity $DEFAULT_INACTIVE_OPACITY; exit" EXIT SIGHUP SIGINT SIGTERM

echo "Ghostty focus script started for Hyprland. PID: $$"

# 0 = normal mode, 1 = ghostty focus mode
focus_mode_active=0

# Subscribe to Hyprland's active window event stream using socat.
# This is more efficient than a polling loop.
socat -U - "UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r event;
do
  # The event for a focused window looks like: "activewindow>>WINDOWCLASS,WINDOWTITLE"
  if [[ $event == "activewindow>>"* ]]; then
    # Extract the window class from the event string
    active_class=$(echo "$event" | cut -d'>' -f3 | cut -d',' -f1)

    if [[ $active_class == "$GHOSTTY_WM_CLASS" ]]; then
      # Ghostty window is now active.
      # If focus mode is not already active, activate it.
      if [ $focus_mode_active -eq 0 ]; then
        echo "Ghostty focused, entering focus mode."
        hyprctl keyword decoration:inactive_opacity "$FOCUSED_INACTIVE_OPACITY"
        focus_mode_active=1
      fi
    else
      # A non-ghostty window is now active.
      # If focus mode was active, deactivate it.
      if [ $focus_mode_active -eq 1 ]; then
        echo "Ghostty unfocused, leaving focus mode."
        hyprctl keyword decoration:inactive_opacity "$DEFAULT_INACTIVE_OPACITY"
        focus_mode_active=0
      fi
    fi
  fi
done