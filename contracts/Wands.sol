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
        bytes memory randomizer = abi.encodePacked(block.difficulty, block.timestamp, Strings.toString(currentCounter));
        wands[currentCounter] = Wand(
            uint8(uint256(keccak256(abi.encodePacked('fire', randomizer)))),
            uint8(uint256(keccak256(abi.encodePacked('frost', randomizer)))),
            uint8(uint256(keccak256(abi.encodePacked('arcane', randomizer)))),
            uint8(uint256(keccak256(abi.encodePacked('style', randomizer))))
        );
        _tokenIdCounter.increment();
    }

    function getWand(uint256 tokenId) public view returns (Wand memory) {
        return wands[tokenId];
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
