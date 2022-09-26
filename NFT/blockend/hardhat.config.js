require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({ path: ".env" });
const { MUMBAI_ALCHEMY_API_URL, PRIVATE_KEY, POLYGONSCAN_KEY } = process.env;
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  solidity: "0.8.17",
  defaultNetwork: "mumbai",
  networks: {
    hardhat: {},
    mumbai: {
      url: MUMBAI_ALCHEMY_API_URL,
      accounts: [PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey:{
      polygonMumbai: POLYGONSCAN_KEY,
    },
    customChains: [
      {
        network: "mumbai",
        chainId: 80001,
        urls: {
          apiURL: "https://api-testnet.polygonscan.com/api",
          browserURL: "https://mumbai.polygonscan.com/"
        }
      }
    ]
  },
};