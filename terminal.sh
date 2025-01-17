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

# Main script execution
distro=$(detect_distro)
install_fish "$distro"
