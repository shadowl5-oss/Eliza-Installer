#!/bin/bash

# Exit on any error and fail on pipes
set -e
set -o pipefail

# Define variables
NVM_VERSION="v0.39.1"
NODE_VERSION="23.3.0"
REPO_URL="https://github.com/ai16z/eliza.git"
CHARACTER_NAME="YOUR_CHARACTER"

# Function to prompt for user input
prompt_input() {
    local var_name=$1
    local prompt_message=$2
    read -p "$prompt_message" $var_name
}

# Prompt for the custom character name
prompt_input CHARACTER_NAME "Enter your custom character name (e.g., 'Eliza'): "

# Update and upgrade system packages
echo "Updating and upgrading system packages..."
apt update && apt upgrade -y

# Ensure necessary packages are installed
echo "Installing necessary packages..."
apt install -y git curl python3 python3-pip make ffmpeg

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
echo "Cloning the repository from ${REPO_URL}..."
git clone "${REPO_URL}" eliza
cd eliza

# Check out the latest tag
echo "Checking out the latest tag..."
LATEST_TAG=$(git describe --tags --abbrev=0)
git checkout "${LATEST_TAG}"

# Copy the example .env file to the active configuration file
echo "Copying the example .env file..."
cp ~/eliza/.env.example ~/Eliza-Installer/eliza/.env

# Edit the .env file
echo "Editing .env file. Please make necessary changes."
nano ~/eliza/.env

# Edit the custom character file
echo "Editing custom character file..."
nano ~/eliza/characters/"$CHARACTER_NAME".character.json

# Create character directory in agent folder
echo "Creating character directory in agent folder..."
mkdir -p ~/eliza/agent/characters/

# Copy character into new character folder
echo "Copying character into the new character folder..."
cp ~/eliza/characters/"$CHARACTER_NAME".character.json ~/eliza/agent/characters/"$CHARACTER_NAME".character.json

# Load NVM environment again
echo "Loading NVM environment..."
export NVM_DIR="${XDG_CONFIG_HOME:-$HOME}/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Start the application
echo "Starting the application..."
sh scripts/start.sh

# Start Eliza with the custom character
echo "Starting Eliza with custom character..."
pnpm start --characters="characters/$CHARACTER_NAME.character.json"

echo "Eliza has been started with your custom character."

# End of the script
