/**
 * src/utils/wallet.js - Wallet utilities
 */
const { ethers } = require('ethers');
const { loadConfig } = require('../config');

// Load configuration
const config = loadConfig();
const RPC_URL = config.api?.zenith?.rpc_url || "https://testnet.dplabs-internal.com";

/**
 * Validate private key format
 */
function validatePrivateKey(privateKey) {
  if (!privateKey || typeof privateKey !== 'string') {
    throw new Error('Private key must be a non-empty string');
  }
  
  // Remove whitespace
  privateKey = privateKey.trim();
  
  // Check if it's empty after trimming
  if (!privateKey) {
    throw new Error('Private key cannot be empty');
  }
  
  // Add 0x prefix if missing
  if (!privateKey.startsWith('0x')) {
    privateKey = '0x' + privateKey;
  }
  
  // Check length (should be 66 characters: 0x + 64 hex chars)
  if (privateKey.length !== 66) {
    throw new Error(`Invalid private key length: expected 66 characters, got ${privateKey.length}`);
  }
  
  // Check if it's valid hex
  if (!/^0x[a-fA-F0-9]{64}$/.test(privateKey)) {
    throw new Error('Private key must be a valid hexadecimal string');
  }
  
  return privateKey;
}

/**
 * Create a wallet instance from a private key
 */
function createWallet(privateKey) {
  try {
    // Validate the private key first
    const validatedPrivateKey = validatePrivateKey(privateKey);
    
    // Create provider with proper configuration
    const provider = new ethers.JsonRpcProvider(RPC_URL, {
      chainId: 688688,
      name: "pharos-testnet"
    });
    
    // Create wallet
    const wallet = new ethers.Wallet(validatedPrivateKey, provider);
    
    // Verify wallet was created successfully
    if (!wallet.address) {
      throw new Error('Failed to derive wallet address');
    }
    
    return wallet;
  } catch (error) {
    if (error.message.includes('invalid private key')) {
      throw new Error(`Invalid private key format: ${error.message}`);
    }
    if (error.message.includes('invalid bytes-like value')) {
      throw new Error('Private key contains invalid characters or format');
    }
    throw new Error(`Failed to create wallet: ${error.message}`);
  }
}

/**
 * Get wallet address
 */
function getWalletAddress(wallet) {
  if (!wallet || !wallet.address) {
    throw new Error('Invalid wallet object');
  }
  return wallet.address;
}

/**
 * Sign message with wallet
 */
async function signMessage(wallet, message) {
  try {
    if (!wallet || typeof wallet.signMessage !== 'function') {
      throw new Error('Invalid wallet object');
    }
    if (!message || typeof message !== 'string') {
      throw new Error('Message must be a non-empty string');
    }
    return await wallet.signMessage(message);
  } catch (error) {
    throw new Error(`Failed to sign message: ${error.message}`);
  }
}

/**
 * Get wallet balance
 */
async function getBalance(wallet) {
  try {
    if (!wallet || !wallet.provider) {
      throw new Error('Invalid wallet or provider');
    }
    const balance = await wallet.provider.getBalance(wallet.address);
    return ethers.formatEther(balance);
  } catch (error) {
    throw new Error(`Failed to get balance: ${error.message}`);
  }
}

/**
 * Validate and convert address to checksum format
 */
function toChecksumAddress(address) {
  try {
    if (!address || typeof address !== 'string') {
      throw new Error('Address must be a non-empty string');
    }
    return ethers.getAddress(address.trim());
  } catch (error) {
    throw new Error(`Invalid address format: ${address}`);
  }
}

/**
 * Validate Ethereum address
 */
function isValidAddress(address) {
  try {
    ethers.getAddress(address);
    return true;
  } catch {
    return false;
  }
}

/**
 * Validate private key (external function)
 */
function isValidPrivateKey(privateKey) {
  try {
    validatePrivateKey(privateKey);
    return true;
  } catch {
    return false;
  }
}

module.exports = {
  createWallet,
  getWalletAddress,
  signMessage,
  getBalance,
  toChecksumAddress,
  isValidAddress,
  isValidPrivateKey,
  validatePrivateKey
};
