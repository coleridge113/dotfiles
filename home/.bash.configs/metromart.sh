#!/bin/bash

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

# DSM
alias dsm="nvim $NOTES/metromart/dsm-notes.md"

# Templates
alias csqa="nvim $METROMART/templates/cs-qa.md"
alias cspr="nvim $METROMART/templates/cs-pr.md"
alias rsqa="nvim $METROMART/templates/rs-qa.md"
alias rspr="nvim $METROMART/templates/rs-pr.md"

# Gradle
alias build_cs='gradle_build_notify assembleCs_stg_Debug'
alias build_rs1='gradle_build_notify assembleRs_stg_1_Debug'
alias build_cs1='gradle_build_notify assembleCs_stg_1_Debug'

function gradle_build_notify () {
  local task=$1
  local j_home=""

  # OS-specific JDK 17 Resolution
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS: Ask the system for the JDK 17 path
    j_home=$(/usr/libexec/java_home -v 17 2>/dev/null)
  else
    # Arch: Use the standard JVM path or default
    j_home="/usr/lib/jvm/java-17-openjdk"
  fi

  # Fallback: If 17 isn't found, use the current JAVA_HOME
  : "${j_home:=$JAVA_HOME}"

  echo "🔨 Building with Java: $j_home"
  ./gradlew --stop

  # Execute with the scoped JAVA_HOME
  if JAVA_HOME="$j_home" ./gradlew clean "$task"; then
    notify-send "Build Success" "$task finished"
  else
    notify-send "Build Failed" "$task failed"
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

function aws_track_history() {
    aws location get-device-position-history \
        --device-id "$1" \
        --tracker-name MetromartDemoTracker 
}

function aws_track_delete() {
    aws location batch-delete-device-position-history \
        --tracker-name MetromartDemoTracker \
        --device-ids "$1"
}

function aws_track_list() {
    aws location list-device-positions \
        --tracker-name MetromartDemoTracker \
        --region ap-southeast-1
}

function ampx_sandbox() {
    npx ampx sandbox --outputs-out-dir \
        ../aws-cognito-test/app/src/main/res/raw
}
