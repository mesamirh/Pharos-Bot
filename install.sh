#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

print_banner() {
    clear
    echo -e "${PURPLE}"
    echo "██████╗     ██╗  ██╗     █████╗     ██████╗      ██████╗     ███████╗"
    echo "██╔══██╗    ██║  ██║    ██╔══██╗    ██╔══██╗    ██╔═══██╗    ██╔════╝"
    echo "██████╔╝    ███████║    ███████║    ██████╔╝    ██║   ██║    ███████╗"
    echo "██╔═══╝     ██╔══██║    ██╔══██║    ██╔══██╗    ██║   ██║    ╚════██║"
    echo "██║         ██║  ██║    ██║  ██║    ██║  ██║    ╚██████╔╝    ███████║"
    echo "╚═╝         ╚═╝  ╚═╝    ╚═╝  ╚═╝    ╚═╝  ╚═╝     ╚═════╝     ╚══════╝"
    echo -e "${NC}"
    echo ""
    echo -e "${GREEN}       Pharos Testnet Bot - One Click Installer       ${NC}"
    echo -e "${BLUE}                Created By Kazuha787                   ${NC}"
    echo ""
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_banner

# Check OS
OS="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    OS="windows"
fi

print_info "Detected OS: $OS"

# Install Node.js if not present
if ! command -v node &> /dev/null; then
    print_info "Node.js not found. Installing..."
    
    case $OS in
        "macos")
            if command -v brew &> /dev/null; then
                brew install node
            else
                print_error "Homebrew not found. Please install Node.js manually from https://nodejs.org/"
                exit 1
            fi
            ;;
        "linux")
            if command -v apt &> /dev/null; then
                sudo apt update && sudo apt install -y nodejs npm
            elif command -v yum &> /dev/null; then
                sudo yum install -y nodejs npm
            elif command -v pacman &> /dev/null; then
                sudo pacman -S nodejs npm
            else
                print_error "Package manager not found. Please install Node.js manually."
                exit 1
            fi
            ;;
        *)
            print_error "Please install Node.js manually from https://nodejs.org/"
            exit 1
            ;;
    esac
else
    print_success "Node.js already installed: $(node --version)"
fi

# Install dependencies
print_info "Installing bot dependencies..."
npm install

# Set permissions
chmod +x run.sh
chmod +x install.sh

print_success "Installation complete!"
echo ""
print_info "To run the bot:"
echo "  • Double-click 'run.sh' (macOS/Linux)"
echo "  • Double-click 'run.bat' (Windows)"
echo "  • Or run: ./run.sh"
echo ""
print_info "Configure your settings in:"
echo "  • wallet.json - Add your wallet private keys"
echo "  • config.yaml - Adjust bot settings"
echo "  • proxy.txt - Add proxies (optional)"
echo ""