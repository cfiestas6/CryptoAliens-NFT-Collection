const { ethers } = require("hardhat");

async function main() {
  
  const whitelistContract = await ethers.getContractFactory("Whitelist");
  // here we deploy the contract
  const deployedWhitelistContract = await whitelistContract.deploy(10);
  // 10 is the Maximum number of whitelisted addresses allowed

  // Wait for it to finish deploying
  await deployedWhitelistContract.deployed();

  // Print the address of the deployed contract
  console.log("Whitelist Contract Address:", deployedWhitelistContract.address);

  console.log("------------------------------------------------------------------");
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });