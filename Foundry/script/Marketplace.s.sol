// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

contract MarketplaceScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
    }

    // deployments on base-goerli
    // 0xa458d72afef73c2bba57ca94aef0f0fae831bd8f SignUtils
    // 0x22f48518c17FF6034EaBEd0cA89Ae08101De5DB4 Marketplace
}
