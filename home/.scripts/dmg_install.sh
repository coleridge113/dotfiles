#!/usr/bin/env zsh

function install_dmg() {
  local dmg="$1"

  echo "==> Starting DMG install"
  echo "DMG path: $dmg"

  if [[ ! -f "$dmg" ]]; then
    echo "ERROR: File does not exist"
    return 1
  fi

  echo "==> Mounting DMG..."

  # mount and capture plist output
  local plist
  plist=$(hdiutil attach -nobrowse -plist "$dmg")

  # extract mount point
  local vol
  vol=$(echo "$plist" | plutil -extract system-entities xml1 -o - - \
        | grep -A1 mount-point \
        | tail -n1 \
        | sed 's/.*<string>\(.*\)<\/string>.*/\1/')

  if [[ -z "$vol" ]]; then
    echo "ERROR: Failed to detect mount point"
    return 1
  fi

  echo "Mounted at: $vol"

  echo "==> Searching for app..."
  local app
  app=$(find "$vol" -maxdepth 2 -name "*.app" -print -quit)

  if [[ -z "$app" ]]; then
    echo "ERROR: No app found"
    hdiutil detach "$vol"
    return 1
  fi

  echo "Found app: $app"

  echo "==> Copying to Applications..."
  cp -R "$app" /Applications

  echo "==> Unmounting..."
  hdiutil detach "$vol" -quiet

  echo "==> Install complete 🎉"
}

install_dmg "$1"
