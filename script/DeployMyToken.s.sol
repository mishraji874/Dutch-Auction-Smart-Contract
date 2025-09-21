// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/MyToken.sol";

contract DeployMyToken is Script {
    function run() external {
        // Use Anvil default private key (Account #0)
        uint256 privateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
        address deployer = vm.addr(privateKey);

        // Minting details
        address recipient = deployer;
        uint256 tokenId = 1;

        // Broadcast transactions using the Anvil account
        vm.startBroadcast(privateKey);

        // Deploy the contract
        MyToken myToken = new MyToken(deployer);
        console2.log("MyToken deployed at:", address(myToken));

        // Mint a token
        myToken.safeMint(recipient, tokenId);
        console2.log("Minted token", tokenId, "to", recipient);

        vm.stopBroadcast();
    }
}
