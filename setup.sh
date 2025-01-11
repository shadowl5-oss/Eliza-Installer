#!/bin/bash
set -e
set -o pipefail
NVM_VERSION="v0.39.1"
NODE_VERSION="23.3.0"
REPO_URL="https://github.com/elizaOS/eliza"
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'
NC='\033[0m'; BOLD='\033[1m'
log_error() { gum style --foreground 1 "❌ ${1}"; }
log_success() { gum style --foreground 2 "✅ ${1}"; }
log_info() { gum style --foreground 4 "ℹ️  ${1}"; }
handle_error() { log_error "Error occurred in: $1"; log_error "Exit code: $2"; exit 1; }
trap 'handle_error "${BASH_SOURCE[0]}:${LINENO}" $?' ERR

setup_tmux() {
    if ! command -v tmux &> /dev/null; then
        log_info "Installing tmux..."
        sudo apt install -y tmux
    fi

    # Create tmux config
    cat > ~/.tmux.conf << 'EOL'
# Set prefix to Ctrl-a
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Enable mouse control
set -g mouse on

# Start window numbering at 1
set -g base-index 1
setw -g pane-base-index 1

# Status bar styling
set -g status-style bg=black,fg=white
set -g status-left "#[fg=green]ELIZA #[fg=white]| "
set -g status-right "#[fg=cyan]%d %b %Y #[fg=white]| #[fg=cyan]%H:%M"
set -g status-justify centre

# Window styling
setw -g window-status-current-style bg=green,fg=black
setw -g window-status-style bg=black,fg=white

# Pane styling
set -g pane-border-style fg=green
set -g pane-active-border-style fg=cyan

# Set terminal to 256 colors
set -g default-terminal "screen-256color"
EOL
    log_success "Tmux configuration created"
}

start_tmux_session() {
    if ! tmux has-session -t eliza 2>/dev/null; then
        # Create new tmux session
        tmux new-session -d -s eliza -n "Eliza"
        
        # Split window for server and client
        tmux split-window -h
        
        # Select first pane and start server
        tmux select-pane -t 0
        tmux send-keys "cd eliza && pnpm start" C-m
        
        # Select second pane and start client
        tmux select-pane -t 1
        tmux send-keys "cd eliza && pnpm start:client" C-m
        
        # Create new window for monitoring
        tmux new-window -n "Monitor"
        tmux send-keys "cd eliza && htop" C-m
        
        # Select the first window
        tmux select-window -t 1
        
        log_success "Tmux session created"
    fi
}

install_gum() {
    if ! command -v gum &> /dev/null; then
        log_info "Installing gum for better UI..."
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
        echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
        sudo apt update && sudo apt install -y gum
    fi
}

show_welcome() {
    clear
    cat << "EOF"
Welcome to

 EEEEEE LL    IIII ZZZZZZZ  AAAA
 EE     LL     II      ZZ  AA  AA
 EEEE   LL     II    ZZZ   AAAAAA
 EE     LL     II   ZZ     AA  AA
 EEEEEE LLLLL IIII ZZZZZZZ AA  AA

Eliza is an open-source AI agent.
     Createdby ai16z 2024.
EOF
    echo
    gum style --border double --align center --width 50 --margin "1 2" --padding "1 2" \
        "Installation Setup" "" "This script will set up Eliza for you"
}

install_dependencies() {
    gum spin --spinner dot --title "Installing system dependencies..." -- \
        sudo apt update && sudo apt install -y git curl python3 python3-pip make ffmpeg htop
    log_success "Dependencies installed"
}

install_nvm() {
    if [ ! -d "$HOME/.nvm" ]; then
        gum spin --spinner dot --title "Installing NVM..." -- \
            curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        log_success "NVM installed"
    else
        log_info "NVM already installed"
    fi
}

setup_node() {
    gum spin --spinner dot --title "Setting up Node.js ${NODE_VERSION}..." -- \
        nvm install "${NODE_VERSION}" && nvm alias eliza "${NODE_VERSION}" && nvm use eliza
    gum spin --spinner dot --title "Installing pnpm..." -- npm install -g pnpm
    log_success "Node.js and pnpm setup complete"
}

clone_repository() {
    if [ ! -d "eliza" ]; then
        gum spin --spinner dot --title "Cloning Eliza repository..." -- git clone "${REPO_URL}" eliza
        cd eliza
        LATEST_TAG=$(git describe --tags --abbrev=0)
        git checkout "${LATEST_TAG}"
        log_success "Repository cloned and checked out to latest tag: ${LATEST_TAG}"
    else
        log_info "Eliza directory already exists"
        cd eliza
    fi
}

setup_environment() {
    [ ! -f .env ] && cp .env.example .env && log_success "Environment file created"
}

build_project() {
    gum spin --spinner dot --title "Installing project dependencies..." -- \
        pnpm clean && pnpm install --no-frozen-lockfile
    log_success "Dependencies installed"

    gum spin --spinner dot --title "Building project..." -- pnpm build
    log_success "Project built successfully"
}

main() {
    install_gum
    show_welcome
    
    if ! gum confirm "Ready to install Eliza?"; then
        log_info "Installation cancelled"
        exit 0
    fi

    install_dependencies
    setup_tmux
    install_nvm
    setup_node
    clone_repository
    setup_environment
    build_project
    start_tmux_session

    gum style --border double --align center --width 50 --margin "1 2" --padding "1 2" \
        "🎉 Installation Complete!" "" "Eliza is now running at:" "http://localhost:5173" "" \
        "To attach to the tmux session, run:" "tmux attach-session -t eliza" "" \
        "Use Ctrl-a + d to detach from the session"

    # Attach to the tmux session
    tmux attach-session -t eliza
}

main "$@"