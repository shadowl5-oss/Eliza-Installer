# Eliza Installer

A CLI tool to easily install and set up the [Eliza](https://github.com/elizaOS/eliza) chatbot in a persistent tmux session on Linux systems.

## Prerequisites

Before installation, ensure you have:

- **Linux/WSL**: A Debian-based Linux distribution or WSL2
- **Git**: For cloning the repository
- **Sudo privileges**: Required for installing system dependencies

The installer will automatically set up:
- Tmux (for persistent session)
- Node.js (v23.3.0)
- pnpm (v9.0.0 or higher)
- Python3, Make, FFmpeg, and other required dependencies

If using WSL2 on Windows:
1. Open PowerShell as Administrator and run:
   ```powershell
   wsl --install
   ```
2. Restart your computer if prompted
3. Open WSL and proceed with installation

## Installation

```bash
git clone https://github.com/HowieDuhzit/Eliza-Installer.git
cd Eliza-Installer
chmod +x setup.sh
./setup.sh
```

## What it Does

The installer will:
1. Create a persistent tmux session named 'eliza'
2. Check and install required system dependencies
3. Set up Node.js and pnpm if not present
4. Clone the Eliza repository
5. Set up the environment
6. Build and start the Eliza chatbot

## Usage

The chatbot runs in a persistent tmux session. Here are the basic commands:

- **Attach to Eliza session:**
  ```bash
  tmux attach -t eliza
  ```

- **Detach from session (keeps running):**
  Press `Ctrl+b` then `d`

- **View all sessions:**
  ```bash
  tmux ls
  ```

The chatbot will be available at `http://localhost:5173` in your web browser, even after you detach from the tmux session.

## Customization

- The `.env` file in the Eliza directory contains configuration options
- Character files are located in `eliza/characters/`
- To use a custom character:
  ```bash
  tmux attach -t eliza
  # Then in the tmux session:
  pnpm start --characters="characters/YOUR_CHARACTER.character.json"
  ```

## Troubleshooting

- If you see dependency errors, try:
  ```bash
  npm install -g pnpm
  pnpm install
  ```
- For WSL-specific issues, make sure you're using WSL2:
  ```powershell
  wsl --set-version Ubuntu 2
  ```
- If tmux session is not found:
  ```bash
  ./setup.sh  # This will create a new session
  ```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```

### Key Sections in the `README.md`:
- **Installation Instructions**: Clear, step-by-step guide for setting up the Eliza chatbot on a Debian-based WSL system.
- **Customizing the Character**: Describes how to edit the `.env` configuration file and customize the character's JSON file.
- **Starting the Chatbot**: A simple command to run the chatbot with a custom character.
- **Troubleshooting**: Provides information about potential issues and how to resolve them.
