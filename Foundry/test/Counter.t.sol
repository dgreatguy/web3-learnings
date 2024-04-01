pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Marketplace} from "../src/Counter.sol";

contract TestMarketplace is Test {
    Marketplace marketplace;

    function setUp() public {
        marketplace = new Marketplace();
    }

    // address seller = address(0x9434E0a9878a1bE87918762a846dBEa7B333B5DE);
    // address buyer = address(0x0489DB67c9B49C1C813da3C538103926f31BE572);
    // address tokenAddress = address(0x26F2f9995D136c1717dfad0443442fD4755Bff0a);

    function testCreateOrder() public {
        address seller = address(0x9434E0a9878a1bE87918762a846dBEa7B333B5DE);
        address tokenAddress = address(
            0x26F2f9995D136c1717dfad0443442fD4755Bff0a
        );
        uint256 tokenId = 1;
        uint256 price = 0.1 ether;
        bytes memory signature = abi.encodePacked(seller);
        uint256 deadline = block.timestamp + 86400;

        // mapping(bytes32 => Marketplace.Order) orders;

        bytes32 orderId = keccak256(
            abi.encodePacked(tokenAddress, tokenId, price, msg.sender, deadline)
        );

        marketplace.createOrder(
            seller,
            tokenAddress,
            tokenId,
            price,
            signature,
            deadline
        );

        Marketplace.Order memory order = marketplace.orders(orderId);

        assertEq(order.seller, msg.sender, "Seller should be the caller");
        assertEq(
            order.tokenAddress,
            tokenAddress,
            "Token address should match"
        );
        assertEq(order.tokenId, tokenId, "Token ID should match");
        assertEq(order.price, price, "Price should match");
        assertEq(order.signature, signature, "Signature should match");
        assertEq(order.deadline, deadline, "Deadline should match");
    }

    function testExecuteOrder() public {
        address seller = address(0x9434E0a9878a1bE87918762a846dBEa7B333B5DE);
        address buyer = address(0x0489DB67c9B49C1C813da3C538103926f31BE572);
        address tokenAddress = address(
            0x26F2f9995D136c1717dfad0443442fD4755Bff0a
        );
        uint256 tokenId = 123;
        uint256 price = 100;
        bytes memory signature = abi.encodePacked(seller);
        uint256 deadline = block.timestamp + 86400;

        // Create the order
        marketplace.createOrder(
            seller,
            tokenAddress,
            tokenId,
            price,
            signature,
            deadline
        );

        // Execute the order
        vm.prank(buyer);
        marketplace.executeOrder{value: price}(tokenId);

        // Check that the order was executed correctly
        Marketplace.Order memory order = marketplace.orders(tokenId);

        assertEq(order.seller, buyer, "Buyer should be the new owner");
        assertEq(order.price, 0, "Price should be zero");
    }

    function testOrderExpired() public {
        address seller = address(0x9434E0a9878a1bE87918762a846dBEa7B333B5DE);
        address token = address(0x26F2f9995D136c1717dfad0443442fD4755Bff0a);
        uint256 tokenId = 1;
        uint256 pastDeadline = block.timestamp - 86400;
        bytes memory signature = abi.encodePacked(seller);

        marketplace.createOrder(
            seller,
            token,
            tokenId,
            1 ether,
            signature,
            pastDeadline
        );

        vm.expectRevert("Order deadline expired");
        marketplace.executeOrder(tokenId);
    }
}
