#!/bin/bash
set -x
apptoinstallList="vi glances"

# Disable file system being read only
sudo steamos-readonly disable
# Alternative method to disable the read only limit
#sudo btrfs property set -ts / ro false
# Initialize the pacman keyring
sudo pacman-key --init
# Populate the pacman keyring with default Arch Linux keys
sudo pacman-key --populate archlinux
# Install all packages from $apptoinstallList
eval 'sudo pacman --noconfirm -S ${apptoinstallList}' 
