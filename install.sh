#!/bin/bash

# ----------------------------------------------------
# This is simple script to install VIM configuration.
# ----------------------------------------------------
# AUTHOR: bosha
#   SITE: http://the-bosha.ru
# ----------------------------------------------------

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

if ! which git &> /dev/null ; then
    echo "GIT required, but not installed. Install it first."
    exit 1
fi

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

if [[ -d "/tmp/nvim-config" ]]; then
    rm -rf /tmp/nvim-config &> /dev/null
fi

cd /tmp
echo "Cloning Neovim configuration.."
git clone https://raw.githubusercontent.com/bosha/nvim-config/refs/heads/master/install.sh &> /dev/null

echo "Applying configuration"
mv nvim-config "$HOME"./config/nvim &> /dev/null

echo "Cleaning up.."
rm -rf /tmp/nvim-config &> /dev/null

echo "Neovim configuration successfully applied. Remember to update terminal font to the patched nerdfont version."
