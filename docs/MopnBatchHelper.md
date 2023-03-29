# Solidity API

## MopnBatchHelper

### governance

```solidity
contract IGovernance governance
```

### avatar

```solidity
contract IAvatar avatar
```

### map

```solidity
contract IMap map
```

### constructor

```solidity
constructor(address governanceContract) public
```

### setGovernanceContract

```solidity
function setGovernanceContract(address governanceContract) public
```

### _setGovernanceContract

```solidity
function _setGovernanceContract(address governanceContract) internal
```

### batchRedeemAvatarInboxMT

```solidity
function batchRedeemAvatarInboxMT(uint256[] avatarIds, enum IAvatar.DelegateWallet[] delegateWallets, address[] vaults) public
```

batch redeem avatar unclaimed minted mopn token

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| avatarIds | uint256[] | avatar Ids |
| delegateWallets | enum IAvatar.DelegateWallet[] | Delegate coldwallet to specify hotwallet protocol |
| vaults | address[] | cold wallet address |

### batchRedeemLandHolderInboxMT

```solidity
function batchRedeemLandHolderInboxMT(uint32[] LandIds) public
```

batch redeem land holder unclaimed minted mopn token

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| LandIds | uint32[] | Land Ids |

