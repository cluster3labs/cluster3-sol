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

    function mint(address to, uint256 amount, uint256 baseId, bytes memory data) public onlyOwner {
        require(baseMapping[baseId].id != 0, "base not exits");
        require(to != address(0), "can not mint to the zero address");
        uint256 maxBadgeId = baseMaxBadgeId[baseId];
        maxBadgeId = maxBadgeId + 1;
        baseMaxBadgeId[baseId] = maxBadgeId;
        _mint(to, maxBadgeId, amount, data);
        Badge memory badge = Badge(maxBadgeId, baseId, to, msg.sender, to);
        badgeMapping[maxBadgeId] = badge;
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

    // todo, need change
    function supportsInterface(bytes4 interfaceId) public view override(ERC1155) returns (bool) {
        return
        interfaceId == type(IERC1155).interfaceId ||
        interfaceId == type(IERC1155MetadataURI).interfaceId ||
        super.supportsInterface(interfaceId);
    }
}