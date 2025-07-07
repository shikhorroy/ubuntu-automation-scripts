#!/bin/bash

set -e

# Function: Install zsh
install_zsh() {
    echo "[*] Installing zsh..."
    sudo apt update
    sudo apt install -y zsh
    echo "[+] zsh installed."
}

# Function: Setup Oh My Zsh + Powerlevel10k + Plugins + Nerd Font
setup_zsh() {
    echo ""
    echo "[STEP 1/6] Installing Oh My Zsh..."
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        echo "   ✔ Oh My Zsh installed!"
    else
        echo "   ✔ Oh My Zsh already installed."
    fi

    echo "[STEP 2/6] Installing Powerlevel10k theme..."
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
          ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
        echo "   ✔ Powerlevel10k installed!"
    else
        echo "   ✔ Powerlevel10k already installed."
    fi
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' $HOME/.zshrc

    echo "[STEP 3/6] Installing zsh-autosuggestions plugin..."
    PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    if [ ! -d "$PLUGIN_DIR/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGIN_DIR/zsh-autosuggestions"
        echo "   ✔ zsh-autosuggestions installed!"
    else
        echo "   ✔ zsh-autosuggestions already installed."
    fi

    echo "[STEP 4/6] Installing zsh-syntax-highlighting plugin..."
    if [ ! -d "$PLUGIN_DIR/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$PLUGIN_DIR/zsh-syntax-highlighting"
        echo "   ✔ zsh-syntax-highlighting installed!"
    else
        echo "   ✔ zsh-syntax-highlighting already installed."
    fi

	echo "[STEP 6/6] Downloading and installing MesloLGS NF Nerd Font..."
	FONT_DIR="$HOME/.local/share/fonts"
	MESLO_TEST_FILE="$FONT_DIR/MesloLGS NF Regular.ttf"

	if [ -f "$MESLO_TEST_FILE" ]; then
		echo "   ✔ MesloLGS NF font already exists. Skipping font download."
	else
		mkdir -p "$FONT_DIR"
		cd "$FONT_DIR"
		[ -f Meslo.zip ] && rm Meslo.zip
		wget --show-progress https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Meslo.zip
		unzip -o Meslo.zip -d meslo
		find meslo -name "*.ttf" -exec cp {} "$FONT_DIR" \;
		fc-cache -fv
		echo "   ✔ Font installed!"
	fi

    echo ""
    echo "🎉 [COMPLETE] Zsh, Oh My Zsh, Powerlevel10k, plugins, and font are all ready!"
    echo "👉 In your terminal settings, set the font to: MesloLGS NF."
    
    current_shell=$(basename "$SHELL")
    if [ "$current_shell" != "zsh" ]; then
        echo ""
        echo "[INFO] Zsh is installed and configured, but it's not your default shell."
        echo "Do you want to set Zsh as your default shell now? (y/N): "
        read answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
	    chsh -s $(which zsh)
	    echo "✔ Zsh set as your default shell. Please restart your terminal."
        else
	    echo "Skipped setting default shell. You can do it anytime from the main menu."
        fi
    fi
}

# Function: Switch default shell
switch_shell() {
    echo "Current default shell: $SHELL"
    echo "Which shell do you want as default?"
    select opt in "bash" "zsh" "Exit"; do
        case $opt in
            bash)
                chsh -s /bin/bash
                echo "[+] bash is now your default shell (restart terminal)."
                break
                ;;
            zsh)
                chsh -s $(which zsh)
                echo "[+] zsh is now your default shell (restart terminal)."
                break
                ;;
            Exit)
                break
                ;;
            *)
                echo "Invalid option";;
        esac
    done
}

# Function: Fully uninstall zsh + Oh My Zsh + plugins/themes
uninstall_zsh() {
    echo "Warning: This will remove zsh, Oh My Zsh, zsh config, and plugins."
    read -p "Are you sure? (y/N): " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        rm -rf ~/.oh-my-zsh ~/.zshrc ~/.p10k.zsh ~/.zprofile ~/.zsh_history ~/.zshenv ~/.zlogin
        sudo apt remove --purge -y zsh
        sudo apt autoremove -y
        echo "[+] zsh & related configs removed."
        chsh -s /bin/bash
        echo "[*] Switched to bash as default shell."
    else
        echo "Uninstall cancelled."
    fi
}

# Main menu
while true; do
    echo ""
    echo "====== Multi Shell Manager ======"
    echo "1. Install/Update zsh"
    echo "2. Setup/Update Oh My Zsh + Powerlevel10k + Plugins"
    echo "3. Switch Default Shell"
    echo "4. Uninstall zsh (full cleanup)"
    echo "5. Exit"
    echo "================================="
    read -p "Select an option [1-5]: " opt
    case $opt in
        1) install_zsh ;;
        2) setup_zsh ;;
        3) switch_shell ;;
        4) uninstall_zsh ;;
        5) exit 0 ;;
        *) echo "Invalid choice. Try again." ;;
    esac
done
