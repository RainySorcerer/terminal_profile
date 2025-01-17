
# Fish Shell Installation and Configuration Script

This guide will walk you through cloning and running the script from the [GitHub repository](https://github.com/RainySorcerer/terminal_profile) to install and configure Fish Shell, Oh My Posh, Nerd Fonts, and other tools on your system. Even if you are a beginner, just follow the steps carefully, and you'll be set up in no time.

---

## Features of the Script:
- Detects your Linux distribution (Ubuntu, Fedora, Arch, etc.).
- Installs Fish Shell and sets it as the default shell.
- Installs Oh My Posh for a modern terminal experience.
- Installs Nerd Fonts for improved visuals.
- Sets up a default theme for your terminal.
- Automatically logs you out to apply Fish as the default shell.

---

## Prerequisites
Make sure you have the following:
- An active internet connection.
- Basic understanding of running commands in a terminal.

---

## Steps to Run the Script

### 1. Clone the Repository
First, clone the script's repository to your system:
```bash
git clone https://github.com/RainySorcerer/terminal_profile.git
cd terminal_profile
```

### 2. Download and Run the Script Directly (Optional)
If you prefer, you can download the script using `wget` and run it directly:
```bash
wget -O terminal.sh https://raw.githubusercontent.com/RainySorcerer/terminal_profile/main/terminal.sh
chmod +x terminal.sh
./terminal.sh
```

### 3. Run the Script
After cloning or downloading, execute the script:
```bash
./terminal.sh
```

### 4. Follow the Prompts
The script will:
- Detect your Linux distribution.
- Install all required tools and themes.
- Log you out after completion.

Once the script finishes, log back into your session.

---

## What Happens After the Script Runs?
1. **Fish Shell:** You’ll be greeted by Fish Shell as your default terminal shell.
2. **Oh My Posh:** A beautiful prompt theme will be applied using Oh My Posh.
3. **Nerd Fonts:** The terminal will use Fira Code Nerd Font Retina for better visuals.
4. **Theme Applied:** Your terminal will have the Everforest Dark Hard color scheme as the default.

---

## Notes:
- If GNOME Terminal doesn’t immediately use Fish Shell as the default shell, logout and login again.
- The script handles logging out automatically.

---

## Troubleshooting
- **"Unsupported or unknown distribution" error:**
  Ensure your system is based on Ubuntu, Fedora, or Arch.

- **Permissions issues:**
  Ensure the script has executable permissions:
  ```bash
  chmod +x terminal.sh
  ```

- **Fish not loading by default:**
  Ensure you log out and log back in after the script runs.

---

## Uninstallation
To revert the changes made by this script, manually uninstall Fish Shell, Oh My Posh, and Nerd Fonts based on your package manager. For example:

### On Ubuntu:
```bash
sudo apt remove fish
sudo rm -rf ~/.poshthemes ~/.local/share/fonts
```

### On Fedora:
```bash
sudo dnf remove fish
sudo rm -rf ~/.poshthemes ~/.local/share/fonts
```

### On Arch:
```bash
sudo pacman -Rns fish
sudo rm -rf ~/.poshthemes ~/.local/share/fonts
```

---

Happy Shelling! 🎉
