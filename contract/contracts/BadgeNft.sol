// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract BadgeNft is ERC1155 {
    using Address for address;

    // base id to base
    address public owner;

    mapping(address => uint256) balanceMapping;

    constructor() ERC1155("http://cluster.flowingcloud.cn/develop/{id}.json") {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function mint(address to, uint256 tokenId) public onlyOwner {
        require(to != address(0), "can not mint to the zero address");

        // mint
        _mint(to, tokenId, 1, "");
        balanceMapping[to] = balanceMapping[to] + 1;
    }

    function uri(uint256 tokenId) override public pure returns (string memory) {
        return string.concat("http://cluster.flowingcloud.cn/develop/", Strings.toString(tokenId), ".json");
    }

    // balanceOf
    function balanceOf(address account) public view returns (uint256) {
        require(account != address(0), "address zero is not a valid owner");
        return balanceMapping[account];
    }
}