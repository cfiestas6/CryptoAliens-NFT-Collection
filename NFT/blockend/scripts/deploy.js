const { getNamedAccounts, deployments, network, run, ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
const { WHITELIST_CONTRACT_ADDRESS, METADATA_URL } = require("../constants/index");

async function main() {

  // Deploy the contract
  const cryptoAliensContract = await ethers.getContractFactory("CryptoAliens");
  const deployedCryptoAliensContract = await cryptoAliensContract.deploy(METADATA_URL, WHITELIST_CONTRACT_ADDRESS);
  
  await deployedCryptoAliensContract.deployed();

  // print the address of the deployed contract
  console.log(
    "Crypto Aliens Contract Address:",
    deployedCryptoAliensContract.address
  );
}


// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
