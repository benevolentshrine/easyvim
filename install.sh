#!/bin/bash

# EasyVim Installer
# -----------------

echo -e "\033[1;34m=> Installing EasyVim...\033[0m"

# 1. Check for Neovim
if ! command -v nvim &> /dev/null; then
    echo -e "\033[1;31mError: Neovim is not installed.\033[0m"
    echo "Please install it first:"
    echo "  - MacOS: brew install neovim"
    echo "  - Linux: sudo apt install neovim (or use the AppImage)"
    exit 1
fi

DEST_DIR="$HOME/.config/nvim"
BACKUP_DIR="$HOME/.config/nvim.bak.$(date +%s)"

# 2. Backup existing config
if [[ -d "$DEST_DIR" ]]; then
    echo -e "\033[1;33m=> Backing up existing config to $BACKUP_DIR\033[0m"
    mv "$DEST_DIR" "$BACKUP_DIR"
fi

# 3. Install (Copy Files)
echo -e "\033[1;32m=> Installing EasyVim to $DEST_DIR\033[0m"
mkdir -p "$DEST_DIR"
cp -R . "$DEST_DIR"
rm -rf "$DEST_DIR/.git" "$DEST_DIR/install.sh" "$DEST_DIR/install.ps1"

echo -e "\n\033[1;32m=> Success! EasyVim is installed.\033[0m"
echo "You can now safely delete this download folder."
echo -e "Run \033[1m nvim \033[0m to start."
