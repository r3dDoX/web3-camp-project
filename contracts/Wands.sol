//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Wands is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    struct Wand {
        uint8 fire;
        uint8 frost;
        uint8 arcane;
        uint8 style;
    }

    mapping(uint256 => Wand) wands;

    constructor() ERC721("Wand", "WAND") {}

    function safeMint(address to) public {
        uint256 currentCounter = _tokenIdCounter.current();
        _safeMint(to, currentCounter);
        string memory counterText = Strings.toString(currentCounter);
        wands[currentCounter] = Wand(
            uint8(uint256(keccak256(abi.encodePacked('fire', counterText)))),
            uint8(uint256(keccak256(abi.encodePacked('frost', counterText)))),
            uint8(uint256(keccak256(abi.encodePacked('arcane', counterText)))),
            uint8(uint256(keccak256(abi.encodePacked('style', counterText))))
        );
        _tokenIdCounter.increment();
    }

    function getWand(uint256 tokenId) public view returns (Wand memory) {
        return wands[tokenId];
    }

    function compare(uint256 attackerTokenId, uint256 defenderTokenId, string memory trait) public {
        require(_exists(attackerTokenId), "ERC721Metadata: URI query for nonexistent attackerTokenId");
        require(_exists(defenderTokenId), "ERC721Metadata: URI query for nonexistent defenderTokenId");

        address attackerOwnerAddress = ERC721.ownerOf(attackerTokenId);
        address defenderOwnerAddress = ERC721.ownerOf(defenderTokenId);

        uint8 attackerTraitValue = getTraitValue(attackerTokenId, trait);
        uint8 defenderTraitValue = getTraitValue(defenderTokenId, trait);

        if (attackerTraitValue >= defenderTraitValue) {
            ERC721.transferFrom(defenderOwnerAddress, attackerOwnerAddress, defenderTokenId);
        } else {
            ERC721.transferFrom(attackerOwnerAddress, defenderOwnerAddress, attackerTokenId);
        }
    }

    function getTraitValue(uint256 tokenId, string memory trait) public view returns (uint8) {
        Wand memory wand = getWand(tokenId);

        if (stringEquals(trait, "fire")) {
            return wand.fire;
        }

        if (stringEquals(trait, "frost")) {
            return wand.frost;
        }

        if (stringEquals(trait, "arcane")) {
            return wand.arcane;
        }

        return wand.style;
    }

    function stringEquals(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
    internal
    override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721, ERC721Enumerable)
    returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
