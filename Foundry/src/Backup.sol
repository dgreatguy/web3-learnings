// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin/contracts/token/ERC721/IERC721.sol";
import "openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract ERC721Marketplace is IERC721Receiver {
    using ECDSA for bytes32;

    struct Order {
        address tokenAddress;
        uint256 tokenId;
        uint256 price;
        address payable seller;
        uint256 deadline;
        bytes signature;
    }

    mapping(bytes32 => bool) public usedSignatures;
    mapping(bytes32 => Order) public orders;

    event OrderCreated(
        bytes32 indexed orderId,
        address indexed tokenAddress,
        uint256 indexed tokenId,
        uint256 price,
        address seller,
        uint256 deadline
    );
    event OrderFulfilled(bytes32 indexed orderId, address indexed buyer);

    function createOrder(
        address tokenAddress,
        uint256 tokenId,
        uint256 price,
        uint256 deadline,
        bytes calldata signature
    ) external {
        require(price > 0, "Price must be greater than zero");
        require(deadline > block.timestamp, "Deadline must be in the future");

        bytes32 orderId = keccak256(
            abi.encodePacked(tokenAddress, tokenId, price, msg.sender, deadline)
        );
        require(!usedSignatures[orderId], "Signature has already been used");

        bytes32 messageHash = keccak256(
            abi.encodePacked(tokenAddress, tokenId, price, msg.sender, deadline)
        );
        address seller = messageHash.recover(signature);
        require(seller == msg.sender, "Invalid signature");

        IERC721(tokenAddress).safeTransferFrom(
            msg.sender,
            address(this),
            tokenId
        );

        orders[orderId] = Order({
            tokenAddress: tokenAddress,
            tokenId: tokenId,
            price: price,
            seller: payable(msg.sender),
            deadline: deadline,
            signature: signature
        });

        usedSignatures[orderId] = true;

        emit OrderCreated(
            orderId,
            tokenAddress,
            tokenId,
            price,
            msg.sender,
            deadline
        );
    }

    function fulfillOrder(bytes32 orderId) external payable {
        Order storage order = orders[orderId];
        require(order.tokenAddress != address(0), "Order does not exist");
        require(order.deadline > block.timestamp, "Order has expired");
        require(msg.value == order.price, "Incorrect amount of ether sent");

        IERC721(order.tokenAddress).safeTransferFrom(
            address(this),
            msg.sender,
            order.tokenId
        );
        order.seller.transfer(msg.value);

        emit OrderFulfilled(orderId, msg.sender);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
}
