#!/bin/bash

# EasyVim Installer
# -----------------

echo -e "\033[1;34m=> Installing EasyVim...\033[0m"

# 1. Require Neovim
if ! command -v nvim &> /dev/null; then
    echo -e "\033[1;31mError: Neovim is not installed.\033[0m"
    echo "Please install it first (v0.9+ recommended)."
    exit 1
fi

DEST_DIR="$HOME/.config/nvim"
BACKUP_DIR="$HOME/.config/nvim.bak.$(date +%s)"
CURRENT_DIR="$(pwd)"

# 2. Backup existing config
if [ -d "$DEST_DIR" ]; then
    echo -e "\033[1;33m=> Backing up existing config to $BACKUP_DIR\033[0m"
    mv "$DEST_DIR" "$BACKUP_DIR"
fi

# 3. Create Symlink
echo -e "\033[1;32m=> Linking EasyVim to $DEST_DIR\033[0m"
ln -s "$CURRENT_DIR" "$DEST_DIR"

echo -e "\n\033[1;32m=> Success! EasyVim is installed.\033[0m"
echo -e "Run \033[1m nvim \033[0m to start."
