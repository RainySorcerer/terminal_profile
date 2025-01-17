#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect the Linux distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    elif command_exists lsb_release; then
        lsb_release -si | tr '[:upper:]' '[:lower:]'
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    elif [ -f /etc/redhat-release ]; then
        echo "fedora"
    elif [ -f /etc/arch-release ]; then
        echo "arch"
    else
        echo "unknown"
    fi
}

# Install Fish shell based on detected distribution
install_fish() {
    case "$1" in
        ubuntu|debian)
            echo "Ubuntu/Debian detected. Installing Fish shell..."
            sudo apt update && sudo apt install -y fish
            ;;
        fedora|centos|rhel)
            echo "Fedora/RHEL detected. Installing Fish shell..."
            sudo dnf install -y fish
            ;;
        arch)
            echo "Arch Linux detected. Installing Fish shell..."
            sudo pacman -Sy --noconfirm fish
            ;;
        *)
            echo "Unsupported or unknown distribution. Please install Fish manually."
            exit 1
            ;;
    esac

    if command_exists fish; then
        echo "Fish shell installed successfully!"
        echo "Changing the default shell to Fish..."
        chsh -s /usr/bin/fish
        echo "Switching to Fish shell..."
        fish
    else
        echo "Failed to install Fish shell. Please check your package manager and try again."
        exit 1
    fi
}

# Install Oh My Posh
install_oh_my_posh() {
    echo "Installing Oh My Posh..."
    sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
    sudo chmod +x /usr/local/bin/oh-my-posh
    echo "Oh My Posh installed successfully!"
}

# Install Nerd Fonts (FiraCode)
install_nerd_fonts() {
    echo "Installing Nerd Fonts (FiraCode)..."
    mkdir -p "$HOME/.local/share/fonts"
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip -O "$HOME/Downloads/firacode.zip"
    unzip "$HOME/Downloads/firacode.zip" -d "$HOME/.local/share/fonts"
    fc-cache -f -v
    echo "Nerd Fonts (FiraCode) installed successfully!"
}

# Main script execution
distro=$(detect_distro)
install_fish "$distro"
install_oh_my_posh
install_nerd_fonts
