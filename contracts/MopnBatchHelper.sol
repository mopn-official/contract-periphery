// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@mopn/core/interfaces/IAuctionHouse.sol";
import "@mopn/core/interfaces/IAvatar.sol";
import "@mopn/core/interfaces/IGovernance.sol";
import "@mopn/core/interfaces/IMap.sol";
import "@openzeppelin/contracts/utils/math/SignedMath.sol";
import "@mopn/core/libraries/TileMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Multicall.sol";

contract MopnBatchHelper is Multicall, Ownable {
    IGovernance governance;
    IAuctionHouse auctionHouse;
    IAvatar avatar;
    IMap map;

    constructor(address governanceContract_) {
        _setGovernanceContract(governanceContract_);
    }

    function setGovernanceContract(
        address governanceContract_
    ) public onlyOwner {
        _setGovernanceContract(governanceContract_);
    }

    function governanceContract() public view returns (address) {
        return address(governance);
    }

    function _setGovernanceContract(address governanceContract_) internal {
        governance = IGovernance(governanceContract_);
        avatar = IAvatar(governance.avatarContract());
        map = IMap(governance.mapContract());
        auctionHouse = IAuctionHouse(governance.auctionHouseContract());
    }

    /**
     * @notice batch redeem avatar unclaimed minted mopn token
     * @param avatarIds avatar Ids
     * @param delegateWallets Delegate coldwallet to specify hotwallet protocol
     * @param vaults cold wallet address
     */
    function batchRedeemAvatarInboxMT(
        uint256[] memory avatarIds,
        IAvatar.DelegateWallet[] memory delegateWallets,
        address[] memory vaults
    ) public {
        require(
            delegateWallets.length == 0 ||
                delegateWallets.length == avatarIds.length,
            "delegateWallets incorrect"
        );

        if (delegateWallets.length > 0) {
            for (uint256 i = 0; i < avatarIds.length; i++) {
                governance.redeemAvatarInboxMT(
                    avatarIds[i],
                    delegateWallets[i],
                    vaults[i]
                );
            }
        } else {
            for (uint256 i = 0; i < avatarIds.length; i++) {
                governance.redeemAvatarInboxMT(
                    avatarIds[i],
                    IAvatar.DelegateWallet.None,
                    address(0)
                );
            }
        }
    }

    /**
     * @notice batch redeem land holder unclaimed minted mopn token
     * @param LandIds Land Ids
     */
    function batchRedeemLandHolderInboxMT(uint32[] memory LandIds) public {
        for (uint256 i = 0; i < LandIds.length; i++) {
            governance.redeemLandHolderInboxMT(LandIds[i]);
        }
    }

    function redeemAgioTo() public {
        auctionHouse.redeemAgioTo(msg.sender);
    }
}
