// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@mopn/core/interfaces/IAvatar.sol";
import "@mopn/core/interfaces/IGovernance.sol";
import "@mopn/core/interfaces/IMap.sol";
import "@openzeppelin/contracts/utils/math/SignedMath.sol";
import "@mopn/core/libraries/TileMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MopnDataHelper is Ownable {
    struct AvatarDataOutput {
        address contractAddress;
        uint256 tokenId;
        uint256 avatarId;
        uint256 COID;
        uint256 BombUsed;
        uint32 tileCoordinate;
    }

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

    function getAvatarByAvatarId(
        uint256 avatarId
    ) public view returns (AvatarDataOutput memory avatarData) {
        avatarData.COID = avatar.getAvatarCOID(avatarId);
        if (avatarData.COID > 0) {
            avatarData.tokenId = avatar.getAvatarTokenId(avatarId);
            avatarData.avatarId = avatarId;
            avatarData.contractAddress = governance.getCollectionContract(
                avatarData.COID
            );
            avatarData.BombUsed = avatar.getAvatarBombUsed(avatarId);
            avatarData.tileCoordinate = avatar.getAvatarCoordinate(avatarId);
        }
    }

    /**
     * @notice get avatar info by nft contractAddress and tokenId
     * @param collection  collection contract address
     * @param tokenId  token Id
     * @return avatarData avatar data format struct AvatarDataOutput
     */
    function getAvatarByNFT(
        address collection,
        uint256 tokenId
    ) public view returns (AvatarDataOutput memory avatarData) {
        avatarData = getAvatarByAvatarId(
            avatar.getNFTAvatarId(collection, tokenId)
        );
    }

    /**
     * @notice get avatar infos by nft contractAddresses and tokenIds
     * @param collections array of collection contract address
     * @param tokenIds array of token Ids
     * @return avatarDatas avatar datas format struct AvatarDataOutput
     */
    function getAvatarsByNFTs(
        address[] calldata collections,
        uint256[] calldata tokenIds
    ) public view returns (AvatarDataOutput[] memory avatarDatas) {
        avatarDatas = new AvatarDataOutput[](collections.length);
        for (uint256 i = 0; i < collections.length; i++) {
            avatarDatas[i] = getAvatarByAvatarId(
                avatar.getNFTAvatarId(collections[i], tokenIds[i])
            );
        }
    }

    /**
     * @notice get avatar infos by tile sets start by start coordinate and range by width and height
     * @param startCoordinate start tile coordinate
     * @param width range width
     * @param height range height
     */
    function getAvatarsByCoordinateRange(
        uint32 startCoordinate,
        int32 width,
        int32 height
    ) public view returns (AvatarDataOutput[] memory avatarDatas) {
        uint32 coordinate = startCoordinate;
        uint256 widthabs = SignedMath.abs(width);
        uint256 heightabs = SignedMath.abs(height);
        avatarDatas = new AvatarDataOutput[](widthabs * heightabs);
        for (uint256 i = 0; i < heightabs; i++) {
            for (uint256 j = 0; j < widthabs; j++) {
                avatarDatas[i * widthabs + j] = getAvatarByAvatarId(
                    map.getTileAvatar(coordinate)
                );
                avatarDatas[i * widthabs + j].tileCoordinate = coordinate;
                coordinate = width > 0
                    ? TileMath.neighbor(coordinate, (j % 2 == 0 ? 5 : 0))
                    : TileMath.neighbor(coordinate, (j % 2 == 0 ? 3 : 2));
            }
            startCoordinate = TileMath.neighbor(
                startCoordinate,
                height > 0 ? 1 : 4
            );
            coordinate = startCoordinate;
        }
    }

    /**
     * @notice get avatar infos by tile sets start by start coordinate and end by end coordinates
     * @param startCoordinate start tile coordinate
     * @param endCoordinate end tile coordinate
     */
    function getAvatarsByStartEndCoordinate(
        uint32 startCoordinate,
        uint32 endCoordinate
    ) public view returns (AvatarDataOutput[] memory avatarDatas) {
        TileMath.XYCoordinate memory startxy = TileMath.coordinateToXY(
            startCoordinate
        );
        TileMath.XYCoordinate memory endxy = TileMath.coordinateToXY(
            endCoordinate
        );
        int32 width = endxy.x - startxy.x;
        int32 height;
        if (width > 0) {
            height = startxy.y - (width / 2) - endxy.y;
            width += 1;
        } else {
            height = startxy.y + (width / 2) - endxy.y;
            width -= 1;
        }

        return getAvatarsByCoordinateRange(startCoordinate, width, height);
    }

    /**
     * @notice get avatars by coordinate array
     * @param coordinates array of coordinates
     * @return avatarDatas avatar datas format struct AvatarDataOutput
     */
    function getAvatarsByCoordinates(
        uint32[] memory coordinates
    ) public view returns (AvatarDataOutput[] memory avatarDatas) {
        avatarDatas = new AvatarDataOutput[](coordinates.length);
        for (uint256 i = 0; i < coordinates.length; i++) {
            avatarDatas[i] = getAvatarByAvatarId(
                map.getTileAvatar(coordinates[i])
            );
        }
    }
}
