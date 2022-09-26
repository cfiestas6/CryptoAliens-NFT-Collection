const { assert, expect } = require("chai");
const { ethers } = require("hardhat");
const { METADATA_URL, WHITELIST_CONTRACT_ADDRESS } = require("../../constants/index");

describe("CryptoAliens", () => {
    let cryptoAliensContract, cryptoAliens, deployer;
    beforeEach(async () => {
        accounts = await ethers.getSigners();
        deployer = accounts[0];
        cryptoAliensContract = await ethers.getContractFactory("CryptoAliens");
        cryptoAliens = await cryptoAliensContract.deploy(METADATA_URL, WHITELIST_CONTRACT_ADDRESS);
        await cryptoAliens.deployed();
    });
    describe("startPresale", () => {
        it("sets presaleStarted correctly", async () => {
            await cryptoAliens.startPresale();
            const presaleStarted = await cryptoAliens.s_presaleStarted();
            assert.equal(presaleStarted.toString(), "true");
        });
        it("sets the presaleEnded time correctly", async () =>{
            await cryptoAliens.startPresale();
            const presaleEnded = await cryptoAliens.s_presaleEnded();
            const timeStamp = (await ethers.provider.getBlock("latest")).timestamp;
            assert(presaleEnded > timeStamp);
        });
    });
    describe("presaleMint", () => {
        it("fails when the presale hasn't started", async () => {
            expect(cryptoAliens.presaleMint()).to.be.revertedWith("CryptoAliens__PresaleEnded");
        });
        it("fails when the msg.sender address is not whitelisted", async () => {
            await cryptoAliens.startPresale();
            expect(cryptoAliens.presaleMint()).to.be.revertedWith("CryptoAliens__NotWhitelisted")
        });
    });
    describe("mint", () => {
        it("fails when the presale hasn't ended", async () => {
            await cryptoAliens.startPresale();
            expect(cryptoAliens.mint()).to.be.revertedWith("CryptoAliens__PresaleNotEnded");
        });
    });
    describe("setPaused", () => {
        it("sets the value correctly", async () => {
            await cryptoAliens.setPaused(true);
            const paused = await cryptoAliens.s_paused();
            assert.equal(paused.toString(), "true");
        });
    });
});