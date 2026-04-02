// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ContentSubscription
 * @dev Time-limited NFT keys for premium access.
 */
contract ContentSubscription is ERC721, Ownable {
    uint256 public constant SUBSCRIPTION_PRICE = 0.05 ether;
    uint256 public constant DURATION = 30 days;
    uint256 private _nextTokenId;

    mapping(address => uint256) public userToTokenId;
    mapping(uint256 => uint256) public expirationTimestamp;

    event Subscribed(address indexed user, uint256 tokenId, uint256 expiration);

    constructor() ERC721("ContentKey", "KEY") Ownable(msg.sender) {}

    /**
     * @dev Buy or renew a subscription.
     */
    function subscribe() external payable {
        require(msg.value >= SUBSCRIPTION_PRICE, "Insufficient ETH");
        
        uint256 tokenId = userToTokenId[msg.sender];

        if (tokenId == 0 && balanceOf(msg.sender) == 0) {
            // New Subscriber
            tokenId = ++_nextTokenId;
            _safeMint(msg.sender, tokenId);
            userToTokenId[msg.sender] = tokenId;
            expirationTimestamp[tokenId] = block.timestamp + DURATION;
        } else {
            // Renewing Subscriber
            if (expirationTimestamp[tokenId] < block.timestamp) {
                expirationTimestamp[tokenId] = block.timestamp + DURATION;
            } else {
                expirationTimestamp[tokenId] += DURATION;
            }
        }

        emit Subscribed(msg.sender, tokenId, expirationTimestamp[tokenId]);
    }

    /**
     * @dev Check if the user currently has active access.
     */
    function isValid(address _user) external view returns (bool) {
        uint256 tokenId = userToTokenId[_user];
        if (tokenId == 0) return false;
        return expirationTimestamp[tokenId] > block.timestamp;
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
