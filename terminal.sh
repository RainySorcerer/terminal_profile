#!/bin/bash

# Define color variables for output
PURPLE='\033[0;35m'
BLUE='\033[0;34m'
NORMAL='\033[0m'
RED='\033[0;31m'

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to abort the script with a message
abort() {
    echo -e "${RED}[ERROR] $1${NORMAL}"
    exit 1
}

# Function to install required packages based on the detected distribution
install_required_packages() {
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        if command_exists apt; then
            echo -e "${PURPLE}Ubuntu/Debian Based Distro Detected${NORMAL}"
            sudo apt update -y || abort "Failed to update package list!"
            echo -e "${BLUE}>> Installing Required Packages...${NORMAL}"
            sudo apt install -y fish unzip wget || abort "Failed to install required packages."

        elif command_exists dnf; then
            echo -e "${PURPLE}Fedora Based Distro Detected${NORMAL}"
            echo -e "${BLUE}>> Installing Required Packages...${NORMAL}"
            sudo dnf install -y fish unzip wget || abort "Failed to install required packages."

        elif command_exists pacman; then
            echo -e "${PURPLE}Arch or Arch Based Distro Detected${NORMAL}"
            sudo pacman -Syyu --needed --noconfirm || abort "Failed to update package list!"
            echo -e "${BLUE}>> Installing Required Packages...${NORMAL}"
            sudo pacman -Sy --noconfirm fish unzip wget || abort "Failed to install required packages."

        else
            abort "No supported package manager found."
        fi

    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo -e "${PURPLE}macOS Detected${NORMAL}"
        echo -e "${BLUE}>> Installing Required Packages...${NORMAL}"
        brew install fish unzip wget || abort "Failed to install required packages."
    else
        abort "Unsupported OS type: $OSTYPE"
    fi
}

# Function to install Fish shell
install_fish() {
    echo "Installing Fish shell..."
    if command_exists fish; then
        echo "Fish shell is already installed."
    else
        install_required_packages
        echo "Fish shell installed successfully! Changing the default shell..."
        chsh -s "$(command -v fish)"
    fi
}

# Function to install Oh My Posh
install_oh_my_posh() {
    echo "Installing Oh My Posh..."
    sudo wget -q https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
    sudo chmod +x /usr/local/bin/oh-my-posh

    echo "Setting up Oh My Posh themes..."
    mkdir -p "$HOME/.poshthemes"
    wget -q https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O "$HOME/.poshthemes/themes.zip"
    
    # Unzip without prompting for overwriting files
    unzip -o -q "$HOME/.poshthemes/themes.zip" -d "$HOME/.poshthemes"
    
    chmod u+rw "$HOME/.poshthemes"/*.json
    rm "$HOME/.poshthemes/themes.zip"

    echo "Configuring Fish shell to use Oh My Posh..."
    mkdir -p "$HOME/.config/fish"
    echo "oh-my-posh init fish --config $HOME/.poshthemes/montys.omp.json | source" >> "$HOME/.config/fish/config.fish"
    echo "Fish shell configured with Oh My Posh."
}

# Function to install Nerd Fonts (FiraCode)
install_nerd_fonts() {
    echo "Installing Nerd Fonts (FiraCode)..."
    mkdir -p "$HOME/.local/share/fonts"
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip -O "$HOME/Downloads/firacode.zip"
    unzip -o -q "$HOME/Downloads/firacode.zip" -d "$HOME/.local/share/fonts"
    fc-cache -f -v
    echo "Nerd Fonts (FiraCode) installed successfully!"
}

# Function to configure terminal font
configure_terminal_font() {
    echo " Configuring terminal to use FiraCode Nerd Font Retina size 11..."
    if command_exists gsettings; then
        PROFILE=$(gsettings get org.gnome.desktop.interface font-name)
        gsettings set org.gnome.desktop.interface font-name 'FiraCode Nerd Font Retina 11'
        echo "Terminal font configured successfully."
    else
        echo "gsettings command not found. Please configure the terminal font manually."
    fi
}

# Function to install Base16 Shell
install_base16_shell() {
    echo "Installing Base16 Shell..."
    if [ ! -d "$HOME/.config/base16-shell" ]; then
        git clone https://github.com/chriskempson/base16-shell.git "$HOME/.config/base16-shell" || abort "Failed to clone Base16 Shell repository."
        echo "Base16 Shell installed successfully!"
    else
        echo "Base16 Shell is already installed, skipping..."
    fi
}

# Main script execution
install_fish
install_oh_my_posh
install_nerd_fonts
configure_terminal_font
install_base16_shell

echo -e "${BLUE}All installations and configurations completed successfully!${NORMAL}"

# Logout automatically after completion
echo "Logging out in 5 seconds..."
sleep 5
gnome-session-quit --logout --no-prompt
