#!/bin/bash

# Define color variables for output
PURPLE='\033[0;35m'
BLUE='\033[0;34m'
NORMAL='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to abort the script with a message
abort() {
    echo -e "${RED}[✘] $1${NORMAL}"
    exit 1
}

# Function for user confirmation
confirm() {
    read -r -p "$1 [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

# Function to install required packages based on the detected distribution
install_required_packages() {
    echo -e "${PURPLE}🖥️  Detecting package manager...${NORMAL}"
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command_exists apt; then
            echo -e "${BLUE}Ubuntu/Debian detected. Installing packages...${NORMAL}"
            sudo apt update -y || abort "Failed to update packages"
            sudo apt install -y fish unzip wget || abort "Package installation failed"

        elif command_exists dnf; then
            echo -e "${BLUE}Fedora detected. Installing packages...${NORMAL}"
            sudo dnf install -y fish unzip wget || abort "Package installation failed"

        elif command_exists pacman; then
            echo -e "${BLUE}Arch detected. Installing packages...${NORMAL}"
            sudo pacman -Syy --noconfirm || abort "Failed to sync repos"
            sudo pacman -S --needed --noconfirm fish unzip wget || abort "Package installation failed"

        else
            abort "No supported package manager found"
        fi

    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo -e "${BLUE}macOS detected. Checking for Homebrew...${NORMAL}"
        if ! command_exists brew; then
            abort "Homebrew required. Visit https://brew.sh"
        fi
        brew install fish unzip wget || abort "Brew installation failed"
    else
        abort "Unsupported OS: $OSTYPE"
    fi
}

# Function to install Fish shell
install_fish() {
    echo -e "${PURPLE}🐟  Setting up Fish shell...${NORMAL}"
    if command_exists fish; then
        echo -e "${GREEN}Fish already installed!${NORMAL}"
    else
        install_required_packages
        echo -e "${BLUE}Making Fish your default shell...${NORMAL}"
        fish_path=$(command -v fish)
        if ! sudo chsh -s "$fish_path" "$USER"; then
            echo -e "${YELLOW}Couldn't auto-change shell. Manually run: chsh -s $fish_path${NORMAL}"
        fi
    fi
}

# Function to install Oh My Posh
install_oh_my_posh() {
    echo -e "${PURPLE}🎨  Installing Oh My Posh...${NORMAL}"
    
    # Detect OS and architecture
    OMP_OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    OMP_ARCH=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')
    OMP_BIN="posh-${OMP_OS}-${OMP_ARCH}"
    OMP_URL="https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/$OMP_BIN"

    echo -e "${BLUE}Downloading oh-my-posh...${NORMAL}"
    sudo wget -q "$OMP_URL" -O /usr/local/bin/oh-my-posh || abort "Download failed"
    sudo chmod +x /usr/local/bin/oh-my-posh

    # Theme setup
    THEMES_DIR="$HOME/.poshthemes"
    mkdir -p "$THEMES_DIR"
    echo -e "${BLUE}Downloading themes...${NORMAL}"
    wget -q "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip" -O "$THEMES_DIR/themes.zip" || abort "Theme download failed"
    unzip -o -q "$THEMES_DIR/themes.zip" -d "$THEMES_DIR"
    rm "$THEMES_DIR/themes.zip"

    # Fish configuration
    CONFIG_DIR="$HOME/.config/fish"
    mkdir -p "$CONFIG_DIR"
    CONFIG_LINE="oh-my-posh init fish --config $THEMES_DIR/montys.omp.json | source"
    
    if ! grep -qxF "$CONFIG_LINE" "$CONFIG_DIR/config.fish" 2>/dev/null; then
        echo "$CONFIG_LINE" >> "$CONFIG_DIR/config.fish"
        echo -e "${GREEN}Added Oh My Posh to Fish config!${NORMAL}"
    else
        echo -e "${GREEN}Oh My Posh config already exists. Skipping...${NORMAL}"
    fi
}

# Function to install Nerd Fonts
install_nerd_fonts() {
    echo -e "${PURPLE}🔠  Installing FiraCode Nerd Font...${NORMAL}"
    
    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
    FONT_DIR=""
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        FONT_DIR="$HOME/Library/Fonts"
    else
        FONT_DIR="$HOME/.local/share/fonts"
    fi

    mkdir -p "$FONT_DIR"
    echo -e "${BLUE}Downloading fonts...${NORMAL}"
    wget -q "$FONT_URL" -O /tmp/firacode.zip || abort "Font download failed"
    unzip -o -q /tmp/firacode.zip -d "$FONT_DIR"
    rm /tmp/firacode.zip

    # Refresh font cache
    if command_exists fc-cache; then
        fc-cache -f -v
    fi
}

# Function to configure terminal
configure_terminal() {
    echo -e "${PURPLE}💻  Terminal customization tips:${NORMAL}"
    echo -e "${YELLOW}1. Set terminal font to 'FiraCode Nerd Font' (May need to restart terminal)${NORMAL}"
    echo -e "${YELLOW}2. For GNOME users: Run 'gsettings set org.gnome.desktop.interface font-name \"FiraCode Nerd Font 11\"'${NORMAL}"
}

# Function to install Base16 Shell
install_base16_shell() {
    echo -e "${PURPLE}🎨  Setting up Base16 Shell...${NORMAL}"
    BASE16_DIR="$HOME/.config/base16-shell"
    
    if [ ! -d "$BASE16_DIR" ]; then
        git clone https://github.com/chriskempson/base16-shell.git "$BASE16_DIR" || abort "Clone failed"
        echo -e "${GREEN}Base16 installed! Add 'base16_<theme>' to your config${NORMAL}"
    else
        echo -e "${GREEN}Base16 already exists. Updating...${NORMAL}"
        (cd "$BASE16_DIR" && git pull)
    fi
}

# Main execution
echo -e "${PURPLE}🚀 Starting terminal setup...${NORMAL}"
install_fish
install_oh_my_posh
install_nerd_fonts
configure_terminal
install_base16_shell

echo -e "\n${GREEN}✅ All done!${NORMAL}\n"

# Final recommendations
echo -e "Recommended next steps:"
echo -e "1. Restart your terminal"
echo -e "2. Run 'fish' to start using your new shell"
echo -e "3. Explore different Base16 themes with 'base16_<tab>'"

# Logout handling
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if confirm "${BLUE}💡  Logout required for shell changes. Logout now?${NORMAL}"; then
        echo -e "${BLUE}Logging out in 5s...${NORMAL}"
        sleep 5
        gnome-session-quit --logout --no-prompt 2>/dev/null || loginctl terminate-user "$USER" 2>/dev/null
    else
        echo -e "${YELLOW}Remember to logout later for changes to take effect!${NORMAL}"
    fi
fi
