### contract data
1. struct BadgeBase {
   uint256 id;
   string image;
   uint256 total;
   uint256 left;
   string name;
   string description;
   uint256 circlesId;
   }
2. struct Badge {
   uint256 id;
   uint256 baseId;
   address owner;
   address granteeId;
   address granteeToId;
   }
3. // base id to base
   mapping(uint256 => BadgeBase) baseMapping;
4. // badge id to badge
   mapping(uint256 => Badge) badgeMapping;
5. // max base id
   uint256 maxBaseId = 0;
6. // base id to max badge id about badges of this base
   mapping(uint256 => uint256) public baseMaxBadgeId;
7. address public owner;
8. // address mapping to badge array
   mapping(address => Badge[]) addressBadges;
9. // base mapping to badge array
   mapping(uint256 => Badge[]) baseBadges;

### contract function
1. defineBadge, define nft base msg
2. mint, mint a nft to address, this check base define, main is left num
3. balanceOf