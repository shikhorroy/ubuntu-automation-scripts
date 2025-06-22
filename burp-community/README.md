# Burp Suite Community Browser Launch Issue — Ubuntu 24.04 Fix

## 🐞 Problem Description

When using **Burp Suite Community Edition** on **Ubuntu 24.04 (or similar modern Linux distributions)**, the embedded
Chromium browser may fail to open when clicking on **"Open Browser"** button.
There is no visible error message, and the browser window does not appear.

### Root Cause

* Burp Suite embeds a Chromium browser for its built-in browser-based proxy.
* Chromium sandbox requires the binary `chrome-sandbox` to have special permissions to execute securely.
* By default, after installation, Burp Suite places the `chrome-sandbox` file under its internal folders *without*
  proper permissions.
* Modern Linux systems (Ubuntu 24.04, etc.) have tightened security and do not allow this file to function properly
  unless correctly permissioned.

## 🔎 How to Verify

1. Locate the BurpSuite `chrome-sandbox` binary:

```bash
find ~/BurpSuiteCommunity/ -type f -name "chrome-sandbox"
```

Example output:

```
/home/username/BurpSuiteCommunity/burpbrowser/137.0.7151.68/chrome-sandbox
```

2. Check its permissions:

```bash
ls -l /home/username/BurpSuiteCommunity/burpbrowser/137.0.7151.68/chrome-sandbox
```

You will usually find that it is not owned by `root` and does not have the necessary **SUID** bit set.

## 🛠 Solution

The `chrome-sandbox` binary must:

* Be owned by **root** (`chown root:root`)
* Have **SUID (Set User ID)** bit set (`chmod 4755`)

### Manual Fix:

```bash
sudo chown root:root /home/username/BurpSuiteCommunity/burpbrowser/137.0.7151.68/chrome-sandbox
sudo chmod 4755 /home/username/BurpSuiteCommunity/burpbrowser/137.0.7151.68/chrome-sandbox
```

## ⚠ Note on Security

* This fix is safe **only for trusted Burp Suite binaries**.
* Do not apply this permission fix to other Chromium-based apps (JetBrains, Postman, Electron apps, etc.) unless you
  fully understand their security model.

## 🚀 Automated Solution: Permission Fixer Script

To simplify the fix — a portable script is provided below which will safely locate and apply the necessary permissions *
*only inside BurpSuiteCommunity directory.**

### Script: `burp_permission_fixer.sh`

```bash
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
```

### Usage:

1. Make burp_permission_fixer.sh executable:

```bash
chmod +x burp_permission_fixer.sh
```

2. Run the script:

```bash
./burp_permission_fixer.sh
```

You will be prompted for your password when `sudo` executes.

## 🏷 Impact on Future Upgrades

* Each time Burp Suite updates its embedded browser version, a new subfolder with a new `chrome-sandbox` will be
  created.
* You can re-run this script after each Burp update to fix permissions automatically.

## ✅ Tested Environment

* Burp Suite Community Edition `2025.5.4`
* Ubuntu `24.04 LTS`
* Desktop Environment: GNOME (Wayland/X11 both tested)

---

**Author:** [Shikhor Kumer Roy](https://github.com/shikhorroy)
