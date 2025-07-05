#!/bin/bash

# Set colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Clear screen and show banner
clear
echo ""
echo "================================"
echo "    PHAROS BOT - AUTO SETUP"
echo "================================"
echo ""

# Check if Node.js is installed
if ! command_exists node; then
    print_error "Node.js is not installed!"
    echo ""
    echo "Please install Node.js from: https://nodejs.org/"
    echo "Or use a package manager:"
    echo "  macOS: brew install node"
    echo "  Ubuntu/Debian: sudo apt install nodejs npm"
    echo "  CentOS/RHEL: sudo yum install nodejs npm"
    echo ""
    echo "After installation, run this script again."
    read -p "Press Enter to exit..."
    exit 1
fi

print_info "Node.js detected: $(node --version)"

# Check if npm is installed
if ! command_exists npm; then
    print_error "npm is not installed!"
    echo "Please install npm along with Node.js"
    read -p "Press Enter to exit..."
    exit 1
fi

print_info "npm detected: $(npm --version)"

# Check if we're in the correct directory
if [ ! -f "package.json" ]; then
    print_error "package.json not found!"
    print_error "Please make sure you're running this script from the Pharos-Bot directory."
    read -p "Press Enter to exit..."
    exit 1
fi

# Make script executable (for future runs)
chmod +x "$0"

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    echo ""
    print_info "Installing dependencies..."
    print_info "This may take a few minutes..."
    
    if npm install; then
        print_success "Dependencies installed successfully!"
    else
        print_error "Failed to install dependencies!"
        read -p "Press Enter to exit..."
        exit 1
    fi
else
    print_info "Dependencies already installed."
fi

# Check for required files and create templates if missing
echo ""
print_info "Checking configuration files..."

if [ ! -f "pk.txt" ]; then
    print_info "Creating pk.txt template..."
    cat > pk.txt << EOF
# Add your private keys here, one per line
# Example:
# 0x1234567890abcdef...
EOF
fi

if [ ! -f "proxy.txt" ]; then
    print_info "Creating proxy.txt template..."
    cat > proxy.txt << EOF
# Add your proxies here, one per line
# Format: protocol://username:password@host:port
# Example: http://user:pass@proxy.example.com:8080
# Or simply: host:port
EOF
fi

if [ ! -f "config.yaml" ]; then
    print_info "Creating config.yaml template..."
    cat > config.yaml << EOF
# Pharos Bot Configuration
general:
  threads: 1
  delay_between_accounts: 5000
  retry_attempts: 3
  retry_delay: 2000

tasks:
  login: true
  checkin: true
  faucet:
    native: true
  social:
    enabled: true
    follow_x: true
    retweet_x: true
    comment_x: true
    join_discord: true
  onchain:
    self_transfer:
      enabled: true
      max_count: 5
      amount_range:
        min: 0.001
        max: 0.005

api:
  pharos:
    base_url: "https://api.pharosnetwork.xyz"
EOF
fi

if [ ! -f "wallet.json" ]; then
    print_info "Creating wallet.json template..."
    cat > wallet.json << EOF
{
  "wallets": [
    {
      "name": "Wallet1",
      "privatekey": "your_private_key_here"
    }
  ]
}
EOF
fi

if [ ! -f "wallet.txt" ]; then
    print_info "Creating wallet.txt template..."
    echo "enter your address" > wallet.txt
fi

print_success "All configuration files checked/created!"

# Run the main script
echo ""
echo "================================"
echo "     STARTING PHAROS BOT"
echo "================================"
echo ""
print_info "Launching Pharos Bot..."
print_info "Press Ctrl+C to stop the bot"
echo ""

# Choose which script to run
if [ -f "src/index.js" ]; then
    node src/index.js
elif [ -f "index.js" ]; then
    node index.js
elif [ -f "main.js" ]; then
    node main.js
else
    print_error "No main script found!"
    print_error "Looking for: src/index.js, index.js, or main.js"
    read -p "Press Enter to exit..."
    exit 1
fi

echo ""
print_info "Bot has stopped."
read -p "Press Enter to exit..."