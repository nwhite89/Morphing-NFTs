// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./MorphingNFT.sol";

contract ProofOfConcept is MorphingNFT {

    uint32 private currentSupply = 0;

    constructor() ERC721("Morphing POC", "MPOC") {
        addVariation('base', 'ipfs://random/');
    }

    function totalSupply() public view returns (uint) {
        return currentSupply;
    }

    function mintNFT() external payable {
        currentSupply++;
        _safeMint(msg.sender, currentSupply);
    }

    function withdraw(uint amount) external onlyOwner {
        require(payable(msg.sender).send(amount));
    }
}

