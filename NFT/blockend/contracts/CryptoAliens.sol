// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

error CryptoAliens__PresaleEnded();
error CryptoAliens__ContractPaused();
error CryptoAliens__NotWhitelisted();
error CryptoAliens__MaxSupplyReached();
error CryptoAliens__PresaleNotEnded();
error CryptoAliens__NotEnoughMatic();

/**
 * @title Crypto Aliens NFT contract
 * @author 0xCarlosF
 * @notice This contract creates a NFT Collection with presale option for the whitelisted addresses.
 * Only 10 NFTs can be minted either during the presale or after.
 * @dev This contract uses the interface IWhitelist.sol from the Crypto Aliens Whitelist contract.
 */

contract CryptoAliens is ERC721Enumerable, Ownable {
    using Strings for uint256;
    string s_baseTokenURI;
    //  _price is the price of one Crypto Dev NFT in matic as it will be deployed to mumbai testnet
    uint256 public immutable i_price = 0.1 ether; // Matic
    // _paused is used to pause the contract
    bool public s_paused;
    // max number of CryptoDevs
    uint256 public immutable i_maxTokenIds = 10;
    // total number of tokenIds minted
    uint256 public s_tokenIds;
    // Whitelist contract instance
    IWhitelist whitelist;
    // boolean to keep track of whether presale started or not
    bool public s_presaleStarted;
    // timestamp for when presale would end
    uint256 public s_presaleEnded;

    modifier onlyWhenNotPaused {
        if(s_paused){
            revert CryptoAliens__ContractPaused();
        }
        _;
    }

    constructor (string memory baseURI, address whitelistContract) ERC721("Crypto Aliens", "CA") {
        s_baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    /**
    * @dev startPresale starts a presale for the whitelisted addresses
      */
    function startPresale() public onlyOwner {
        s_presaleStarted = true;
        // Set presaleEnded time as current timestamp + 5 minutes
        s_presaleEnded = block.timestamp + 5 minutes;
    }

    /**
      * @dev presaleMint allows a user to mint one NFT per transaction during the presale.
      */
    function presaleMint() public payable onlyWhenNotPaused {
        if(!(s_presaleStarted && block.timestamp < s_presaleEnded)){
            revert CryptoAliens__PresaleEnded();
        }
        if(!whitelist.whitelistedAddresses(msg.sender)){
            revert CryptoAliens__NotWhitelisted();
        }
        if(s_tokenIds >= i_maxTokenIds){
            revert CryptoAliens__MaxSupplyReached();
        }
        if(msg.value < i_price){
            revert CryptoAliens__NotEnoughMatic();
        }
        s_tokenIds += 1;
        _safeMint(msg.sender, s_tokenIds);
    }

    /**
    * @dev mint allows a user to mint 1 NFT per transaction after the presale has ended.
    */
    function mint() public payable onlyWhenNotPaused {
        if(!(s_presaleStarted && block.timestamp >= s_presaleEnded)){
            revert CryptoAliens__PresaleNotEnded();
        }
        if(s_tokenIds >= i_maxTokenIds){
            revert CryptoAliens__MaxSupplyReached();
        }
        if(msg.value < i_price){
            revert CryptoAliens__NotEnoughMatic();
        }
        s_tokenIds += 1;
        _safeMint(msg.sender, s_tokenIds);
    }
    
    function _baseURI() internal view virtual override returns (string memory) {
        return s_baseTokenURI;
    }
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        // If baseURI is empty return an empty string
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
    }
    /**
    * @dev setPaused makes the contract paused or unpaused
    */
    function setPaused(bool val) public onlyOwner {
        s_paused = val;
    }

    /**
    * @dev withdraw sends all the ether in the contract
    * to the owner of the contract
    */
    function withdraw() public onlyOwner  {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) =  _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}