#!/bin/bash

if ! command -v hotspotshield &>/dev/null; then
    echo "Hotspotshield CLI could not be found. Make sure it's installed."
    exit
fi

locations_output=$(hotspotshield locations)
locations=""

while IFS= read -r line; do
    location=($line)

    if [ "$location" == "location" ] || [[ "$location" == "-"* ]]; then
        continue
    fi

    locations="$locations ${location@U}"
    locations="$locations ${location@L}"

done <<< "$locations_output"

echo $locations > "locations.txt"