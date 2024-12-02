#!/bin/bash

# Exit on any error and fail on pipes
set -e
set -o pipefail

# Define variables
NVM_VERSION="v0.39.1"
NODE_VERSION="23.3.0"
REPO_URL="https://github.com/ai16z/eliza.git"
CHARACTER_NAME="YOUR_CHARACTER"

apt install -y curl
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update && sudo apt install gum

# Function to prompt for user input using gum
prompt_input() {
    local var_name=$1
    local prompt_message=$2
    read -p "$(gum input --placeholder "$prompt_message")" $var_name
}

# Function to display status using gum
display_status() {
    local status_message=$1
    gum spin --spinner dot --title "$status_message" -- sleep 2
}

# Prompt for the custom character name
clear && CHARACTER_NAME=$(gum input --placeholder "Enter your custom character name (e.g., 'Eliza'): ")

# Update and upgrade system packages
clear && display_status "Updating and upgrading system packages..."
apt update && apt upgrade -y

# Ensure necessary packages are installed
clear && display_status "Installing necessary packages..."
apt install -y git curl python3 python3-pip make ffmpeg

# Install NVM
clear && display_status "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash

# Load NVM environment
clear && display_status "Loading NVM environment..."
export NVM_DIR="${XDG_CONFIG_HOME:-$HOME}/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Install Node.js and set alias
clear && display_status "Installing Node.js version ${NODE_VERSION}..."
nvm install "${NODE_VERSION}"
nvm alias eliza "${NODE_VERSION}"
nvm use eliza

# Install pnpm globally
clear && display_status "Installing pnpm..."
npm install -g pnpm

# Clone the repository
clear && display_status "Cloning the repository from ${REPO_URL}..."
git clone "${REPO_URL}" eliza
cd eliza

# Check out the latest tag
clear && display_status "Checking out the latest tag..."
LATEST_TAG=$(git describe --tags --abbrev=0)
git checkout "${LATEST_TAG}"

# Copy the example .env file to the active configuration file
clear && display_status "Copying the example .env file..."
cp ~/Eliza-Installer/eliza/.env.example ~/Eliza-Installer/eliza/.env

# Edit the .env file
clear && display_status "Editing .env file. Please make necessary changes."
cat ~/Eliza-Installer/eliza/.env.example | gum write --width=0 --placeholder="Create .env..." --char-limit=0 > ~/Eliza-Installer/eliza/.env

# Edit the custom character file
clear && display_status "Editing custom character file..."
cat ~/Eliza-Installer/eliza/characters/trump.character.json | gum write --width=0 --placeholder="Create Character..." --char-limit=0 > ~/Eliza-Installer/eliza/characters/"$CHARACTER_NAME".character.json

# Create character directory in agent folder
clear && display_status "Creating character directory in agent folder..."
mkdir -p ~/Eliza-Installer/eliza/agent/characters/

# Copy character into new character folder
clear && display_status "Copying character into the new character folder..."
cp ~/Eliza-Installer/eliza/characters/"$CHARACTER_NAME".character.json ~/Eliza-Installer/eliza/agent/characters/"$CHARACTER_NAME".character.json

# Load NVM environment again
clear && display_status "Loading NVM environment..."
export NVM_DIR="${XDG_CONFIG_HOME:-$HOME}/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Start the application
clear && display_status "Starting the application..."
sh scripts/start.sh

# Start Eliza with the custom character
clear && display_status "Starting Eliza with custom character..."
pnpm start --characters="characters/$CHARACTER_NAME.character.json"

gum style --foreground 2 "Eliza has been started with your custom character."
