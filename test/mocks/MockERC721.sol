// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

contract MockERC721 {
    mapping(uint => address) private _owners;

    function mint(address to, uint tokenId) external {
        _owners[tokenId] = to;
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external {
        require(_owners[tokenId] == from, "Not the owner");
        _owners[tokenId] = to;
    }

    function ownerOf(uint256 tokenId) external view returns (address) {
        return _owners[tokenId];
    }
}
