// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@mopn/core/interfaces/IAvatar.sol";
import "@mopn/core/interfaces/IGovernance.sol";
import "@mopn/core/interfaces/IMap.sol";
import "@openzeppelin/contracts/utils/math/SignedMath.sol";
import "@mopn/core/libraries/TileMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MopnBatchHelper is Ownable {
    IGovernance governance;
    IAvatar avatar;
    IMap map;

    constructor(address governanceContract) {
        _setGovernanceContract(governanceContract);
    }

    function setGovernanceContract(
        address governanceContract
    ) public onlyOwner {
        _setGovernanceContract(governanceContract);
    }

    function _setGovernanceContract(address governanceContract) internal {
        governance = IGovernance(governanceContract);
        avatar = IAvatar(governance.avatarContract());
        map = IMap(governance.mapContract());
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

        for (uint256 i = 0; i < avatarIds.length; i++) {
            governance.redeemAvatarInboxMT(
                avatarIds[i],
                delegateWallets[i],
                vaults[i]
            );
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
}
