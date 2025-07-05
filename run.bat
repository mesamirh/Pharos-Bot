@echo off
setlocal enabledelayedexpansion

:: Set console colors and title
title Pharos Bot - One Click Setup and Run
color 0A

echo.
echo ================================
echo    PHAROS BOT - AUTO SETUP
echo ================================
echo.

:: Check if Node.js is installed
node --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js is not installed!
    echo.
    echo Please install Node.js from: https://nodejs.org/
    echo After installation, run this script again.
    echo.
    pause
    exit /b 1
)

echo [INFO] Node.js detected: 
node --version

:: Check if we're in the correct directory
if not exist "package.json" (
    echo [ERROR] package.json not found!
    echo Please make sure you're running this script from the Pharos-Bot directory.
    pause
    exit /b 1
)

:: Install dependencies (force install to ensure all dependencies are present)
echo.
echo [INFO] Installing/updating dependencies...
echo This may take a few minutes...
npm install --force
if errorlevel 1 (
    echo [ERROR] Failed to install dependencies!
    echo Trying alternative installation method...
    npm ci
    if errorlevel 1 (
        echo [ERROR] All installation methods failed!
        pause
        exit /b 1
    )
)
echo [SUCCESS] Dependencies installed successfully!

:: Check for required files and create templates if missing
echo.
echo [INFO] Checking configuration files...

if not exist "pk.txt" (
    echo Creating pk.txt template...
    (
        echo # Add your private keys here, one per line
        echo # Private keys should be 64 hex characters ^(with or without 0x prefix^)
        echo # Examples:
        echo # 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef
        echo # 1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef
    ) > pk.txt
)

if not exist "proxy.txt" (
    echo Creating proxy.txt template...
    (
        echo # Add your proxies here, one per line ^(OPTIONAL^)
        echo # Format: protocol://username:password@host:port
        echo # Example: http://user:pass@proxy.example.com:8080
        echo # Or simply: host:port
        echo # Leave empty if you don't want to use proxies
    ) > proxy.txt
)

if not exist "config.yaml" (
    echo Creating config.yaml template...
    (
        echo # Pharos Bot Configuration
        echo general:
        echo   threads: 1
        echo   delay_between_accounts: 5000
        echo   retry_attempts: 3
        echo   retry_delay: 2000
        echo.
        echo tasks:
        echo   login: true
        echo   checkin: true
        echo   faucet:
        echo     native: true
        echo   social:
        echo     enabled: true
        echo     follow_x: true
        echo     retweet_x: true
        echo     comment_x: true
        echo     join_discord: true
        echo   onchain:
        echo     self_transfer:
        echo       enabled: true
        echo       max_count: 5
        echo       amount_range:
        echo         min: 0.001
        echo         max: 0.005
        echo.
        echo api:
        echo   pharos:
        echo     base_url: "https://api.pharosnetwork.xyz"
        echo   zenith:
        echo     rpc_url: "https://testnet.dplabs-internal.com"
    ) > config.yaml
)

:: Create wallet.json if it doesn't exist
if not exist "wallet.json" (
    echo Creating wallet.json template...
    (
        echo {
        echo   "wallets": [
        echo     {
        echo       "name": "Wallet1",
        echo       "privatekey": "0x0000000000000000000000000000000000000000000000000000000000000000"
        echo     }
        echo   ]
        echo }
    ) > wallet.json
)

:: Create wallet.txt if it doesn't exist
if not exist "wallet.txt" (
    echo Creating wallet.txt template...
    echo enter your address > wallet.txt
)

echo [SUCCESS] All configuration files checked/created!

:: Run the main script
echo.
echo ================================
echo     STARTING PHAROS BOT
echo ================================
echo.
echo [INFO] Launching Pharos Bot...
echo [INFO] Press Ctrl+C to stop the bot
echo.

:: Choose which script to run - prioritize main.js
if exist "main.js" (
    node main.js
) else if exist "src/index.js" (
    node src/index.js
) else if exist "index.js" (
    node index.js
) else (
    echo [ERROR] No main script found!
    echo Looking for: main.js, src/index.js, or index.js
    pause
    exit /b 1
)

echo.
echo [INFO] Bot has stopped.
pause