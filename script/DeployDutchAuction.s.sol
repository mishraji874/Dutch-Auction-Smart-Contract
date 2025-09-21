// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/DutchAuction.sol";


contract DeployDutchAuction is Script {
    function run() external {
        // Use Anvil default private key (Account #0)
        uint256 privateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
        address deployer = vm.addr(privateKey);

        // Constants (set as needed)
        uint256 startingPrice = 1 ether;
        uint256 discountRate = 1157407407407; // = 0.1 ether / 1 day (in wei/sec)
        address nftAddress = 0x5FbDB2315678afecb367f032d93F642f64180aa3; // Pass in your NFT contract
        uint256 nftId = 1;

        // Start broadcasting deployment transaction
        vm.startBroadcast(privateKey);

        DutchAuction auction = new DutchAuction(
            startingPrice,
            discountRate,
            nftAddress,
            nftId
        );

        vm.stopBroadcast();

        console2.log("DutchAuction deployed at:", address(auction));
    }
}
