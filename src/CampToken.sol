// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IFull721 is IERC721 {
    function mintToken() external payable;
    function whiteListMinters() external;
    function getWhiteListedTokeIDForAddress(address) external view returns (uint256);
    function burn(uint256) external;
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
}

interface CampToken is IFull721 {
// constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {}
// TODO: Keep adding the other additional functions here
}
