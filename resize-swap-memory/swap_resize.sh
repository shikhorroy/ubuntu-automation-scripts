#!/bin/bash

# Require sudo/root privilege
if [[ $EUID -ne 0 ]]; then
    echo "⚠️ Please run as root (use sudo)"
    exit 1
fi

swapfile="/swapfile"

while true; do
    clear
    echo "===== Ubuntu Swap Memory Resize Script ====="
    echo ""

    read -p "Enter new Swap size (GB): " swap_gb

    # Validate numeric input
    if ! [[ "$swap_gb" =~ ^[0-9]+$ ]]; then
        echo "❌ Invalid input. Please enter a numeric value."
        sleep 2
        continue
    fi

    echo ""
    echo "----------------------------------------------"
    echo "You have requested to set SWAP size to: ${swap_gb} GB"
    echo "Existing swap will be removed and recreated."
    echo "----------------------------------------------"
    echo ""

    read -p "Do you want to proceed? (yes/no): " confirmation

    if [[ "$confirmation" == "yes" ]]; then
        break
    else
        echo "🔄 Restarting input..."
        sleep 1
    fi
done

# Start swap modification
swap_size_mb=$((swap_gb * 1024))

echo ""
echo "🚧 Disabling current swap..."
swapoff -a

if grep -q "$swapfile" /etc/fstab; then
    echo "🧹 Cleaning old fstab entry..."
    sed -i "\|$swapfile|d" /etc/fstab
fi

if [ -f "$swapfile" ]; then
    echo "🗑 Removing old swapfile..."
    rm -f "$swapfile"
fi

echo "📦 Creating ${swap_gb} GB swap file..."
fallocate -l ${swap_size_mb}M $swapfile

chmod 600 $swapfile
mkswap $swapfile
swapon $swapfile

echo "$swapfile none swap sw 0 0" >> /etc/fstab

echo ""
echo "✅ Swap updated successfully!"
echo ""
swapon --show
free -h

