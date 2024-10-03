// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";
import {CampToken} from "../src/CampToken.sol";

contract TestCampTokenHuff is Test {
    string public constant NFT_NAME = "CampToken";
    string public constant NFT_SYMBOL = "CPT";

    string public tokenURI =
        "https://tomato-geographical-pig-904.mypinata.cloud/ipfs/QmfAnPdPTaodz14mrigKUFnVcdSJjLvhNi2aqFomYGerPF";

    /// @dev don't change the input private keys, or the public address might change and affect tests
    // user1: 0x233F20a935E25f6c993a71F72cCBE72c79A1F7FC, tokenId : 69
    address user1 = makeAddr("User 1");
    // user2: 0x8993e8FD026fC11Ad77fB612fB3175C4c0C55330, tokenId: 42
    address user2 = makeAddr("User 2");
    address user3 = makeAddr("User 3");

    CampToken token;

    function setUp() public {
        token = CampToken(
            HuffDeployer.config().with_args(bytes.concat(abi.encode(NFT_NAME), abi.encode(NFT_SYMBOL))).deploy(
                "CampToken"
            )
        );
        token.whiteListMinters();
    }

    function testName() public view {
        string memory tokenName = token.name();
        assertEq(tokenName, NFT_NAME);
    }

    function testSymbol() public view {
        string memory tokenSymbol = token.symbol();
        assertEq(tokenSymbol, NFT_SYMBOL);
    }

    function testMinting() public {
        vm.prank(user1);
        token.mintToken();
        uint256 user1Balance = token.balanceOf(user1);
        console.log("user1: ", user1);
        console.log("user2: ", user2);

        assertEq(user1Balance, 1);
        assertEq(token.ownerOf(69), user1);
    }

    function testTokenIDgetsUpdated() public {
        vm.prank(user1);
        token.mintToken();
        vm.prank(user2);
        token.mintToken();
        uint256 user1Balance = token.balanceOf(user1);
        uint256 user2Balance = token.balanceOf(user2);

        assertEq(user1Balance, 1);
        assertEq(user2Balance, 1);
        // assertEq(token.ownerOf(0), user1);
        // assertEq(token.ownerOf(1), user2);
        assertEq(token.ownerOf(69), user1);
        assertEq(token.ownerOf(42), user2);
    }

    function testDoubleMintingFromSameUserFails() public {
        vm.startPrank(user1);
        token.mintToken();
        vm.expectRevert();
        token.mintToken();
        vm.stopPrank();
    }

    // the vanilla functions work as of now.
    // if the token needs to be converted to a soulbound token, the test will need to be adjusted

    function testTransfer() public {
        vm.startPrank(user1);
        token.mintToken();
        token.safeTransferFrom(user1, user3, 69); // (user3, 0);
        vm.stopPrank();
        assertEq(token.ownerOf(69), user3);
    }

    function testWhiteListing() public view {
        // vm.prank(user3);
        // token.whiteListMinters();
        uint256 whiteListTokenId = token.getWhiteListedTokeIDForAddress(0xcF78399B272E71F23F00b453005e9ba0EFa9FcDc);
        assertEq(whiteListTokenId, 8);
    }

    function testWhiteListingForTestAccount() public view {
        // vm.prank(user3);
        // token.whiteListMinters();
        uint256 whiteListTokenId = token.getWhiteListedTokeIDForAddress(user1);
        assertEq(whiteListTokenId, 69);
    }

    function testNonWhiteListedGetsReverted() public {
        vm.prank(user3);
        vm.expectRevert();
        token.mintToken();
    }

    function testBurn() public {
        vm.prank(user1);
        token.mintToken();
        vm.prank(user2);
        token.burn(69);
        assertEq(token.balanceOf(user1), 0);
    }
}
