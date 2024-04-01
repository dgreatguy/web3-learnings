// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

contract Marketplace {
    struct Order {
        address payable seller;
        address tokenAddress;
        uint256 tokenId;
        uint256 price;
        bytes signature;
        uint256 deadline;
    }

    mapping(bytes32 => bool) public usedSignatures;
    mapping(bytes32 => Order) public orders;

    function createOrder(
        address _seller,
        address _tokenAddress,
        uint256 _tokenId,
        uint256 _price,
        bytes calldata _signature,
        uint256 _deadline
    ) public {
        require(_price > 0, "Price must be greater than zero");
        require(_deadline > block.timestamp, "Deadline must be in the future");

        //Check if it's been used
        bytes32 orderId = keccak256(
            abi.encodePacked(
                _tokenAddress,
                _tokenId,
                _price,
                _seller,
                _deadline
            )
        );
        require(!usedSignatures[orderId], "Signature has already been used");

        //Verify signature
        bytes32 orderHash = keccak256(
            abi.encodePacked(
                _tokenAddress,
                _tokenId,
                _price,
                msg.sender,
                _deadline
            )
        );
        // require(orderHash.recover(_signature) == msg.sender, "Invalid signature");
        require(
            verifySignature(orderHash, _signature, msg.sender),
            "Invalid signature"
        );

        // Transfer NFT ownership to contract
        IERC721(_tokenAddress).safeTransferFrom(
            msg.sender,
            address(this),
            _tokenId
        );

        //Create the order
        Order memory order = Order(
            payable(msg.sender),
            _tokenAddress,
            _tokenId,
            _price,
            _signature,
            _deadline
        );
        
        //Store the order
        orders[orderHash] = order;

        usedSignatures[orderId] = true;
    }

    function executeOrder(bytes32 _orderHash) public payable {
        require(
            orders[_orderHash].seller != msg.sender,
            "Seller cannot purchase their own listing"
        );
        Order storage order = orders[_orderHash];
        require(order.deadline > block.timestamp, "Order expired");
        require(order.price == msg.value, "Incorrect ETH value");
        require(order.tokenAddress != address(0), "Order does not exist");

        //Verify the signature
        bytes32 orderHash = keccak256(
            abi.encodePacked(
                order.tokenAddress,
                order.tokenId,
                order.price,
                order.seller,
                order.deadline
            )
        );
        // require(
        //     orderHash.recover(order.signature) == order.seller,
        //     "Invalid signature"
        // );
        require(
            verifySignature(orderHash, order.signature, order.seller),
            "Invalid signature"
        );

        // Transfer NFT ownership to buyer
        IERC721(order.tokenAddress).safeTransferFrom(
            address(this),
            msg.sender,
            order.tokenId
        );

        //Pay seller
        order.seller.transfer(msg.value);

        //Update the token owner and remove the order
        delete orders[_orderHash];
    }

    function verifySignature(
        bytes32 hash,
        bytes memory signature,
        address signer
    ) internal view returns (bool) {
        bytes32 ethSignedHash = ECDSA.toEthSignedMessageHash(hash);
        return ECDSA.recover(ethSignedHash, signature) == signer;
    }
}
