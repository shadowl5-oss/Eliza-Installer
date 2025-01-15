# Eliza Installer

> **Important Notice**: This installer has been [merged](https://github.com/elizaOS/eliza/commit/fd438db6ea42155ac08306c6bd86244618fa6df5) with the development branch of the main [Eliza repository](https://github.com/elizaOS/eliza). Once the changes are moved to the main branch, this repository will be maintained strictly for archival purposes.

A CLI tool to easily install and set up the [Eliza](https://github.com/elizaOS/eliza) chatbot on Linux systems.

## Prerequisites

Before installation, ensure you have:

- **Linux/WSL**: A Debian-based Linux distribution or WSL2
- **Git**: For cloning the repository
- **Sudo privileges**: Required for installing system dependencies

The installer will automatically set up:
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
1. Check and install required system dependencies
2. Set up Node.js and pnpm if not present
3. Clone the Eliza repository
4. Set up the environment
5. Build and start the Eliza chatbot

## Usage

After installation, you can start Eliza by running:
```bash
cd eliza
pnpm start
```

The chatbot will be available at `http://localhost:5173` in your web browser.

## Customization

- The `.env` file in the Eliza directory contains configuration options
- Character files are located in `eliza/characters/`
- To use a custom character:
  ```bash
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
