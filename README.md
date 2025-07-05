# Pharos Auto Bot

[![Version](https://img.shields.io/badge/version-v1.0.0-blue)](https://github.com/Kazuha787/Pharos-Auto-Bot)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

**Pharos Auto Bot** is a robust, modular automation framework built in **Node.js** for interacting with the [Pharos Testnet](https://pharos.network). It handles day-to-day tasks like check-ins, faucet claims, social verifications, and on-chain operations with ease and precision.

Perfect for testers, point farmers, and developers who want to automate repetitive tasks securely and efficiently.

---

## 🚀 One-Click Setup & Run

### Windows Users
1. **Download** the bot files
2. **Double-click** `install.bat` to install dependencies
3. **Double-click** `run.bat` to start the bot
4. **Done!** ✅

### macOS/Linux Users
1. **Download** the bot files
2. **Double-click** `install.sh` to install dependencies (or run in terminal)
3. **Double-click** `run.sh` to start the bot (or run in terminal)
4. **Done!** ✅

### First-Time Setup
The installer will automatically:
- ✅ Check and install Node.js (if needed)
- ✅ Install all required dependencies
- ✅ Create configuration templates
- ✅ Set proper file permissions
- ✅ Launch the bot

---

## Features

- **Multi-Account Support**  
  Process unlimited accounts in parallel using `wallet.json`

- **Proxy Integration**  
  Optional proxy support via `proxy.txt` for IP rotation and privacy.

- **Modular Architecture**  
  Clearly separated services and utilities for clean, scalable code.

- **Task Automation**  
  
1. **Account Management**:
   - Logs into accounts.
   - Performs account check-ins.
   - Checks account status.

2. **Faucet Claims**:
   - Claims PHRS tokens from the faucet.
   - Claims USDC tokens from the faucet.

3. **Token Swaps**:
   - Swaps PHRS to USDC.
   - Swaps PHRS to USDT.

4. **Liquidity Provision**:
   - Adds liquidity to PHRS-USDC pool.
   - Adds liquidity to PHRS-USDT pool.

5. **Random Transfers**:
   - Executes random token transfers.

6. **Social Tasks**:
   - Performs social-related tasks.

7. **NFT Minting**:
   - Mints Gotchipus NFTs.

8. **OpenFi Operations**:
   - Executes OpenFi-related tasks.

9. **Pharos Deployment**:
   - Deploys Pharos contracts.

10. **Auto All**:
    - Runs all tasks automatically in a batch.

- **Multi-Threaded Execution**  
  Efficient task handling using asynchronous JavaScript threading.

- **Configurable Settings**  
  Modify task preferences, delays, threads, and API keys via `config.yaml`.

- **Cross-Platform Compatibility**  
  Supports Windows, macOS, and Linux (Termux-friendly too).

---

## 📁 File Structure

```bash
Pharos-Auto-Bot/
├── install.bat        # Windows one-click installer
├── install.sh         # macOS/Linux one-click installer  
├── run.bat            # Windows one-click runner
├── run.sh             # macOS/Linux one-click runner
├── main.js            # Main script with console UI
├── service.js         # Core logic for all tasks
├── src/               # Source code directory
│   ├── index.js       # Alternative main entry point
│   ├── config/        # Configuration modules
│   ├── services/      # Service modules
│   └── utils/         # Utility functions
├── chains/            # Blockchain configuration
├── wallet.json        # Wallet configuration
├── wallet.txt         # Main wallet address
├── config.yaml        # Bot configuration
├── proxy.txt          # Proxy list (optional)
├── package.json       # Node.js dependencies
└── README.md          # This file
```

## ⚙️ Requirements

The one-click installers will handle everything automatically, but for manual setup:

- [Node.js](https://nodejs.org/) v16+
- Git (optional, for cloning)
- A valid Pharos Testnet account → [pharos.network](https://pharos.network/)
- Optional: Proxy list for stealth mode

---

## 🧠 Manual Installation (Advanced Users)

```bash
# 1. Clone the repo
git clone https://github.com/Kazuha787/Pharos-Auto-Bot.git
cd Pharos-Auto-Bot

# 2. Install dependencies
npm install

# 3. Configure your settings
nano wallet.json  # Add your private keys
nano config.yaml  # Adjust bot settings
nano proxy.txt    # Add proxies (optional)

# 4. Run the bot
npm start
# or
node main.js
```

---

## 📊 Configuration

### wallet.json
```json
{
  "wallets": [
    {
      "name": "Wallet1",
      "privatekey": "your_private_key_here"
    },
    {
      "name": "Wallet2", 
      "privatekey": "another_private_key_here"
    }
  ]
}
```

### config.yaml
```yaml
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
```

### proxy.txt (Optional)
```
http://username:password@proxy1.example.com:8080
socks5://user:pass@proxy2.example.com:1080
proxy3.example.com:3128
```

---

## 🤝 Community Support

Need help, updates, or want to show off your setup?

Join the official Telegram group for support, discussion, and announcements:  
**[→ Telegram: @Offical_Im_kazuha](https://t.me/Offical_Im_kazuha)**

Whether you're facing issues, contributing improvements, or just vibing — everyone's welcome.

Have a feature request or found a bug?  
→ Open an [Issue](https://github.com/Kazuha787/Pharos-Auto-Bot/issues) or submit a [Pull Request](https://github.com/Kazuha787/Pharos-Auto-Bot/pulls).

---

## 🧾 License

This project is licensed under the **MIT License**.

You're free to use, modify, and distribute it as long as the original copyright and license
notice are included in copies or substantial portions of the software.

> See full license details in the [LICENSE](LICENSE) file.

---

## 🌱 Contributing

Contributions are **highly appreciated**!

If you'd like to contribute to **Pharos Auto Bot**, here's how:

1. **Fork** the repository
2. **Create a new branch**  
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes** and test thoroughly
4. **Commit your changes**
   ```bash
   git commit -m "Add: your feature description"
   ```
5. **Push to your branch**
   ```bash
   git push origin feature/your-feature-name
   ```
6. **Open a Pull Request**

---

## 🛡️ Security Notice

- Keep your private keys secure and never share them
- Use proxies for additional privacy
- Review all transactions before confirming
- This bot is for educational/testing purposes on testnets

---

**Happy Farming! 🚜💰**

*Created with ❤️ by [Kazuha787](https://github.com/Kazuha787)*
