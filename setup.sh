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
echo "\033[1mCleaning cache...\033[0m"
if ! pnpm clean; then
    echo "\033[1;31mFailed to clean cache.\033[0m"
    exit 1
fi
echo "\033[1mInstalling dependencies...\033[0m"
if ! pnpm install --no-frozen-lockfile; then
    echo "\033[1;31mFailed to install dependencies.\033[0m"
    exit 1
fi

# Build project
echo "\033[1mBuilding project...\033[0m"
if ! pnpm build; then
    echo "\033[1;31mFailed to build project.\033[0m"
    exit 1
fi

# Start project
echo "\033[1mStarting project...\033[0m"
if ! pnpm start; then
    echo "\033[1;31mFailed to start project.\033[0m"
    exit 1
fi

# Start client
echo "\033[1mStarting client...\033[0m"
if ! pnpm start:client; then
    echo "\033[1;31mFailed to start client.\033[0m"
    exit 1
fi

# Open webpage
echo "\033[1mOpening webpage at http://localhost:5173...\033[0m"
if command -v xdg-open >/dev/null 2>&1; then
    xdg-open "http://localhost:5173"
elif command -v open >/dev/null 2>&1; then
    open "http://localhost:5173"
else
    echo "\033[1;33mPlease open http://localhost:5173 in your browser.\033[0m"
fi