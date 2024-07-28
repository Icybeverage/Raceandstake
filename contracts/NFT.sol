// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721URIStorage, Ownable {
    uint256 public tokenCounter;

    event NFTCreated(uint256 tokenId, string tokenURI);

    constructor(string memory name, string memory symbol, address owner) ERC721(name, symbol) Ownable() {
        tokenCounter = 0;
        transferOwnership(owner);  // Set the owner to the provided address
    }

    function createNFT(string memory tokenURI) public onlyOwner returns (uint256) {
        uint256 newTokenId = tokenCounter;
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        tokenCounter += 1;
        emit NFTCreated(newTokenId, tokenURI);
        return newTokenId;
    }
}



