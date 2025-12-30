#!/usr/bin/env bash

# Enable verbose mode for debugging
set -vx

# Update package lists and install software properties common package
apt-get install -y software-properties-common

# Prepare Node.js 20.x installation
sudo apt-get install -y ca-certificates curl gnupg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

# Update package lists and upgrade installed packages
apt-get update
apt-get upgrade -y

# Install essential packages for Foundry and Python project development
apt-get install -y git python3 python3-pip python3-venv nodejs build-essential jq screen vim

# Install global npm packages
npm install -g npm@latest
npm install -g ganache@latest
npm install -g nodemon@latest

# Install Foundry
su - vagrant -c "curl -L https://foundry.paradigm.xyz | bash && export PATH=\"/home/vagrant/.foundry/bin:\$PATH\" && foundryup"

# Change hostname in /etc/hosts & /etc/hostname to "devVM"
oldHostname=$(cat /etc/hostname)
newHostname="devVM"
sed -i "s/$oldHostname/$newHostname/g" /etc/hosts
sed -i "s/$oldHostname/$newHostname/g" /etc/hostname

# Finish up by rebooting the system
reboot
