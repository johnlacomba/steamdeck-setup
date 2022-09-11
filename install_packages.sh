#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

apptoinstallList="vi glances gnu-netcat nmap giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader dosbox"
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
echo "Install wine-staging and winetricks, then all packages from \$apptoinstallList, then cups and samba"
echo "--------------------------------------" 
eval 'sudo pacman --noconfirm -S wine-staging winetricks'
eval 'sudo pacman --noconfirm -S ${apptoinstallList}'
echo "--------------------------------------"
echo "Note: Cups and Samba are installed with the pacman parameter '--overwrite'" 
echo "--------------------------------------" 
eval 'sudo pacman --noconfirm -S --overwrite "*" cups samba'

echo "--------------------------------------" 
echo "Download and install Lutris"
echo "--------------------------------------" 
wget -O lutris_install https://archlinux.org/packages/community/any/lutris/download
echo "sudo pacman -U lutris_install"
echo "--------------------------------------" 
echo "Cleaning up lutris_install file."
echo "--------------------------------------" 
rm ./lutris_install

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
