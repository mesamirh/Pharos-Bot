@echo off
setlocal enabledelayedexpansion
title Pharos Bot - One Click Installer
color 0B

echo.
echo ████████████████████████████████████████████████████████████████████
echo █                                                                  █
echo █    ██████╗     ██╗  ██╗     █████╗     ██████╗      ██████╗      █
echo █    ██╔══██╗    ██║  ██║    ██╔══██╗    ██╔══██╗    ██╔═══██╗     █
echo █    ██████╔╝    ███████║    ███████║    ██████╔╝    ██║   ██║     █
echo █    ██╔═══╝     ██╔══██║    ██╔══██║    ██╔══██╗    ██║   ██║     █
echo █    ██║         ██║  ██║    ██║  ██║    ██║  ██║    ╚██████╔╝     █
echo █    ╚═╝         ╚═╝  ╚═╝    ╚═╝  ╚═╝    ╚═╝  ╚═╝     ╚═════╝      █
echo █                                                                  █
echo █       Pharos Testnet Bot - One Click Installer                  █
echo █                Created By Kazuha787                             █
echo █                                                                  █
echo ████████████████████████████████████████████████████████████████████
echo.

:: Check for Node.js
echo [INFO] Checking for Node.js...
node --version >nul 2>&1
if errorlevel 1 (
    echo [INFO] Node.js not found. Opening download page...
    echo.
    echo Please download and install Node.js from the page that will open.
    echo After installation, run this installer again.
    start https://nodejs.org/en/download/
    pause
    exit /b 1
) else (
    echo [SUCCESS] Node.js detected: 
    node --version
)

:: Install dependencies
echo.
echo [INFO] Installing bot dependencies...
npm install
if errorlevel 1 (
    echo [ERROR] Failed to install dependencies!
    pause
    exit /b 1
)

echo.
echo [SUCCESS] Installation complete!
echo.
echo [INFO] To run the bot:
echo   • Double-click 'run.bat'
echo   • Or run this installer again
echo.
echo [INFO] Configure your settings in:
echo   • wallet.json - Add your wallet private keys
echo   • config.yaml - Adjust bot settings  
echo   • proxy.txt - Add proxies (optional)
echo.

:: Ask if user wants to run now
set /p choice="Would you like to run the bot now? (y/n): "
if /i "%choice%"=="y" (
    call run.bat
)

pause