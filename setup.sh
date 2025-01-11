#!/bin/bash
set -e
set -o pipefail
NVM_VERSION="v0.39.1"
NODE_VERSION="23.3.0"
REPO_URL="https://github.com/elizaOS/eliza"
CHARACTER_NAME="YOUR_CHARACTER"
apt install -y curl gnupg2
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update && sudo apt install gum
prompt_input() {
    local var_name=$1
    local prompt_message=$2
    read -p "$(gum input --placeholder "$prompt_message")" $var_name
}
display_status() {
    local status_message=$1
    gum spin --spinner dot --title "$status_message" -- sleep 2
}
clear && display_status "Updating and upgrading system packages..."
apt update && apt upgrade -y
clear && display_status "Installing necessary packages..."
apt install -y git curl python3 python3-pip make ffmpeg
clear && display_status "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash
clear && display_status "Loading NVM environment..."
export NVM_DIR="${XDG_CONFIG_HOME:-$HOME}/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
clear && display_status "Installing Node.js version ${NODE_VERSION}..."
nvm install "${NODE_VERSION}"
nvm alias eliza "${NODE_VERSION}"
nvm use eliza
clear && display_status "Installing pnpm..."
npm install -g pnpm
clear && display_status "Cloning the repository from ${REPO_URL}..."
git clone "${REPO_URL}" eliza
cd eliza
clear && display_status "Checking out the latest tag..."
LATEST_TAG=$(git describe --tags --abbrev=0)
git checkout "${LATEST_TAG}"
clear && display_status "Copying the example .env file..."
cp ~/Eliza-Installer/eliza/.env.example ~/Eliza-Installer/eliza/.env
#clear && display_status "Loading NVM environment..."
#export NVM_DIR="${XDG_CONFIG_HOME:-$HOME}/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
clear && display_status "Starting Eliza..."
sh scripts/start.sh