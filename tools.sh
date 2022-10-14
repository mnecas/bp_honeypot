#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

DEBUG=${DEBUG:0}
HONEYPOT_SERVER=${SERVER:-"127.0.0.1:8000"}

err() {
    echo -e "$RED[ERROR][$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*$ENDCOLOR" >&2
}

debug() {
    if [[ $DEBUG -gt 0 ]]
    then
        echo -e "[DEBUG][$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&1
    fi
}

send(){
    endpoint="$1"
    data_params="${@: 2}"
    debug "SEND: Endpoint: $endpoint"
    debug "SEND: Data params: $data_params"
    # -w "%{http_code}" \
    curl \
        -H "Authorization: Token $TOKEN" \
        --connect-timeout 5 \
        --max-time 10 \
        --retry 5 \
        --retry-delay 0 \
        --retry-max-time 40 \
        $data_params \
        http://$HONEYPOT_SERVER/api/honeypots/$ID/$endpoint
}


display_help() {
    # taken from https://stackoverflow.com/users/4307337/vincent-stans
    echo "Usage: $0 [option...] {start|stop|restart}" >&2
    echo
    echo "   -r, --resolution           run with the given resolution WxH"
    echo "   -d, --display              Set on which display to host on "
    echo
    # echo some stuff here for the -a or --add-options 
    exit 1
}