// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solmate/tokens/ERC721.sol";

contract MyNFT is ERC721("MyNFT", "MNFT") {
    function tokenURI(
        uint256
    ) public view virtual override returns (string memory) {
        return "base-marketplace";
    }

    function mint(address recipient, uint256 tokenId) public payable {
        _mint(recipient, tokenId);
    }
}
