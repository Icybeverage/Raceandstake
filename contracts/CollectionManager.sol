// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NFT.sol";

contract CollectionManager {
    struct Collection {
        string name;
        string symbol;
        address contractAddress;
    }

    Collection[] public collections;
    mapping(string => address) public nameToAddress;

    event CollectionCreated(string name, address contractAddress);

    function createCollection(string memory name, string memory symbol) public {
        require(nameToAddress[name] == address(0), "Collection already exists");

        NFT newCollection = new NFT(name, symbol, msg.sender);
        collections.push(Collection(name, symbol, address(newCollection)));
        nameToAddress[name] = address(newCollection);
        emit CollectionCreated(name, address(newCollection));
    }

    function getCollectionAddress(string memory name) public view returns (address) {
        return nameToAddress[name];
    }
}
