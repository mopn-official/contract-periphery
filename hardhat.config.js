require("@nomicfoundation/hardhat-toolbox");
require("solidity-docgen");
const dotenv = require("dotenv");

dotenv.config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  networks: {
    localhost: {
      url: `http://127.0.0.1:7545`,
      chainId: 1337,
      accounts: ["39a3c68019306ff19c926041d34531d06e72ccc9fc63d32f3cdf1fd4e86587f3"],
    },
    mainnet: {
      url: process.env.MAINNET_URL,
      accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },

    goerli: {
      url: process.env.GOERLI_URL,
      accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    sepolia: {
      url: process.env.SEPOLIA_URL,
      accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    mumbai: {
      url: process.env.POLYGON_MUMBAI_URL,
      accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
    coinmarketcap: process.env.COINMARKETCAP_APIKEY,
  },
  etherscan: {
    apiKey: {
      mainnet: process.env.ETHERSCAN_API_KEY,
      sepolia: process.env.ETHERSCAN_API_KEY,
      goerli: process.env.ETHERSCAN_API_KEY,
      rinkeby: process.env.ETHERSCAN_API_KEY,
      polygonMumbai: process.env.POLYSCAN_API_KEY,
    },
  },
  docgen: {
    pages: "files",
  },
};
