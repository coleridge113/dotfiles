export METROMART="$HOME/dev/metromart"
export AWS_DEMO="$METROMART/projects/aws-demo"

alias mm="cd $METROMART"

# Projects
alias cs="cd $METROMART/projects/android-cs-java"
alias rs="cd $METROMART/projects/android-rs-java"
alias rsk="cd $METROMART/projects/android-rs-kotlin"
alias loc="cd $METROMART/projects/location-tracking-poc"
alias server="cd $METROMART/projects/server"
alias emit="cd $METROMART/projects/location-emitter"
alias maps="cd $AWS_DEMO/demo-maps"
alias cog="cd $AWS_DEMO/aws-cognito-test"
alias event="cd $AWS_DEMO/aws-demo-backend"
alias demo="cd $AWS_DEMO"

# Navigation
alias build_output="cd ./app/build/outputs/apk/cs_stg_/debug"

# DSM
alias dsm="nvim $NOTES/metromart/dsm-notes.md"

# Templates
alias csqa="nvim $METROMART/templates/cs-qa.md"
alias cspr="nvim $METROMART/templates/cs-pr.md"
alias rsqa="nvim $METROMART/templates/rs-qa.md"
alias rspr="nvim $METROMART/templates/rs-pr.md"

# Gradle
alias build_cs='gradle_build_notify assembleCs_stg_Debug'
alias build_csr='gradle_build_notify assembleCs_stg_Release'
alias build_rs1='gradle_build_notify assembleRs_stg_1_Debug'
alias build_cs1='gradle_build_notify assembleCs_stg_1_Debug'

alias run_cs='run_gradle_variant installCs_stg_Debug'
alias deb_cs='run_gradle_variant_debug installCs_stg_Debug'

function gradle_build_notify () {

    local task="$1"
    shift

    #######################################
    # Parse flags
    #######################################
    local should_open=false

    for arg in "$@"; do
        case "$arg" in
            --open|-op)
                should_open=true
                ;;
        esac
    done


    #######################################
    # Detect OS
    #######################################
    local os
    os="$(uname)"

    #######################################
    # Resolve Java 17
    #######################################
    local j_home=""

    if [[ "$os" == "Darwin" ]]; then
        j_home=$(
            /usr/libexec/java_home -v 17 2>/dev/null \
                || /usr/libexec/java_home 2>/dev/null
            )
        else
            local jvm_dir="/usr/lib/jvm"

            for candidate in \
                "$jvm_dir/java-17-openjdk" \
                "$jvm_dir/java-17-openjdk-"* \
                "$jvm_dir/jdk-17"*; do

            if [[ -d "$candidate" ]]; then
                j_home="$candidate"
                break
            fi
        done

        if [[ -z "$j_home" ]] && command -v java >/dev/null 2>&1; then
            j_home="$(dirname "$(dirname "$(readlink -f "$(command -v java)")")")"
        fi
    fi

    : "${j_home:=$JAVA_HOME}"

    if [[ -z "$j_home" ]]; then
        echo "❌ Java 17 not found"
        return 1
    fi

    echo "🔨 Building with Java:"
    echo "   $j_home"
    echo


    #######################################
    # Move to project folder
    #######################################
    cd "$METROMART/projects/android-cs-java" || return 1


    #######################################
    # Stop daemons
    #######################################
    ./gradlew --stop >/dev/null 2>&1


    #######################################
    # Run build
    #######################################
    if JAVA_HOME="$j_home" ./gradlew clean "$task"; then

    #######################################
    # success notification
    #######################################
    if [[ "$os" == "Darwin" ]]; then
        osascript -e \
            "display notification \"$task finished\" with title \"✅ Build Success\""
    else
        command -v notify-send >/dev/null 2>&1 \
            && notify-send "✅ Build Success" "$task finished" \
            || echo "✅ Build Success: $task finished"
    fi


    #######################################
    # open apk folder
    #######################################
    if $should_open; then

        local apk_path

        apk_path=$(
            find . -path "*/outputs/apk/*" -name "*.apk" -print0 \
                | xargs -0 ls -t 2>/dev/null \
                | head -n 1
            )

            if [[ -n "$apk_path" ]]; then

                echo
                echo "📦 Opening:"
                echo "$apk_path"

                open "$(dirname "$apk_path")"

            else
                echo "⚠️ APK not found"
            fi

    fi


else

#######################################
# failure notification
#######################################
if [[ "$os" == "Darwin" ]]; then
    osascript -e \
        "display notification \"$task failed\" with title \"❌ Build Failed\""
else
    command -v notify-send >/dev/null 2>&1 \
        && notify-send "❌ Build Failed" "$task failed" \
        || echo "❌ Build Failed: $task failed"
fi

    fi
}

function register_token() {
    TYPE="$1"
    TOKEN="$2"

    case "$TYPE" in
      web) export WEB_TOKEN="$TOKEN" ;;
      as)  export SHOPPER_TOKEN="$TOKEN" ;;
      ar)  export RIDER_TOKEN="$TOKEN" ;;
      *)   echo "Unknown type: $TYPE" ;;
    esac
}
alias rt="register_token"

function cancel_jo() {
    JOB_ORDER="$1"

    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
        -X POST "https://api-staging.metromart.com/api/v1/job-orders/$JOB_ORDER/cancel" \
        -H "Authorization: $WEB_TOKEN" \
        -H "Content-Type: application/json" \
        -d '{"data":{"relationships":{"job-order-cancelled-reason":{"data":{"id":"37","type":"job-order-cancelled-reasons"}}}}}')

    echo "Response code: $RESPONSE"
}
alias cj="cancel_jo"

function status() {
    JOB_ORDER="$1"
    STATUS="${2:-assigning}"   # default to "assigning" if $2 is empty

    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
        -X PUT \
        -H "Authorization: $SHOPPER_TOKEN" \
        -H "Content-Type: application/json; charset=UTF-8" \
        -H "X-Client-App: RS" \
        -H "X-Client-Platform: Android" \
        -H "X-Client-Version: 160" \
        -d "{\"data\":{\"attributes\":{\"delivery-status\":\"$STATUS\"}}}" \
        "https://api-staging.metromart.com/api/v1/job-orders/$JOB_ORDER" -L)

    echo "Response code: $RESPONSE"
}
alias status="status"

function assign() {
    # Ensure variables are local to prevent side effects
    local JOB_ORDER="$1"
    local RESPONSE
    
    # Using double quotes for the data block to allow variable expansion
    RESPONSE=$(curl -so /dev/null -w "%{http_code}" "https://api-staging.metromart.com/api/v1/consignments?include=job-order.checkout,user" \
        -X POST \
        -H "accept: application/vnd.api+json" \
        -H "content-type: application/vnd.api+json" \
        -H "authorization: $WEB_TOKEN" \
        --data-raw "{
            \"data\": {
                \"attributes\": {
                    \"principal\": false,
                    \"dispatch-type\": null,
                    \"manual-dispatch-reason\": \"Runners/Shoppers accident\",
                    \"updated-at\": null,
                    \"created-at\": null
                },
                \"relationships\": {
                    \"user\": { \"data\": { \"type\": \"users\", \"id\": \"414437\" } },
                    \"job-order\": { \"data\": { \"type\": \"job-orders\", \"id\": \"$JOB_ORDER\" } },
                    \"assigned-by-user\": { \"data\": null }
                },
                \"type\": \"consignments\"
            }
        }"
    )
    
    echo "Response code: $RESPONSE"
}

function run_gradle_variant() {
    local variant="$1"

    if [[ -z "$variant" ]]; then
        echo "usage: run_gradle_variant <GradleTask>"
        return 1
    fi

    # Detect OS once
    local os
    os="$(uname)"

    # Stop gradle daemon on Linux only (helps avoid stale locks)
    if [[ "$os" != "Darwin" ]]; then
        ./gradlew --stop >/dev/null 2>&1
    fi

    # Run build
    ./gradlew "$variant" || return 1

    # ---------- ANDROID ----------
    if [[ "$variant" == *"install"* ]] || [[ "$variant" == *"Debug"* ]]; then
        local pkg

        pkg=$(
            adb shell pm list packages \
            | grep metromart \
            | cut -d: -f2 \
            | tr -d '\r' \
            | tail -n 1
        )

        if [[ -z "$pkg" ]]; then
            echo "Android package not detected"
            echo "Check adb device connection"
            return 1
        fi

        echo "Launching Android: $pkg"
        adb shell monkey -p "$pkg" 1
        return 0
    fi

    # ---------- DESKTOP APP ----------
    local app_path
    app_path=$(find ./build -name "*.app" -type d | head -n 1)

    if [[ -z "$app_path" ]]; then
        echo "No .app found in ./build"
        return 0
    fi

    echo "Launching desktop app: $app_path"

    case "$os" in
        Darwin)
            open "$app_path"
            ;;
        Linux)
            xdg-open "$app_path" >/dev/null 2>&1 &
            ;;
        *)
            echo "Unsupported OS: $os"
            ;;
    esac
}

function debug_gradle_variant() {
    local variant="$1"

    ./gradlew "$variant" || return 1

    local pkg
    pkg=$(adb shell pm list packages | grep metromart | cut -d: -f2 | tr -d '\r' | tail -n 1)

    echo "Debug launching $pkg"

    adb shell am start -D \
        -a android.intent.action.MAIN \
        -c android.intent.category.LAUNCHER \
        -p "$pkg"
}

