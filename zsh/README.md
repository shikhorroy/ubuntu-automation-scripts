# Multi Shell Manager for Ubuntu

A simple, interactive Bash script to automate **Zsh/Oh My Zsh** setup, theme, plugins, and font installation, as well as
shell switching and full cleanup on Ubuntu 24.04 (and similar Debian-based systems).

---

## Features

* Install or update **Zsh** shell
* Fully automate **Oh My Zsh** installation and setup
* Configure the **Powerlevel10k** prompt theme
* Auto-install useful plugins:

    * `zsh-autosuggestions`
    * `zsh-syntax-highlighting`
* Download and install **MesloLGS NF Nerd Font** (needed for icons in Powerlevel10k)
* Smartly skips font download if already present
* Easily switch default shell between `bash` and `zsh`
* Complete **uninstall** (remove zsh, Oh My Zsh, plugins, config, and reset to bash)
* Interactive main menu; user-friendly and idempotent

---

## Requirements

* Ubuntu 24.04 (or other Debian-based Linux)
* `curl`, `wget`, `git`, `unzip` (these are usually pre-installed)

---

## Installation & Usage

1. **Make it Executable**

   ```bash
   chmod +x multi-shell-manager.sh
   ```

2. **Run the Script**

   ```bash
   ./multi-shell-manager.sh
   ```

3. **Follow the On-Screen Menu**

* Install/update Zsh
* Setup Oh My Zsh, Powerlevel10k, plugins, and font
* Switch default shell (`bash`/`zsh`)
* Uninstall Zsh and all related config
* Exit

---

## Notes

* **Font:**
  After installation, set your terminal font to `MesloLGS NF` (Terminal → Preferences → Text → Custom Font).
* **Default Shell:**
  The script will prompt you to set Zsh as your default shell after setup, or you can do it anytime from the main menu.
* **No Double Installation:**
  If fonts or plugins are already present, the script skips unnecessary downloads.
* **Safe Uninstall:**
  The uninstall option will remove Zsh and all related configs, and reset your default shell to Bash.
* **Restart Required:**
  In rare cases, you may need to **restart your terminal** or **log out/in** (or reboot) for font and shell changes to
  take full effect.

---

## Troubleshooting

* **Fonts not showing as expected:**
  Ensure you selected `MesloLGS NF` font in your terminal settings and ran `fc-cache -fv`.
* **Prompt or plugins not working:**
  Open a new terminal, or run `zsh` and check for errors.
  You can always re-run the setup option.

---

## License

MIT License (or specify your license).

---

## Credits

* [Oh My Zsh](https://ohmyz.sh/)
* [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
* [Nerd Fonts](https://www.nerdfonts.com/)
* [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
* [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

---

**Happy customizing your Ubuntu terminal!**
