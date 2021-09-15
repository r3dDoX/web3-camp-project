//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "base64-sol/base64.sol";

contract Wands is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    string[] colors = [
    "#000000",
    "#800000",
    "#008000",
    "#808000",
    "#000080",
    "#800080",
    "#008080",
    "#c0c0c0",
    "#808080",
    "#ff0000",
    "#00ff00",
    "#ffff00",
    "#0000ff",
    "#ff00ff",
    "#00ffff",
    "#ffffff",
    "#000000",
    "#00005f",
    "#000087",
    "#0000af",
    "#0000d7",
    "#0000ff",
    "#005f00",
    "#005f5f",
    "#005f87",
    "#005faf",
    "#005fd7",
    "#005fff",
    "#008700",
    "#00875f",
    "#008787",
    "#0087af",
    "#0087d7",
    "#0087ff",
    "#00af00",
    "#00af5f",
    "#00af87",
    "#00afaf",
    "#00afd7",
    "#00afff",
    "#00d700",
    "#00d75f",
    "#00d787",
    "#00d7af",
    "#00d7d7",
    "#00d7ff",
    "#00ff00",
    "#00ff5f",
    "#00ff87",
    "#00ffaf",
    "#00ffd7",
    "#00ffff",
    "#5f0000",
    "#5f005f",
    "#5f0087",
    "#5f00af",
    "#5f00d7",
    "#5f00ff",
    "#5f5f00",
    "#5f5f5f",
    "#5f5f87",
    "#5f5faf",
    "#5f5fd7",
    "#5f5fff",
    "#5f8700",
    "#5f875f",
    "#5f8787",
    "#5f87af",
    "#5f87d7",
    "#5f87ff",
    "#5faf00",
    "#5faf5f",
    "#5faf87",
    "#5fafaf",
    "#5fafd7",
    "#5fafff",
    "#5fd700",
    "#5fd75f",
    "#5fd787",
    "#5fd7af",
    "#5fd7d7",
    "#5fd7ff",
    "#5fff00",
    "#5fff5f",
    "#5fff87",
    "#5fffaf",
    "#5fffd7",
    "#5fffff",
    "#870000",
    "#87005f",
    "#870087",
    "#8700af",
    "#8700d7",
    "#8700ff",
    "#875f00",
    "#875f5f",
    "#875f87",
    "#875faf",
    "#875fd7",
    "#875fff",
    "#878700",
    "#87875f",
    "#878787",
    "#8787af",
    "#8787d7",
    "#8787ff",
    "#87af00",
    "#87af5f",
    "#87af87",
    "#87afaf",
    "#87afd7",
    "#87afff",
    "#87d700",
    "#87d75f",
    "#87d787",
    "#87d7af",
    "#87d7d7",
    "#87d7ff",
    "#87ff00",
    "#87ff5f",
    "#87ff87",
    "#87ffaf",
    "#87ffd7",
    "#87ffff",
    "#af0000",
    "#af005f",
    "#af0087",
    "#af00af",
    "#af00d7",
    "#af00ff",
    "#af5f00",
    "#af5f5f",
    "#af5f87",
    "#af5faf",
    "#af5fd7",
    "#af5fff",
    "#af8700",
    "#af875f",
    "#af8787",
    "#af87af",
    "#af87d7",
    "#af87ff",
    "#afaf00",
    "#afaf5f",
    "#afaf87",
    "#afafaf",
    "#afafd7",
    "#afafff",
    "#afd700",
    "#afd75f",
    "#afd787",
    "#afd7af",
    "#afd7d7",
    "#afd7ff",
    "#afff00",
    "#afff5f",
    "#afff87",
    "#afffaf",
    "#afffd7",
    "#afffff",
    "#d70000",
    "#d7005f",
    "#d70087",
    "#d700af",
    "#d700d7",
    "#d700ff",
    "#d75f00",
    "#d75f5f",
    "#d75f87",
    "#d75faf",
    "#d75fd7",
    "#d75fff",
    "#d78700",
    "#d7875f",
    "#d78787",
    "#d787af",
    "#d787d7",
    "#d787ff",
    "#d7af00",
    "#d7af5f",
    "#d7af87",
    "#d7afaf",
    "#d7afd7",
    "#d7afff",
    "#d7d700",
    "#d7d75f",
    "#d7d787",
    "#d7d7af",
    "#d7d7d7",
    "#d7d7ff",
    "#d7ff00",
    "#d7ff5f",
    "#d7ff87",
    "#d7ffaf",
    "#d7ffd7",
    "#d7ffff",
    "#ff0000",
    "#ff005f",
    "#ff0087",
    "#ff00af",
    "#ff00d7",
    "#ff00ff",
    "#ff5f00",
    "#ff5f5f",
    "#ff5f87",
    "#ff5faf",
    "#ff5fd7",
    "#ff5fff",
    "#ff8700",
    "#ff875f",
    "#ff8787",
    "#ff87af",
    "#ff87d7",
    "#ff87ff",
    "#ffaf00",
    "#ffaf5f",
    "#ffaf87",
    "#ffafaf",
    "#ffafd7",
    "#ffafff",
    "#ffd700",
    "#ffd75f",
    "#ffd787",
    "#ffd7af",
    "#ffd7d7",
    "#ffd7ff",
    "#ffff00",
    "#ffff5f",
    "#ffff87",
    "#ffffaf",
    "#ffffd7",
    "#ffffff",
    "#080808",
    "#121212",
    "#1c1c1c",
    "#262626",
    "#303030",
    "#3a3a3a",
    "#444444",
    "#4e4e4e",
    "#585858",
    "#626262",
    "#6c6c6c",
    "#767676",
    "#808080",
    "#8a8a8a",
    "#949494",
    "#9e9e9e",
    "#a8a8a8",
    "#b2b2b2",
    "#bcbcbc",
    "#c6c6c6",
    "#d0d0d0",
    "#dadada",
    "#e4e4e4",
    "#eeeeee"
    ];

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

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        Wand memory wand = getWand(tokenId);

        string[9] memory parts;
        parts[0] = '<svg width="100" height="100" viewBox="0 0 100 100" version="1.1" id="svg1833" xmlns="http://www.w3.org/2000/svg"><rect style="fill:';
        parts[1] = colors[wand.style];
        parts[2] = '" width="100" height="100" x="0" y="0" /><circle style="fill:';
        parts[3] = colors[wand.arcane];
        parts[4] = '" r="40" cx="50" cy="50" /><rect style="fill:';
        parts[5] = colors[wand.fire];
        parts[6] = '" width="45" height="10" x="20" y="45" /><rect style="fill:';
        parts[7] = colors[wand.frost];
        parts[8] = '" width="15" height="10" x="65" y="45" /></svg>';

        string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7], parts[8]));
        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "WAND #', Strings.toString(tokenId), '", "description": "Enjoy your magic wand token!", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        return string(abi.encodePacked('data:application/json;base64,', json));
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
