#!/usr/bin/env node

const { execSync } = require('child_process');
const { join } = require('path');
const fs = require('fs');
const os = require('os');

const COLORS = {
    red: '\x1b[31m',
    green: '\x1b[32m',
    yellow: '\x1b[33m',
    blue: '\x1b[34m',
    reset: '\x1b[0m'
};

const CONFIG = {
    nodeVersion: '23.3.0',
    repoUrl: 'https://github.com/elizaOS/eliza'
};

const showWelcome = () => {
    console.clear();
    console.log(`
Welcome to
EEEEEE LL   IIII ZZZZZZ AAAAA
EE     LL    II     ZZ  AA  AA
EEEE   LL    II   ZZZ   AAAAAA
EE     LL    II   ZZ    AA  AA
EEEEEE LLLLL IIII ZZZZZZ AA  AA

Eliza is a mock Rogerian psychotherapist.
The original program was described by Joseph Weizenbaum in 1966.
This implementation by Norbert Landsteiner 2005.
    `);
};

const exec = (command, options = {}) => {
    try {
        return execSync(command, { stdio: 'inherit', ...options });
    } catch (error) {
        console.error(`${COLORS.red}Error executing command: ${command}${COLORS.reset}`);
        throw error;
    }
};

const log = {
    info: (msg) => console.log(`${COLORS.blue}ℹ️  ${msg}${COLORS.reset}`),
    success: (msg) => console.log(`${COLORS.green}✅ ${msg}${COLORS.reset}`),
    error: (msg) => console.log(`${COLORS.red}❌ ${msg}${COLORS.reset}`),
};

const checkDependencies = () => {
    const deps = ['git', 'curl', 'python3', 'make', 'ffmpeg'];
    const missing = deps.filter(dep => {
        try {
            execSync(`which ${dep}`, { stdio: 'ignore' });
            return false;
        } catch {
            return true;
        }
    });

    if (missing.length) {
        log.error(`Missing required dependencies: ${missing.join(', ')}`);
        if (os.platform() === 'linux') {
            log.info('Installing missing dependencies...');
            exec('sudo apt update && sudo apt install -y ' + missing.join(' '));
        } else {
            throw new Error('Please install missing dependencies manually.');
        }
    }
};

const cloneRepository = () => {
    if (!fs.existsSync('eliza')) {
        log.info('Cloning Eliza repository...');
        exec(`git clone ${CONFIG.repoUrl} eliza`);
        process.chdir('eliza');
        const latestTag = execSync('git describe --tags --abbrev=0').toString().trim();
        exec(`git checkout ${latestTag}`);
        log.success(`Repository cloned and checked out to latest tag: ${latestTag}`);
    } else {
        log.info('Eliza directory already exists');
        process.chdir('eliza');
    }
};

const setupEnvironment = () => {
    if (!fs.existsSync('.env')) {
        fs.copyFileSync('.env.example', '.env');
        log.success('Environment file created');
    }
};

const buildAndStart = async () => {
    log.info('Installing project dependencies...');
    exec('pnpm clean && pnpm install --no-frozen-lockfile');

    log.info('Building project...');
    exec('pnpm build');

    log.info('Starting Eliza services...');
    exec('pnpm start & pnpm start:client &');

    // Wait for services to start
    await new Promise(resolve => setTimeout(resolve, 5000));

    const url = 'http://localhost:5173';
    if (os.platform() === 'darwin') {
        exec(`open ${url}`);
    } else if (os.platform() === 'linux') {
        exec(`xdg-open ${url}`);
    } else {
        log.info(`Please open ${url} in your browser`);
    }
};

const main = async () => {
    try {
        showWelcome();
        
        log.info('Checking system requirements...');
        checkDependencies();
        
        cloneRepository();
        setupEnvironment();
        await buildAndStart();

        log.success(`
╔════════════════════════════════════════╗
║         Installation Complete!         ║
║                                       ║
║    Eliza is now running at:           ║
║    http://localhost:5173              ║
╚════════════════════════════════════════╝`);
    } catch (error) {
        log.error('Installation failed!');
        log.error(error.message);
        process.exit(1);
    }
};

main(); 