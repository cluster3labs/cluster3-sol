// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract JustNft is ERC1155 {
    using Address for address;
    // using strings for *;

    struct BadgeBase {
        uint256 id;
        string image;
        uint256 total;
        uint256 left;
        string name;
        string description;
        uint256 circlesId;
    }

    struct Badge {
        uint256 id;
        uint256 baseId;
        address owner;
        address granteeId;
        address granteeToId;
    }

    // base id to base
    mapping(uint256 => BadgeBase) baseMapping;

    // badge id to badge
    mapping(uint256 => Badge) badgeMapping;

    // max base id
    uint256 maxBaseId = 0;

    // base id to max badge id about badges of this base
    mapping(uint256 => uint256) public baseMaxBadgeId;

    // address mapping to badge array
    mapping(address => Badge[]) addressBadges;

    // base mapping to badge array
    mapping(uint256 => Badge[]) baseBadges;

    address public owner;

    constructor() ERC1155("") {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // define badge base
    function defineBadge(string memory image, uint256 total, string memory name, string memory description, uint256 circlesId) public onlyOwner returns (uint256 baseId) {
        maxBaseId = maxBaseId + 1;
        baseId = maxBaseId;
        BadgeBase memory badgeBase = BadgeBase(baseId, image, total, total, name, description, circlesId);
        baseMapping[baseId] = badgeBase;
    }

    function mint(address to, uint256 amount, uint256 baseId) public onlyOwner returns (uint256 badgeId) {
        require(baseMapping[baseId].id != 0, "base not exits");
        require(to != address(0), "can not mint to the zero address");
        // check left
        BadgeBase memory badgeBase = baseMapping[baseId];
        require(badgeBase.left > 0, "base left not enough");
        badgeBase.left = badgeBase.left - 1;

        // get badge id
        uint256 oldMaxBadgeId = baseMaxBadgeId[baseId];
        badgeId = oldMaxBadgeId + 1;
        baseMaxBadgeId[baseId] = badgeId;

        // mint
        _mint(to, badgeId, amount, "");

        // save data
        Badge memory badge = Badge(badgeId, baseId, to, msg.sender, to);
        addressBadges[to].push(badge);
        baseBadges[baseId].push(badge);
        badgeMapping[badgeId] = badge;
    }

    function uri(uint256 badgeId) override public view returns (string memory) {
        require(badgeMapping[badgeId].id != 0, "token not exits");
        Badge memory badge = badgeMapping[badgeId];
        uint256 baseId = badge.baseId;
        BadgeBase memory badgeBase = baseMapping[baseId];
//        string memory result = "{\"image\":\"ipfs://" + badgeBase.image + "\",\"httpUrl\":\"https://ipfs.io/ipfs/" + badgeBase.image + "\",\"imageUrl\":\"ipfs://"
//        + badgeBase.image + "\",\"name\":\"" + badgeBase.name + "\",\"description\":\"" + badgeBase.description + "\",\"id\":" + badgeId + ",\"title\":\"" + badgeBase.name + "\",\"type\":\"img\"}";
        string memory result = string.concat("{\"image\":\"ipfs://", badgeBase.image, "\",\"httpUrl\":\"https://ipfs.io/ipfs/", badgeBase.image, "\",\"imageUrl\":\"ipfs://"
        , badgeBase.image, "\",\"name\":\"", badgeBase.name, "\",\"description\":\"", badgeBase.description, "\",\"id\":", Strings.toString(badgeId), ",\"title\":\"", badgeBase.name, "\",\"type\":\"img\"}");
        return result;
    }

    // todo, supportsInterface

    // balanceOf
    function balanceOf(address account, uint256 badgeId) public view override returns (uint256) {
        require(account != address(0), "address zero is not a valid owner");
        return addressBadges[account].length;
    }
}