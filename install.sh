#!/bin/bash

# ----------------------------------------------------
# Automatic installation of the neovim configuration
# ----------------------------------------------------
# AUTHOR: bosha
#   SITE: http://github.com/bosha/nvim-config
# ----------------------------------------------------

echo "Running the installation script for bosha/nvim-config neovim configuration"

promptyn () {
    if [ -z "$1" ]; then
        1="Confirm?"
    fi
    while true; do
        read -p "$1 (y/n): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            "" ) return 0;;
            * ) echo "Please answer yes or no (y/n).";;
        esac
    done
}

echo "Verifying that git is installed"
if ! which git &> /dev/null ; then
    echo "GIT required, but not installed. Install it first."
    exit 1
fi

echo "Verifying that configuration directory does not exists"
if [[ -d "$HOME"/.config/nvim ]]; then
    if promptyn "Directory "$HOME"/.config/nvim exists. Are you sure you want to continue?"; then
        if mv "$HOME"/.config/nvim "$HOME"/.config/nvim_old/ &> /dev/null ; then
            echo "Directory moved to $HOME/.config/nvim_old/"
        else
            echo "Something goes wrong while moving directory. Problem with permissions?"
            exit 1
        fi
    else
        exit
    fi
fi

echo "Creating directories"
mkdir -p ~/.config/nvim &> /dev/null

# cd /tmp
echo "Chaning directory to ~/.config/"
cd "$HOME"/.config/

echo "Cloning Neovim configuration.."
git clone git@github.com:bosha/nvim-config.git nvim &> /dev/null

echo "Neovim configuration successfully applied. Remember to update terminal font to the patched nerdfont version."
