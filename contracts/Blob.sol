//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

contract Blob {
    uint256[] private _allTokens;

    function claim(uint256 tokenClaim) public {
        _allTokens.push(tokenClaim);
    }

    function getTokenAtIndex(uint256 index) public view returns (uint256) {
        return _allTokens[index];
    }
}
