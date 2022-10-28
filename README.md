# Morphing-NFTs

The code as part of this repository was made as a proof of concept to allow for an NFT to have different variations throughout it's lifetime with artists being able to gift different alternative iterations of a paticular NFT. An NFT holder has the power to set on chain which iteration that wish to display as their main NFT. The way that this works is by having multiple Base URI options stored within the contract which can be added at a later point in time.

Please note this code has not been used in production.

## Getting started

The main contract where the logic lives is within [MorphingNFT.sol](./contracts/MorphingNFT.sol) here you'll find an abstract contract. An example NFT contract using the Morphing contract can be found [ProofOfConcept.sol](./contracts/ProofOfConceptNFT.sol).

## Functions used

### Owner Only

> addVariation(string memory name, string memory baseURI)

This function allows new variations to be added to the NFT contract `name` being a unique string to identify the variation and `baseURI` being the normal base URI location for the variation such as `ipfs://0x000a0a0a0/`.

> removeLatestVariation()

This function will remove the latest variation assigned to the contract and is intended as a fail safe only in the case of unforseen errors. Variation 1 **must** always exist and will throw an error if the only variation is attempted to be removed.

Note that if a variation that is removed is used by a Token then the NFT will revert back to the first variation.

> updateVariation(uint32 variationID, string memory name, string memory baseURI)

This function allows for changing a variations `name` and or `baseURI`. You will be able to get the `variationID` from a read function on the contract looking at the mapping on `variationList`.

### Token (NFT) Specific

> setTokenVariation(uint256 tokenID, uint32 variationID)

This function allows the NFT holder to interact with the contract on chain to set which variation they personally want to use as their main variation. This function will check to ensure that both the token and variation both exist.
