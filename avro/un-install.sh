#!/bin/bash

set -e

echo "🗑️ Removing ibus-avro..."
sudo apt remove --purge ibus-avro -y

echo "🧹 Cleaning up Avro input source..."
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us')]"

echo "🔁 Restarting ibus..."
ibus restart

echo "✅ Avro successfully uninstalled."

