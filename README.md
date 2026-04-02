# Content Subscription (Unlock-lite)

A professional-grade implementation for the Creator Economy. This repository allows creators to "Lock" their content behind an NFT-based paywall. Users purchase a "Key" (NFT) that has a built-in expiration timestamp. Once the key expires, the user's access is automatically revoked unless they renew the subscription.

## Core Features
* **Time-Bound NFTs:** Token ownership includes an `expiration` attribute.
* **Subscription Tiers:** Support for different durations (Weekly, Monthly, Yearly).
* **Renewable Logic:** Users can extend their access by sending additional funds to the contract.
* **Flat Architecture:** Single-directory layout for the Membership NFT and the Treasury logic.

## Workflow
1. **Mint:** User pays 0.05 ETH for a 30-day "Key."
2. **Access:** The frontend checks the `isValid(user)` function on-chain.
3. **Expire:** After 30 days, `isValid` returns `false`.
4. **Renew:** User pays again to extend the `expiration` by another 30 days.

## Setup
1. `npm install`
2. Deploy `ContentSubscription.sol`.
