#!/bin/bash

### Description: Install and configure automatic updates

sudo apt update

sudo apt install unattended-upgrades

sudo dpkg-reconfigure -plow unattended-upgrades

sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

ubuntu_version=$(lsb_release -sr)

sudo tee /etc/apt/sources.list > /dev/null <<EOT
deb http://us.archive.ubuntu.com/ubuntu/$ubuntu_version main restricted
deb http://us.archive.ubuntu.com/ubuntu/$ubuntu_version-updates main restricted
deb http://us.archive.ubuntu.com/ubuntu/$ubuntu_version universe
deb http://us.archive.ubuntu.com/ubuntu/$ubuntu_version-updates universe
deb http://us.archive.ubuntu.com/ubuntu/$ubuntu_version multiverse
deb http://us.archive.ubuntu.com/ubuntu/$ubuntu_version-updates multiverse
deb http://us.archive.ubuntu.com/ubuntu/$ubuntu_version-backports main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu/$ubuntu_version-security main restricted
deb http://security.ubuntu.com/ubuntu/$ubuntu_version-security universe
deb http://security.ubuntu.com/ubuntu/$ubuntu_version-security multiverse
EOT

sources_dir="/etc/apt/sources.list.d"
for file in $sources_dir/*; do
    if [ -f "$file" ]; then
        echo "Found file: $file"
        read -p "Do you want to keep this file? (y/n): " choice
        if [ "$choice" != "y" ]; then
            sudo rm "$file"
            echo "File removed: $file"
        fi
    fi
done

sudo apt update
sudo apt upgrade -y