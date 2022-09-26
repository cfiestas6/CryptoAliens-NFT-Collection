//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.17;

error Whitelist__AlreadyWhitelisted();
error Whitelist__LimitReached();

/**
 * @title Whitelist contract
 * @author 0xCarlosF
 * @notice This contract creates a whitelist of addresses for an nft collection
 * @dev 
 */

contract Whitelist {
    // Max number of whitelisted addresses
    uint8 public immutable i_maxWhitelistedAddresses;
    // Number of whitelisted addresses
    uint8 public s_numAddressesWhitelisted;

    // Mapping that checks whether an address is whitelisted or not
    mapping(address => bool) public whitelistedAddresses;

    constructor(uint8 _maxWhitelistedAddresses) {
        s_maxWhitelistedAddresses =  _maxWhitelistedAddresses;
    }

    /**
        This function adds the address of the sender to the
        whitelist
     */
    function addAddressToWhitelist() public {
        // check if the user has already been whitelisted
        if(whitelistedAddresses[msg.sender]){
            revert Whitelist__AlreadyWhitelisted();
        }
        // check if the numAddressesWhitelisted < maxWhitelistedAddresses, if not then throw an error.
        if(s_numAddressesWhitelisted > s_maxWhitelistedAddresses){
            revert Whitelist__LimitReached();
        }
        // Add the address which called the function to the whitelistedAddress array
        whitelistedAddresses[msg.sender] = true;
        // Increase the number of whitelisted addresses
        s_numAddressesWhitelisted += 1;
    }
    function getnumAddressesWhitelisted() public view returns (uint8) {
        return s_numAddressesWhitelisted;
    }
    function getMaxWhitelistedAddresses() public view returns (uint8) {
        return s_maxWhitelistedAddresses;
    }
}
