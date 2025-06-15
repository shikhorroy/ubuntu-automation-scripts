#!/bin/bash

set -e

echo "🔄 Updating package lists..."
sudo apt update

echo "⬇️ Installing ibus-avro..."
sudo apt install -y ibus-avro

echo "🔁 Restarting ibus..."
ibus restart

echo "🧠 Waiting for ibus to settle..."
sleep 2

echo "📝 Adding Avro Phonetic input source..."
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'ibus-avro')]"

echo "✅ Avro Phonetic installed and configured!"
echo "💡 Use Super+Space to switch input methods."

echo "🔁 You may need to logout/login or restart your system for full effect."

