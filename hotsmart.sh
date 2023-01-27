#!/bin/bash

home_dir=~
installation_dir=${home_dir}/.hotsmart/
hotsmart_file=hotsmart.sh
completion_file=hotsmart-completion.bash

cli=$0
command=$1

start="start"
status="status"
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
    echo "  $status     | s                  Show current status info."
    echo "  $help       | h                  Print this help."
    echo
}

log_status() {
    prev_status=""

    while sleep 1; do 
        status_output="$(hotspotshield status)"

        if [[ "$status_output" == "$prev_status" ]]; then
            continue
        fi

        if [[ "$status_output" == *"$initializing"* ]]; then
            echo "Initializing..."
        elif [[ "$status_output" == *"$starting"* ]]; then
            echo "Starting..."
        elif [[ "$status_output" == *"$connecting"* ]]; then
            echo "Connecting..."
        elif [[ "$status_output" == *"$disconnected"* ]]; then
            echo "Disconnected."
            break
        elif [[ "$status_output" == *"$connected"* ]]; then
            echo "Connected."
            break
        fi

        prev_status=$status_output
    done
}

if ! command -v hotspotshield &>/dev/null; then
    echo "Hotspotshield CLI could not be found. Make sure it's installed."
    exit
fi

if [ $command == "$connect" ] || [ $command == "c" ]; then
    location_arg=$2

    if [ -z $location_arg ]; then
        echo "Location is required."
        echo "Syntax: $cli connect [LOCATION]"
        echo "e.g. $cli connect DE"

        exit
    elif [ $location_arg == "smart" ]; then
        echo "Not implemented yet."
        exit
    fi

    hotspotshield start >/dev/null 2>&1
    hotspotshield disconnect >/dev/null 2>&1
    sleep 1
    hotspotshield connect $location_arg >/dev/null 2>&1

    log_status
elif [ $command == "$disconnect" ]  || [ $command == "d" ]; then
    hotspotshield disconnect >/dev/null 2>&1
    log_status
elif [ $command == "$status" ]  || [ $command == "s" ]; then
    hotspotshield status
elif [ $command == "$locations" ]  || [ $command == "l" ]; then
    hotspotshield locations
elif [ $command == "$completion" ]  || [ $command == "C" ]; then
    shell_arg=$2
    
    if [ -z $shell_arg ]; then
        echo "Shell is required."
        echo "Syntax: $cli completion [SHELL]"
        echo "e.g. $cli completion bash"
        echo "Available Shells: bash"

        exit
    fi

    sudo source ${installation_dir}${completion_file}
    
    locations_output = $(hotspotshield locations) 
    echo $locations_output

    echo "Shell completion for $shell_arg activated."

else
    help
fi

echo
