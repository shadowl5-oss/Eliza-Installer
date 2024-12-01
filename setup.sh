#!/bin/bash

set -e  # Exit on any error
set -o pipefail  # Catch errors in pipes

# Define variables
NVM_VERSION="v0.39.1"
NODE_VERSION="23.3.0"
REPO_URL="https://github.com/ai16z/eliza.git"

# Update and upgrade system packages
echo "Updating and upgrading system packages..."
sudo apt update && sudo apt upgrade -y

# Ensure curl is installed
echo "Installing curl if not already installed..."
sudo apt install -y curl

# Ensure git is installed
echo "Installing git if not already installed..."
sudo apt install -y git

# Ensure python3 is installed
echo "Installing Python3 if not already installed..."
sudo apt install -y python3 python3-pip

# Ensure make is installed
echo "Installing make if not already installed..."
sudo apt install -y make

# Ensure ffmpeg is installed
echo "Installing ffmpeg if not already installed..."
sudo apt install -y ffmpeg

# Install NVM
echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash

# Load NVM environment
echo "Loading NVM environment..."
export NVM_DIR="${XDG_CONFIG_HOME:-$HOME}/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Install Node.js and set alias
echo "Installing Node.js version ${NODE_VERSION}..."
nvm install "${NODE_VERSION}"
nvm alias eliza "${NODE_VERSION}"
nvm use eliza

# Install pnpm globally
echo "Installing pnpm..."
npm install -g pnpm

# Clone the repository
echo "Cloning the repository..."
git clone "${REPO_URL}" eliza
cd eliza

# Check out the latest tag
echo "Checking out the latest tag..."
LATEST_TAG=$(git describe --tags --abbrev=0)
git checkout "${LATEST_TAG}"

# Start the application
echo "Starting the application..."
sh scripts/start.sh
