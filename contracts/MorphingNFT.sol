// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract MorphingNFT is ERC721, Ownable {
    struct Variation {
        string name;
        string baseURI;
        uint32 id;
        bool exists;
    }

    mapping (uint32 => Variation) public variationList;
    uint32 public variationCount;

    mapping (uint256 => uint32) public tokenVariation;

    // Owner only Functions
    function addVariation(string memory name, string memory baseURI) public onlyOwner {
        for(uint32 i = 0; i < variationCount; i++){
            if (keccak256(bytes(variationList[i + 1].name)) == keccak256(bytes(name))) {
                require(!variationList[i + 1].exists, "Variation already exists use update");
            }
        }

        variationCount++;
        variationList[variationCount] = Variation({
            name: name,
            baseURI: baseURI,
            id: variationCount,
            exists: true
        });
    }

    function updateVariation(uint32 variationID, string memory name, string memory baseURI) external onlyOwner {
        require(variationList[variationID].exists, "Variation does not yet exist.");

        variationList[variationID] = Variation({
            name: name,
            baseURI: baseURI,
            id: variationID,
            exists: true
        });
    }

    // Only to be used in error to remove latest variation always ensuring one exists.
    function removeLatestVariation() external onlyOwner {
        require(variationCount > 1, "There must always be a variation.");
        require(variationList[variationCount].exists, "Variation does not yet exist.");

        variationList[variationCount] = Variation({
            name: "",
            baseURI: "",
            id: 0,
            exists: false
        });
        variationCount--;
    }

    function setTokenVariation (uint256 tokenID, uint32 variationID) external {
        require(_exists(tokenID), "Token does not exist");
        require(ownerOf(tokenID) == msg.sender, "Only the token owner can set variation.");
        require(variationList[variationID].exists, "Variation does not yet exist.");

        tokenVariation[tokenID] = variationID;
    }

    // Overrides
    /**
     * @dev Variation of {ERC721Metadata-tokenURI}.
     * Returns different token uri depending on variation set by holder
     */
    function tokenURI(uint256 tokenID) public view override returns (string memory) {
        require(_exists(tokenID), "ERC721Metadata: URI query for nonexistent token");
        Variation memory variation = variationList[tokenVariation[tokenID]].exists ? variationList[tokenVariation[tokenID]] : variationList[1];
        string memory baseURI = variation.baseURI;
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, Strings.toString(tokenID))) : "";
    }
}
