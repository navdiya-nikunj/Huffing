// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "foundry-huff/HuffDeployer.sol";

interface IERC721 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint256) external returns (string memory);

    function mint(address, uint256) external payable;
    function burn(uint256) external;

    function transfer(address, uint256) external;
    function transferFrom(address, address, uint256) external;
    function safeTransferFrom(address, address, uint256) external;
    function safeTransferFrom(address, address, uint256, bytes calldata) external;

    function approve(address, uint256) external;
    function setApprovalForAll(address, bool) external;

    function getApproved(uint256) external returns (address);
    function isApprovedForAll(address, address) external view returns (bool);
    function ownerOf(uint256) external view returns (address);
    function balanceOf(address) external view returns (uint256);
    function supportsInterface(bytes4) external view returns (bool);
}

interface CampToken is IERC721 {
// TODO: Add CampToken specific methods
}

contract TestCampToken is Test {
    string public constant NFT_NAME = "CampToken";
    string public constant NFT_SYMBOL = "CPT";

    CampToken public token;

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
}
