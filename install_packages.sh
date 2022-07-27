#!/bin/bash
apptoinstallList="vi glances"
piptoinstallList="requests beautifulsoup4"

echo "--------------------------------------" 
echo "Disabling the read-only lock on the file system."
echo "--------------------------------------" 
sudo steamos-readonly disable
# Alternative method to disable the read only limit
#sudo btrfs property set -ts / ro false

echo "--------------------------------------" 
echo "Initializing the pacman keyring."
echo "--------------------------------------" 
sudo pacman-key --init
echo "--------------------------------------" 
echo "Populate the pacman keyring with default Arch Linux keys"
echo "--------------------------------------" 
sudo pacman-key --populate archlinux

echo "--------------------------------------" 
echo "Install all packages from \$apptoinstallList"
echo "--------------------------------------" 
eval 'sudo pacman --noconfirm -S ${apptoinstallList}'

echo "--------------------------------------"
echo "Downloading and installing pip."
echo "--------------------------------------" 
curl -O https://bootstrap.pypa.io/get-pip.py
sudo -u deck python get-pip.py
echo "--------------------------------------" 
echo "Cleaning up pip setup script."
echo "--------------------------------------" 
rm get-pip.py

# If the pip directory has not been added to $PATH then add it
if [[ ! $(grep "append_path '/home/deck/.local/bin'" /etc/profile) ]]; then
  echo "--------------------------------------" 
  echo "Adding /home/deck/.local/bin to PATH in /etc/profile"
  echo "--------------------------------------" 
  sudo sed -i "/# Append our default paths/ a append_path '/home/deck/.local/bin'" /etc/profile
fi

echo "--------------------------------------"
echo "Installing pip packages from \$piptoinstallList"
echo "--------------------------------------"
eval 'sudo -u deck pip install --no-input ${piptoinstallList}'
