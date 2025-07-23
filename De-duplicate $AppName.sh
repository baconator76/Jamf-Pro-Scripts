#!/bin/bash

#This script finds multilpe iterations of an application that's downloaded to a users downloads folder. This happens as a result of users downloading zip archive that unzips to the downloads folder, if done multiple times they may end up with a single app title like Flux.app, Flux 2.app, Flux 3.app, Flux 4.app

# Get the currently logged-in user
loggedInUser=$(stat -f "%Su" /dev/console)
downloadsDir="/Users/$loggedInUser/Downloads"

# Parameter 4: comma-separated list of app names (e.g., "App One,App Two,App Three")
appList="$4"

# Convert comma-separated string to array
IFS=',' read -ra appNames <<< "$appList"

# Loop through each app name
for app in "${appNames[@]}"; do
    # Trim leading/trailing whitespace
    app=$(echo "$app" | xargs)

    # Find and delete duplicates like "App Name 2.app", "App Name 3.app", etc.
    find "$downloadsDir" -type d -name "$app [0-9]*.app" | while read -r duplicate; do
        echo "Deleting duplicate: $duplicate"
        rm -rf "$duplicate"
    done
done