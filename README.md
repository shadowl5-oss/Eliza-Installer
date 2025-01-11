# Eliza Installer

A CLI tool to easily install and set up the [Eliza](https://github.com/elizaOS/eliza) chatbot on Linux systems.

## What it Does

The installer will:
1. Check and install required system dependencies
2. Set up Node.js and pnpm if not present
3. Clone the Eliza repository
4. Set up the environment
5. Build and start the Eliza chatbot

## Prerequisites

- **Linux/WSL**: Works on any Debian-based Linux distribution or WSL2
- **Node.js**: Version 23.0.0 or higher
- **pnpm**: Version 9.0.0 or higher

If using WSL2 on Windows, make sure you have it installed and set up:
1. Open PowerShell as Administrator and run:
   ```powershell
   wsl
   ```
2. Restart your computer if prompted


## Installation

```bash
git clone https://github.com/HowieDuhzit/Eliza-Installer.git
cd Eliza-Installer
chmod +x setup.sh
./setup.sh
```

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
