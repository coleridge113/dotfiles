#!/usr/bin/env bash

function android_run() {
    local task="$1"
    
    # 1. Build the APK
    echo "Building: $task"
    ./gradlew clean "$task" --no-daemon || { echo "Build failed!"; return 1; }

    # 2. Find the newly generated APK
    APK_PATH=$(find app/build/outputs/apk/ -name "*.apk" -print0 | xargs -0 ls -t | head -n 1)

    if [ -z "$APK_PATH" ] || [ ! -f "$APK_PATH" ]; then
        echo "Error: Could not find APK."
        return 1
    fi
    
    echo "Found APK: $APK_PATH"

    # 3. Read the EXACT Application ID from Gradle's output-metadata.json
    # This file lives in the exact same folder as the APK
    JSON_PATH="$(dirname "$APK_PATH")/output-metadata.json"
    
    if [ -f "$JSON_PATH" ]; then
        # Parse the JSON for the final, true applicationId (including any flavor suffixes)
        PACKAGE_NAME=$(grep -o '"applicationId": *"[^"]*"' "$JSON_PATH" | head -1 | cut -d'"' -f4)
    else
        # Fallback just in case
        PACKAGE_NAME=$(awk -F'["'\'']' '/applicationId|namespace/ {print $2; exit}' app/build.gradle | tr -d '\r')
    fi

    if [ -z "$PACKAGE_NAME" ]; then
        echo "Error: Could not determine package name."
        return 1
    fi
    
    echo "Resolved Package Name: $PACKAGE_NAME"

    # 4. Install the APK
    echo "Installing $PACKAGE_NAME..."
    adb install -r "$APK_PATH" || { echo "Installation failed!"; return 1; }

    # Buffer for the OS to register the app
    sleep 2

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
