#!/usr/bin/env bash

function android_run() {
    local task="$1"
    
    if [ -z "$task" ]; then
        echo "Error: Please specify a task (e.g., assembleDebug)"
        return 1
    fi

    # 1. Build the APK incrementally (REMOVED 'clean')
    echo "Building: $task"
    ./gradlew "$task" --no-daemon || { echo "Build failed!"; return 1; }

    # Extract the build variant type (e.g., "assembleDebug" -> "debug", "assembleRelease" -> "release")
    # This handles flavor variants safely so we search the correct directory.
    local variant=$(echo "$task" | sed 's/assemble//' | tr '[:upper:]' '[:lower:]')

    # 2. Target the specific build variant folder directly
    local apk_dir="app/build/outputs/apk/$variant"
    
    # Fallback to general apk directory if the specific variant folder structure doesn't match
    if [ ! -d "$apk_dir" ]; then
        apk_dir="app/build/outputs/apk"
    fi

    APK_PATH=$(find "$apk_dir" -name "*.apk" -print0 2>/dev/null | xargs -0 ls -t 2>/dev/null | head -n 1)

    if [ -z "$APK_PATH" ] || [ ! -f "$APK_PATH" ]; then
        echo "Error: Could not find APK in $apk_dir."
        return 1
    fi
    
    echo "Using APK: $APK_PATH"

    # 3. Read the EXACT Application ID from Gradle's output-metadata.json
    JSON_PATH="$(dirname "$APK_PATH")/output-metadata.json"
    
    if [ -f "$JSON_PATH" ]; then
        PACKAGE_NAME=$(grep -o '"applicationId": *"[^"]*"' "$JSON_PATH" | head -1 | cut -d'"' -f4)
    else
        PACKAGE_NAME=$(awk -F'["'\'']' '/applicationId|namespace/ {print $2; exit}' app/build.gradle | tr -d '\r')
    fi

    if [ -z "$PACKAGE_NAME" ]; then
        echo "Error: Could not determine package name."
        return 1
    fi
    
    echo "Resolved Package Name: $PACKAGE_NAME"

    # 4. Install the APK (adb is smart; if it's already installed, this is incredibly fast)
    echo "Installing $PACKAGE_NAME..."
    adb install -r "$APK_PATH" || { echo "Installation failed!"; return 1; }

    # 5. Dynamically find the exact MainActivity path and Launch
    echo "Resolving launch intent..."
    COMPONENT=$(adb shell cmd package resolve-activity --brief -c android.intent.category.LAUNCHER "$PACKAGE_NAME" | tail -n 1 | tr -d '\r')
    
    if [[ "$COMPONENT" == *"No activity found"* ]] || [[ -z "$COMPONENT" ]]; then
        echo "Error: OS could not find a launchable activity for $PACKAGE_NAME"
        return 1
    fi

    echo "Launching: $COMPONENT"
    adb shell am start -n "$COMPONENT"
    
    echo "Done!"
}

# Execute
android_run "$@"
