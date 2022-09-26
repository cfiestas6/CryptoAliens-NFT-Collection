const { assert, expect } = require("chai");
const { ethers } = require("hardhat");

describe("Whitelist", () => {
    let whitelistContract, whitelist, deployer;
    beforeEach(async () => {
        accounts = await ethers.getSigners();
        deployer = accounts[0];
        whitelistContract = await ethers.getContractFactory("Whitelist");
        whitelist = await whitelistContract.deploy(10);
        await whitelist.deployed()
    });
    describe("Constructor", () => {
        it("initializes the max whitelisted addresses correctly", async () => {
            let maxWhitelistedAddresses = await whitelist.getMaxWhitelistedAddresses();
            assert.equal(maxWhitelistedAddresses, 10);
        });
    });
    describe("addAddresstoWhitelist", () => {
        it("reverts if already whitelisted", async () => {
            await whitelist.addAddressToWhitelist();
            expect(whitelist.addAddressToWhitelist()).to.be.revertedWith("Whitelist__AlreadyWhitelisted");
        });
        it("checks correctly when an address is whitelisted", async () => {
            await whitelist.connect(deployer);
            await whitelist.addAddressToWhitelist();
            const result = await whitelist.whitelistedAddresses(deployer.address);
            assert.equal(result.toString(), "true");
        });
        it("checks correctly when an address is not whitelisted", async () => {
            await whitelist.connect(accounts[3]);
            const result = await whitelist.whitelistedAddresses(accounts[3].address);
            assert.equal(result.toString(), "false");
        });
    });
});