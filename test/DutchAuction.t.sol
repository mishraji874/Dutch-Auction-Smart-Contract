// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/DutchAuction.sol";
import "./mocks/MockERC721.sol";

contract DutchAuctionTest is Test {
    DutchAuction public auction;
    MockERC721 public nft;

    address public seller;
    address public buyer;

    uint public constant NFT_ID = 1;
    uint public constant STARTING_PRICE = 1 ether;
    uint public constant DISCOUNT_RATE = 1157407407407; // 0.1 ether / 1 days in wei/sec

    function setUp() public {
        seller = address(this);
        buyer = address(0xBEEF);
        nft = new MockERC721();

        nft.mint(seller, NFT_ID);

        auction = new DutchAuction(
            STARTING_PRICE,
            DISCOUNT_RATE,
            address(nft),
            NFT_ID
        );

        // Simulate the NFT being owned by the seller (auction contract will call transferFrom from seller)
        nft.mint(address(this), NFT_ID);
    }

    function testInitialState() public {
        assertEq(auction.startingPrice(), STARTING_PRICE);
        assertEq(auction.discountRate(), DISCOUNT_RATE);
        assertEq(auction.nftId(), NFT_ID);
        assertEq(address(auction.nft()), address(nft));
        assertEq(auction.seller(), seller);
    }

    function test_RevertWhen_StartingPriceTooLow() public {
        uint lowPrice = DISCOUNT_RATE * 7 days - 1;

        vm.expectRevert("Starting price is too low");
        new DutchAuction(lowPrice, DISCOUNT_RATE, address(nft), NFT_ID);
    }

    function testGetPriceAfter3Days() public {
        vm.warp(block.timestamp + 3 days);

        uint expectedPrice = STARTING_PRICE - (DISCOUNT_RATE * 3 days);
        assertEq(auction.getPrice(), expectedPrice);
    }

    function testBuyAtCurrentPrice() public {
        vm.deal(buyer, 2 ether);

        // Move time forward 2 days
        vm.warp(block.timestamp + 2 days);
        uint price = auction.getPrice();

        vm.prank(buyer);
        auction.buy{value: price}();

        // Check NFT ownership
        assertEq(nft.ownerOf(NFT_ID), buyer);
    }

    function testBuyWithExcessPaymentGetsRefund() public {
        vm.deal(buyer, 2 ether);

        vm.warp(block.timestamp + 1 days);
        uint price = auction.getPrice();

        uint overpaid = price + 0.1 ether;
        uint buyerInitialBalance = buyer.balance;

        vm.prank(buyer);
        auction.buy{value: overpaid}();

        // Check buyer owns NFT
        assertEq(nft.ownerOf(NFT_ID), buyer);

        // Check refund (within 1 wei tolerance)
        assertApproxEqAbs(buyer.balance, buyerInitialBalance - price, 1);
    }

    function test_RevertWhen_BuyAfterAuctionExpired() public {
        vm.deal(buyer, 2 ether);

        vm.warp(block.timestamp + 8 days); // auction duration is 7 days

        vm.prank(buyer);
        vm.expectRevert("Auction expired");
        auction.buy{value: 2 ether}();
    }

    function test_RevertWhen_BuyWithInsufficientFunds() public {
        vm.deal(buyer, 0.01 ether);

        vm.prank(buyer);
        vm.expectRevert("The amount of ETH sent is less than the price of token");
        auction.buy{value: 0.01 ether}();
    }
}
