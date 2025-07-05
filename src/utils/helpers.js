/**
 * src/utils/helpers.js - Helper functions
 */
const axios = require('axios');
const { HttpsProxyAgent } = require('https-proxy-agent');
const { SocksProxyAgent } = require('socks-proxy-agent');

/**
 * Sleep for a specified number of milliseconds
 */
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

/**
 * Parse proxy string into proxy configuration
 */
function parseProxy(proxyString) {
  if (!proxyString || typeof proxyString !== 'string') {
    return null;
  }

  try {
    // Handle different proxy formats
    // Format: protocol://username:password@host:port
    // Format: protocol://host:port
    // Format: host:port
    
    let url = proxyString.trim();
    
    // Add protocol if missing
    if (!url.includes('://')) {
      url = `http://${url}`;
    }
    
    const parsed = new URL(url);
    
    return {
      protocol: parsed.protocol.replace(':', ''),
      host: parsed.hostname,
      port: parseInt(parsed.port) || (parsed.protocol === 'https:' ? 443 : 80),
      username: parsed.username || undefined,
      password: parsed.password || undefined
    };
  } catch (error) {
    console.error(`Failed to parse proxy: ${proxyString}`, error);
    return null;
  }
}

/**
 * Create axios instance with proxy
 */
function createAxiosWithProxy(proxyString) {
  try {
    const axios = require('axios');
    const { HttpsProxyAgent } = require('https-proxy-agent');
    const { HttpProxyAgent } = require('http-proxy-agent');
    const { SocksProxyAgent } = require('socks-proxy-agent');
    
    const proxyConfig = parseProxy(proxyString);
    if (!proxyConfig) {
      return createAxiosWithoutProxy();
    }
    
    const proxyUrl = `${proxyConfig.protocol}://${proxyConfig.username && proxyConfig.password ? 
      `${proxyConfig.username}:${proxyConfig.password}@` : ''}${proxyConfig.host}:${proxyConfig.port}`;
    
    let agent;
    if (proxyConfig.protocol === 'https') {
      agent = new HttpsProxyAgent(proxyUrl);
    } else if (proxyConfig.protocol === 'socks5' || proxyConfig.protocol === 'socks') {
      agent = new SocksProxyAgent(proxyUrl);
    } else {
      agent = new HttpProxyAgent(proxyUrl);
    }
    
    const instance = axios.create({
      httpAgent: agent,
      httpsAgent: agent,
      timeout: 30000
    });

    // Add default headers
    instance.defaults.headers.common['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36';
    
    // Add request interceptor for logging
    instance.interceptors.request.use(config => {
      config.metadata = { startTime: new Date() };
      return config;
    });
    
    // Add response interceptor for error handling
    instance.interceptors.response.use(
      response => {
        const duration = new Date() - response.config.metadata.startTime;
        return response;
      },
      error => {
        const errorInfo = {
          url: error.config?.url || 'unknown url',
          method: error.config?.method || 'unknown method',
          status: error.response?.status,
          statusText: error.response?.statusText,
          data: error.response?.data,
          message: error.message
        };
        
        error.proxyInfo = {
          isProxyError: isProxyError(error.message),
          errorDetails: errorInfo
        };
        
        return Promise.reject(error);
      }
    );
    
    return instance;
  } catch (error) {
    throw new Error(`Failed to create axios instance with proxy: ${error.message}`);
  }
}

/**
 * Create axios instance without proxy
 */
function createAxiosWithoutProxy() {
  try {
    const axios = require('axios');
    const instance = axios.create({
      timeout: 30000
    });
    
    // Add default headers
    instance.defaults.headers.common['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36';
    
    // Add request interceptor for logging
    instance.interceptors.request.use(config => {
      config.metadata = { startTime: new Date() };
      return config;
    });
    
    // Add response interceptor for error handling
    instance.interceptors.response.use(
      response => {
        const duration = new Date() - response.config.metadata.startTime;
        return response;
      },
      error => {
        const errorInfo = {
          url: error.config?.url || 'unknown url',
          method: error.config?.method || 'unknown method',
          status: error.response?.status,
          statusText: error.response?.statusText,
          data: error.response?.data,
          message: error.message
        };
        
        error.proxyInfo = {
          isProxyError: isProxyError(error.message),
          errorDetails: errorInfo
        };
        
        return Promise.reject(error);
      }
    );
    
    return instance;
  } catch (error) {
    throw new Error(`Failed to create axios instance: ${error.message}`);
  }
}

/**
 * Check if error is proxy related
 */
function isProxyError(errorMessage) {
  if (!errorMessage || typeof errorMessage !== 'string') {
    return false;
  }
  
  const proxyErrorIndicators = [
    'ECONNRESET',
    'ETIMEDOUT', 
    'ECONNREFUSED',
    'ESOCKETTIMEDOUT',
    'socket hang up',
    'network error',
    'Network Error',
    'timeout',
    'read ECONNRESET',
    'Failed to fetch',
    'Unable to connect',
    'Proxy connection failed',
    '403 Forbidden',
    '429 Too Many Requests',
    'socket disconnected',
    'connection refused',
    'Proxy connection ended before receiving CONNECT response',
    'EPROTO',
    'tunneling socket could not be established',
    'tunneling socket',
    'ENOTFOUND',
    'getaddrinfo ENOTFOUND',
    'connect ETIMEDOUT',
    'socket timeout',
    'proxy'
  ];
  
  const lowerCaseError = errorMessage.toLowerCase();
  return proxyErrorIndicators.some(indicator => 
    lowerCaseError.includes(indicator.toLowerCase())
  );
}

/**
 * Retry function with exponential backoff
 */
async function retry(fn, maxAttempts = 3, delay = 1000, logger = console, walletIndex = '') {
  let lastError;
  
  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      return await fn();
    } catch (error) {
      lastError = error;
      
      if (attempt === maxAttempts) {
        break;
      }
      
      // Check if it's a proxy error for additional context
      const isProxyIssue = isProxyError(error.message);
      
      if (isProxyIssue && logger.warn) {
        logger.warn(`Proxy error detected: ${error.message}. Attempt ${attempt}/${maxAttempts}`, { walletIndex });
      }
      
      // Calculate delay with exponential backoff and add some randomness
      const jitter = Math.random() * 500; // Add up to 500ms of random jitter
      const waitTime = delay * Math.pow(1.5, attempt - 1) + jitter;
      
      if (logger && logger.warn) {
        logger.warn(`Attempt ${attempt}/${maxAttempts} failed. Retrying in ${Math.round(waitTime)}ms... Error: ${error.message}`, { walletIndex });
      }
      
      await sleep(waitTime);
    }
  }
  
  // All attempts failed
  if (logger && logger.error) {
    logger.error(`All ${maxAttempts} retry attempts failed. Last error: ${lastError.message}`, { walletIndex });
  }
  
  throw lastError;
}

/**
 * Generate random number between min and max (inclusive)
 */
function getRandomNumber(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

/**
 * Generate random amount in a given range
 */
function getRandomAmount(min, max, decimals = 4) {
  const amount = Math.random() * (max - min) + min;
  return parseFloat(amount.toFixed(decimals));
}

/**
 * Mask sensitive information like addresses and keys
 */
function maskSensitiveData(data, type = 'address') {
  if (!data || typeof data !== 'string') {
    return 'Unknown';
  }
  
  switch (type) {
    case 'address':
      return `${data.slice(0, 6)}${'*'.repeat(6)}${data.slice(-6)}`;
    case 'privateKey':
      return `${data.slice(0, 4)}${'*'.repeat(data.length - 8)}${data.slice(-4)}`;
    case 'proxy':
      return `${data.slice(0, 15)}...`;
    default:
      return data;
  }
}

/**
 * Format error message for logging
 */
function formatError(error) {
  if (!error) return 'Unknown error';
  
  if (typeof error === 'string') {
    return error;
  }
  
  if (error.response && error.response.data) {
    if (typeof error.response.data === 'string') {
      return error.response.data;
    }
    if (error.response.data.message) {
      return error.response.data.message;
    }
    if (error.response.data.msg) {
      return error.response.data.msg;
    }
  }
  
  return error.message || 'Unknown error';
}

/**
 * Validate Ethereum address
 */
function isValidAddress(address) {
  if (!address || typeof address !== 'string') {
    return false;
  }
  
  // Check if it starts with 0x and has the right length
  return /^0x[a-fA-F0-9]{40}$/.test(address);
}

/**
 * Validate private key
 */
function isValidPrivateKey(privateKey) {
  if (!privateKey || typeof privateKey !== 'string') {
    return false;
  }
  
  // Remove 0x prefix if present
  const cleanKey = privateKey.startsWith('0x') ? privateKey.slice(2) : privateKey;
  
  // Check if it's a 64 character hex string
  return /^[a-fA-F0-9]{64}$/.test(cleanKey);
}

module.exports = {
  sleep,
  parseProxy,
  createAxiosWithProxy,
  createAxiosWithoutProxy,
  isProxyError,
  retry,
  getRandomNumber,
  getRandomAmount,
  maskSensitiveData,
  formatError,
  isValidAddress,
  isValidPrivateKey
};
