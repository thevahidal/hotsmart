#!/bin/bash

cli=$0
command=$1

hotspotshield="hotspotshield"
connect="connect"
disconnect="disconnect"
help="help"
locations="locations"
completion="completion"

initializing="initializing"
starting="starting"
connecting="connecting"
disconnected="disconnected"
connected="connected"

help() {
    echo "Hotsmart | An smarter CLI for Hotspotshield."
    echo
    echo "Syntax: $cli [command] [extra]"
    echo "options:"
    echo "  $connect    | c  [LOCATION]      Connect to [LOCATION]."
    echo "  $disconnect | d                  Disconnect."
    echo "  $locations  | l                  List of all available locations."
    echo "  $completion | C  [SHELL]         Enable code completion for your shell. (bash)"
    echo "  $help       | h                  Print this help."
    echo
}

log_status() {
    prev_status=""

    while sleep 1; do 
        status="$(hotspotshield status)"

        if [[ "$status" == "$prev_status" ]]; then
            continue
        fi

        if [[ "$status" == *"$initializing"* ]]; then
            echo "Initializing..."
        elif [[ "$status" == *"$starting"* ]]; then
            echo "Starting..."
        elif [[ "$status" == *"$connecting"* ]]; then
            echo "Connecting..."
        elif [[ "$status" == *"$disconnected"* ]]; then
            echo "Disconnected."
            break
        elif [[ "$status" == *"$connected"* ]]; then
            echo "Connected to $location."
            break
        fi

        prev_status=$status
    done
}

if ! command -v hotspotshield &>/dev/null; then
    echo "Hotspotshield CLI could not be found. Make sure it's installed."
    exit
fi

if [ $command == "connect" ] || [ $command == "c" ]; then
    location=$2

    if [ -z $location ]; then
        echo "Location is required."
        echo "Syntax: $cli connect [LOCATION]"
        echo "e.g. $cli connect DE"

        exit
    elif [ $location == "smart" ]; then
        echo "Not implemented yet."
        exit
    fi

    $hotspotshield $disconnect >/dev/null 2>&1
    $hotspotshield $connect $location >/dev/null 2>&1

    log_status
elif [ $command == "$disconnect" ]  || [ $command == "d" ]; then
    $hotspotshield $disconnect >/dev/null 2>&1
    log_status
elif [ $command == "$locations" ]  || [ $command == "l" ]; then
    $hotspotshield $locations
elif [ $command == "$completion" ]  || [ $command == "C" ]; then
    shell=$2
    
    if [ -z $shell ]; then
        echo "Shell is required."
        echo "Syntax: $cli completion [SHELL]"
        echo "e.g. $cli completion bash"
        echo "Available Shells: bash"

        exit
    fi

    echo "Activating shell completion for $shell"

else
    help
fi

echo
