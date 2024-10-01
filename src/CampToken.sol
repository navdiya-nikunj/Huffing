// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CampToken is ERC721 {
    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {}
    // TODO: Keep adding the other additional functions here
}
