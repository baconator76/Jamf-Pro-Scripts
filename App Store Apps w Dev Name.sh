#!/bin/bash

echo "Fetching list of Mac App Store apps with developer names..."

# Get list of all apps installed via the Mac App Store
mas list | while read -r line; do
    app_id=$(echo "$line" | awk '{print $1}')
    app_name=$(echo "$line" | cut -d' ' -f2- | sed -E 's/ \([0-9.]+\)$//')

    # Use the App Store metadata to get developer name
    app_info=$(mas info "$app_id" 2>/dev/null)
    developer=$(echo "$app_info" | grep "By " | sed -E 's/^.*By (.+)$/\1/')

    if [[ -n "$developer" ]]; then
        echo "$app_name — Developer: $developer"
    else
        echo "$app_name — Developer: Unknown"
    fi
done
