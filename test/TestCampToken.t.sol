// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";
import {CampToken} from "../src/CampToken.sol";

contract TestCampTokenHuff is Test {
    string public constant NFT_NAME = "CampToken";
    string public constant NFT_SYMBOL = "CPT";

    address user1 = makeAddr("User 1");
    address user2 = makeAddr("User 2");
    address user3 = makeAddr("User 3");

    CampToken token;

    function setUp() public {
        token = CampToken(
            HuffDeployer.config().with_args(bytes.concat(abi.encode(NFT_NAME), abi.encode(NFT_SYMBOL))).deploy(
                "CampToken"
            )
        );
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

        assertEq(user1Balance, 1);
        assertEq(token.ownerOf(0), user1);
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
        assertEq(token.ownerOf(0), user1);
        assertEq(token.ownerOf(1), user2);
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
        token.safeTransferFrom(user1, user3, 0); // (user3, 0);
        assertEq(token.ownerOf(0), user3);
    }
}
