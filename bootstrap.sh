#!/usr/bin/env bash

# Enable verbose mode for debugging
set vx

# Update package lists and install software properties common package
apt-get install -y software-properties-common

# Add Ethereum PPAs (Personal Package Archives) for Ethereum and Ethereum-dev
add-apt-repository -y ppa:ethereum/ethereum
add-apt-repository -y ppa:ethereum/ethereum-dev

# Prepare Node.js 18.x installation
# deprecated: curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y ca-certificates curl gnupg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=18
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

# Update package lists and upgrade installed packages
apt-get update
apt-get upgrade -y

# Install essential packages
apt-get install -y git python3 dstat ntp nodejs build-essential ethereum solc jq

# Reload NTP service to synchronize time
service ntp reload

# Install global npm packages for custom build config
npm install -g npm
npm install -g ganache@7.9
npm install -g nodemon@3.x

# Install Foundry using the recommended installation command for the vagrant user
su - vagrant -c "curl -L https://foundry.paradigm.xyz | bash"
# Execute the foundryup command to complete the installation for the vagrant user
su - vagrant -c "foundryup"

# Install PHP CLI for local Web server
apt-get install -y php-cli
# Install python3 related packages for SimpleHTTPServer
apt-get install -y python3-pip python3-dev libssl-dev

# Change hostname in /etc/hosts & /etc/hostname to "devVM"
oldHostname=$(cat /etc/hostname)
newHostname="devVM"
sed -i "s/$oldHostname/$newHostname/g" /etc/hosts
sed -i "s/$oldHostname/$newHostname/g" /etc/hostname

# Finish up by rebooting the system
reboot
