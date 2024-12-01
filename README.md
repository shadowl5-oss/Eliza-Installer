# [Eliza](https://github.com/ai16z/eliza) Chatbot Setup Guide

This guide will walk you through the installation and setup of the Eliza chatbot on a Debian-based WSL (Windows Subsystem for Linux) system.

## Prerequisites

- **WSL (Windows Subsystem for Linux)** installed on your Windows machine.
- **Debian** distribution for WSL.

## Installation Steps

1. **Open Command Prompt** and install Debian on WSL by running the following command:
   ```bash
   wsl --install debian
   ```

2. **Once the installation is complete and Debian boots up, become the root user**:
   ```bash
   sudo su
   ```

3. **Install Git**:
   ```bash
   sudo apt install -y git
   ```

4. **Navigate to your home directory**:
   ```bash
   cd ~
   ```

5. **Clone the Eliza-Installer repository** from GitHub:
   ```bash
   git clone https://github.com/HowieDuhzit/Eliza-Installer.git
   ```

6. **Navigate into the cloned directory**:
   ```bash
   cd Eliza-Installer
   ```

7. **Make the `setup.sh` script executable**:
   ```bash
   chmod +x setup.sh
   ```

8. **Run the setup script** to install the Eliza chatbot:
   ```bash
   ./setup.sh
   ```

   This will install all necessary dependencies and configure the default Eliza character.

9. **Exit the bot**:
   ```bash
   exit
   ```

10. **Copy the example `.env` file to the active configuration file**:
   ```bash
   cp ~/Eliza-Installer/eliza/.env.example ~/Eliza-Installer/eliza/.env
   ```

11. **Edit the `.env` configuration file** using `nano` or your preferred text editor:
    ```bash
    nano ~/Eliza-Installer/eliza/.env
    ```
    Make the necessary changes to suit your environment.

12. **Edit your custom character** using `nano` or your preferred text editor (Change YOUR_CHARACTER to the name you want):
    ```bash
    nano ~/Eliza-Installer/eliza/characters/YOUR_CHARACTER.character.json
    ```
    Customize the character according to your preferences.

13. **Load NVM environment**:
     ```bash
    echo "Loading NVM environment..."
    export NVM_DIR="${XDG_CONFIG_HOME:-$HOME}/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    ```

14. **Navigate into the Eliza directory**:
    ```bash
    cd eliza
    ```

15. **Start Eliza with your custom character**:
    ```bash
    pnpm start --characters="~/Eliza-Installer/eliza/characters/YOUR_CHARACTER.character.json"
    ```

    This will start the Eliza chatbot using your customized character.

## Additional Notes

- If you need to make further customizations, you can modify the `.env` file and the individual character JSON files located in `~/Eliza-Installer/eliza/characters/`.
- To stop the Eliza chatbot, press `Ctrl+C` in the terminal.

## Troubleshooting

- If you encounter issues with `pnpm`, make sure all dependencies are installed correctly. You can install `pnpm` globally by running:
  ```bash
  npm install -g pnpm
  ```

## Contributing

Feel free to contribute to this project by opening issues or submitting pull requests to improve the Eliza chatbot or this installation guide.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```

### Key Sections in the `README.md`:
- **Installation Instructions**: Clear, step-by-step guide for setting up the Eliza chatbot on a Debian-based WSL system.
- **Customizing the Character**: Describes how to edit the `.env` configuration file and customize the character's JSON file.
- **Starting the Chatbot**: A simple command to run the chatbot with a custom character.
- **Troubleshooting**: Provides information about potential issues and how to resolve them.
