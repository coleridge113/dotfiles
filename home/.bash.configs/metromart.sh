#!/bin/bash

export METROMART="$HOME/dev/metromart"

alias mm="cd $METROMART"

# Projects
alias cs="cd $METROMART/projects/android-cs-java"
alias rs="cd $METROMART/projects/android-rs-java"
alias rsk="cd $METROMART/projects/android-rs-kotlin"
alias loc="cd $METROMART/projects/location-tracking-poc"
alias server="cd $METROMART/projects/server"
alias emit="cd $METROMART/projects/location-emitter"
alias maps="cd $METROMART/projects/demo-maps"
alias cog="cd $METROMART/projects/aws-cognito-test"

#DSM
alias dsm="nvim $METROMART/docs/dsm-notes"

# Gradle
alias ad1="./gradlew clean assembleRs_stg_1_Debug"

register_token() {
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

cancel_jo() {
    JOB_ORDER="$1"

    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
        -X POST "https://api-staging.metromart.com/api/v1/job-orders/$JOB_ORDER/cancel" \
        -H "Authorization: $WEB_TOKEN" \
        -H "Content-Type: application/json" \
        -d '{"data":{"relationships":{"job-order-cancelled-reason":{"data":{"id":"37","type":"job-order-cancelled-reasons"}}}}}')

    echo "Response code: $RESPONSE"
}
alias cj="cancel_jo"

status() {
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


