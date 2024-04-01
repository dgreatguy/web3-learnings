// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";
// import "openzeppelin-contracts/contracts/utils/Address.sol";
import {SignUtils} from "./libraries/SignUtils.sol";

contract Marketplace {
    struct Listing {
        address token;
        uint256 tokenId;
        uint256 price;
        bytes sig;
        //slot3
        uint88 deadline; //uint88?
        address lister;
        bool active;
    }

    error NotOwner();
    error NotApproved();
    error MinPriceTooLow();
    error InvalidDeadline();
    error MinDurationNotMet();
    error InvalidSignature();

    error ListingNotExistent();
    error ListingNotActive();
    error PriceNotMet(uint256 difference);
    error PriceMismatch(uint256 originalPrice); //why?
    error ListingExpired();

    mapping(uint256 => Listing) public listings;
    address public admin;
    uint256 public listingId;

    event ListingCreated(uint256 indexed listingId, Listing);
    event ListingExecuted(uint256 indexed listingId, Listing);
    event ListingEdited(uint256 indexed listingId, Listing);

    constructor() {
        admin = msg.sender;
    }

    function createListing(Listing calldata l) public returns (uint256 lId) {
        if (IERC721(l.token).ownerOf(l.tokenId) != msg.sender)
            revert NotOwner();
        if (!IERC721(l.token).isApprovedForAll(msg.sender, address(this)))
            revert NotApproved();
        if (l.price < 0.01 ether) revert MinPriceTooLow();
        if (l.deadline < block.timestamp) revert InvalidDeadline();
        if (l.deadline - block.timestamp < 1 days) revert MinDurationNotMet();

        // assert signature

        // bytes32 hash = keccak256(
        //     abi.encodePacked(
        //         l.token,
        //         l.tokenId,
        //         l.price,
        //         msg.sender,
        //         l.deadline
        //     )
        // );
        // if (ECDSA.recover(hash, l.sig) != l.lister) revert InvalidSignature();

        if (
            !SignUtils.isValid(
                SignUtils.constructMessageHash(
                    l.token,
                    l.tokenId,
                    l.price,
                    l.deadline,
                    l.lister
                ),
                l.sig,
                msg.sender
            )
        ) revert InvalidSignature();

        //append to storage
        Listing storage listing = listings[listingId];
        listing.lister = msg.sender;
        listing.token = l.token;
        listing.tokenId = l.tokenId;
        listing.price = l.price;
        listing.sig = l.sig;
        listing.deadline = uint88(l.deadline);
        listing.active = true;

        //emit event
        emit ListingCreated(listingId, listing);
        lId = listingId;
        listingId++;
        return lId;
    }

    function executeListing(uint256 _listingId) public payable {
        if (_listingId >= listingId) revert ListingNotExistent();
        Listing storage listing = listings[_listingId];
        if (listing.deadline < block.timestamp) revert ListingExpired();
        if (!listing.active) revert ListingNotActive();
        if (listing.price > msg.value)
            revert PriceNotMet(listing.price - msg.value);
        if (listing.price != msg.value) revert PriceMismatch(listing.price);

        //update state
        listing.active = false;

        //transfer
        IERC721(listing.token).transferFrom(
            listing.lister,
            msg.sender,
            listing.tokenId
        );

        //transferETH
        payable(listing.lister).transfer(listing.price);

        //emit event
        emit ListingExecuted(_listingId, listing);
    }

    function editListing(uint256 _listingId, uint256 newPrice) public {
        if (_listingId >= listingId) revert ListingNotExistent();
        Listing storage listing = listings[_listingId];
        if (listing.lister != msg.sender) revert NotOwner();
        listing.price = newPrice;
        listing.active = true;

        //emit event
        emit ListingEdited(_listingId, listing);
    }

    function getListing(
        uint256 _listingId
    ) public view returns (Listing memory) {
        //     if (_orderId >= orderId)
        return listings[_listingId];
    }
}
