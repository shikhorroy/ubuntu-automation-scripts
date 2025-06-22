#!/bin/bash

# Dynamically detect current user HOME directory
BURP_DIR="$HOME/BurpSuiteCommunity"

# Validate directory
if [ ! -d "$BURP_DIR" ]; then
  echo "❌ BurpSuiteCommunity directory not found at $BURP_DIR"
  exit 1
fi

echo "🔎 Searching for chrome-sandbox under $BURP_DIR ..."

# Find and fix permission
find "$BURP_DIR" -type f -name "chrome-sandbox" | while read sandbox; do
    echo "🔧 Fixing permissions for: $sandbox"
    sudo chown root:root "$sandbox"
    sudo chmod 4755 "$sandbox"
done

echo "✅ Permission fixing completed successfully!"

