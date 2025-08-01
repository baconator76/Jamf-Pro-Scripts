#!/bin/bash

echo "Scanning for Mac App Store apps..."

app_dir="/Applications"
tempfile=$(mktemp)

find "$app_dir" -maxdepth 1 -name "*.app" | while read -r app; do
    plist="$app/Contents/Info.plist"
    if [[ -f "$plist" ]]; then
        # Check if the app has a MAS receipt
        if [[ -f "$app/Contents/_MASReceipt/receipt" ]]; then
            app_name=$(defaults read "$plist" CFBundleName 2>/dev/null || basename "$app" .app)
            dev_name=$(codesign -dvv "$app" 2>&1 | grep "Authority=" | head -1 | sed 's/^.*Authority=//')
            echo "$app_name — Developer: ${dev_name:-Unknown}" >> "$tempfile"
        fi
    fi
done

sort "$tempfile"
rm "$tempfile"
