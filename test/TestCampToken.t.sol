// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";
import {CampToken} from "../src/CampToken.sol";

contract TestCampTokenHuff is Test {
    string public constant NFT_NAME = "CampToken";
    string public constant NFT_SYMBOL = "CPT";

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
}
