// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";

contract PetEmoji is ERC721, ERC721URIStorage, KeeperCompatibleInterface {
    event EmojiUpdated(
        uint256 elation,
        uint256 fed_level,
        uint256 entertained_level,
        uint256 checked,
        string uri,
        uint256 index
    );

    struct PetEmojiAttributes {
        uint256 petEmojiIndex;
        string imageURI;
        uint256 elation;
        uint256 fed_level;
        uint256 entertained_level;
        uint256 lastChecked;
    }
    using Counters for Counters.Counter;

    string SVGBase =
        "data:image/svg+xml;base64,PHN2ZyB4bWxucz0naHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmcnIHdpZHRoPScxMDAlJyBoZWlnaHQ9JzEwMCUnIHZpZXdCb3g9JzAgMCA4MDAgODAwJz48cmVjdCBmaWxsPScjZmZmZmZmJyB3aWR0aD0nODAwJyBoZWlnaHQ9JzgwMCcvPjxkZWZzPjxyYWRpYWxHcmFkaWVudCBpZD0nYScgY3g9JzQwMCcgY3k9JzQwMCcgcj0nNTAuMSUnIGdyYWRpZW50VW5pdHM9J3VzZXJTcGFjZU9uVXNlJz48c3RvcCAgb2Zmc2V0PScwJyBzdG9wLWNvbG9yPScjZmZmZmZmJy8+PHN0b3AgIG9mZnNldD0nMScgc3RvcC1jb2xvcj0nIzBFRicvPjwvcmFkaWFsR3JhZGllbnQ+PHJhZGlhbEdyYWRpZW50IGlkPSdiJyBjeD0nNDAwJyBjeT0nNDAwJyByPSc1MC40JScgZ3JhZGllbnRVbml0cz0ndXNlclNwYWNlT25Vc2UnPjxzdG9wICBvZmZzZXQ9JzAnIHN0b3AtY29sb3I9JyNmZmZmZmYnLz48c3RvcCAgb2Zmc2V0PScxJyBzdG9wLWNvbG9yPScjMEZGJy8+PC9yYWRpYWxHcmFkaWVudD48L2RlZnM+PHJlY3QgZmlsbD0ndXJsKCNhKScgd2lkdGg9JzgwMCcgaGVpZ2h0PSc4MDAnLz48ZyBmaWxsLW9wYWNpdHk9JzAuNSc+PHBhdGggZmlsbD0ndXJsKCNiKScgZD0nTTk5OC43IDQzOS4yYzEuNy0yNi41IDEuNy01Mi43IDAuMS03OC41TDQwMSAzOTkuOWMwIDAgMC0wLjEgMC0wLjFsNTg3LjYtMTE2LjljLTUuMS0yNS45LTExLjktNTEuMi0yMC4zLTc1LjhMNDAwLjkgMzk5LjdjMCAwIDAtMC4xIDAtMC4xbDUzNy4zLTI2NWMtMTEuNi0yMy41LTI0LjgtNDYuMi0zOS4zLTY3LjlMNDAwLjggMzk5LjVjMCAwIDAtMC4xLTAuMS0wLjFsNDUwLjQtMzk1Yy0xNy4zLTE5LjctMzUuOC0zOC4yLTU1LjUtNTUuNWwtMzk1IDQ1MC40YzAgMC0wLjEgMC0wLjEtMC4xTDczMy40LTk5Yy0yMS43LTE0LjUtNDQuNC0yNy42LTY4LTM5LjNsLTI2NSA1MzcuNGMwIDAtMC4xIDAtMC4xIDBsMTkyLjYtNTY3LjRjLTI0LjYtOC4zLTQ5LjktMTUuMS03NS44LTIwLjJMNDAwLjIgMzk5YzAgMC0wLjEgMC0wLjEgMGwzOS4yLTU5Ny43Yy0yNi41LTEuNy01Mi43LTEuNy03OC41LTAuMUwzOTkuOSAzOTljMCAwLTAuMSAwLTAuMSAwTDI4Mi45LTE4OC42Yy0yNS45IDUuMS01MS4yIDExLjktNzUuOCAyMC4zbDE5Mi42IDU2Ny40YzAgMC0wLjEgMC0wLjEgMGwtMjY1LTUzNy4zYy0yMy41IDExLjYtNDYuMiAyNC44LTY3LjkgMzkuM2wzMzIuOCA0OTguMWMwIDAtMC4xIDAtMC4xIDAuMUw0LjQtNTEuMUMtMTUuMy0zMy45LTMzLjgtMTUuMy01MS4xIDQuNGw0NTAuNCAzOTVjMCAwIDAgMC4xLTAuMSAwLjFMLTk5IDY2LjZjLTE0LjUgMjEuNy0yNy42IDQ0LjQtMzkuMyA2OGw1MzcuNCAyNjVjMCAwIDAgMC4xIDAgMC4xbC01NjcuNC0xOTIuNmMtOC4zIDI0LjYtMTUuMSA0OS45LTIwLjIgNzUuOEwzOTkgMzk5LjhjMCAwIDAgMC4xIDAgMC4xbC01OTcuNy0zOS4yYy0xLjcgMjYuNS0xLjcgNTIuNy0wLjEgNzguNUwzOTkgNDAwLjFjMCAwIDAgMC4xIDAgMC4xbC01ODcuNiAxMTYuOWM1LjEgMjUuOSAxMS45IDUxLjIgMjAuMyA3NS44bDU2Ny40LTE5Mi42YzAgMCAwIDAuMSAwIDAuMWwtNTM3LjMgMjY1YzExLjYgMjMuNSAyNC44IDQ2LjIgMzkuMyA2Ny45bDQ5OC4xLTMzMi44YzAgMCAwIDAuMSAwLjEgMC4xbC00NTAuNCAzOTVjMTcuMyAxOS43IDM1LjggMzguMiA1NS41IDU1LjVsMzk1LTQ1MC40YzAgMCAwLjEgMCAwLjEgMC4xTDY2LjYgODk5YzIxLjcgMTQuNSA0NC40IDI3LjYgNjggMzkuM2wyNjUtNTM3LjRjMCAwIDAuMSAwIDAuMSAwTDIwNy4xIDk2OC4zYzI0LjYgOC4zIDQ5LjkgMTUuMSA3NS44IDIwLjJMMzk5LjggNDAxYzAgMCAwLjEgMCAwLjEgMGwtMzkuMiA1OTcuN2MyNi41IDEuNyA1Mi43IDEuNyA3OC41IDAuMUw0MDAuMSA0MDFjMCAwIDAuMSAwIDAuMSAwbDExNi45IDU4Ny42YzI1LjktNS4xIDUxLjItMTEuOSA3NS44LTIwLjNMNDAwLjMgNDAwLjljMCAwIDAuMSAwIDAuMSAwbDI2NSA1MzcuM2MyMy41LTExLjYgNDYuMi0yNC44IDY3LjktMzkuM0w0MDAuNSA0MDAuOGMwIDAgMC4xIDAgMC4xLTAuMWwzOTUgNDUwLjRjMTkuNy0xNy4zIDM4LjItMzUuOCA1NS41LTU1LjVsLTQ1MC40LTM5NWMwIDAgMC0wLjEgMC4xLTAuMUw4OTkgNzMzLjRjMTQuNS0yMS43IDI3LjYtNDQuNCAzOS4zLTY4bC01MzcuNC0yNjVjMCAwIDAtMC4xIDAtMC4xbDU2Ny40IDE5Mi42YzguMy0yNC42IDE1LjEtNDkuOSAyMC4yLTc1LjhMNDAxIDQwMC4yYzAgMCAwLTAuMSAwLTAuMUw5OTguNyA0MzkuMnonLz48L2c+PHRleHQgeD0nNTAlJyB5PSc1MCUnIGNsYXNzPSdiYXNlJyBkb21pbmFudC1iYXNlbGluZT0nbWlkZGxlJyB0ZXh0LWFuY2hvcj0nbWlkZGxlJyBmb250LXNpemU9JzhlbSc+8J+";

    string[] emojiBase64 = [
        "kqTwvdGV4dD48L3N2Zz4=",
        "YgTwvdGV4dD48L3N2Zz4=",
        "YkDwvdGV4dD48L3N2Zz4=",
        "YoTwvdGV4dD48L3N2Zz4=",
        "SgDwvdGV4dD48L3N2Zz4="
    ];

    Counters.Counter private _tokenIdCounter;

    mapping(uint256 => PetEmojiAttributes) public petEmojiHolderAttributes;

    mapping(address => uint256) public petEmojiHolders;

    uint256 interval = 60;

    constructor() ERC721("PetEmoji", "pe") {
        safeMint(msg.sender);
    }

    function safeMint(address to) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        string memory finalSVG = string(
            abi.encodePacked(SVGBase, emojiBase64[0])
        );
        petEmojiHolderAttributes[tokenId] = PetEmojiAttributes({
            petEmojiIndex: tokenId,
            imageURI: finalSVG,
            elation: 100,
            fed_level: 100,
            entertained_level: 100,
            lastChecked: block.timestamp
        });
        petEmojiHolders[msg.sender] = tokenId;
        _setTokenURI(tokenId, tokenURI(tokenId));
    }

    function petEmojiStats(uint256 _tokenId)
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            string memory
        )
    {
        return (
            petEmojiHolderAttributes[_tokenId].elation,
            petEmojiHolderAttributes[_tokenId].fed_level,
            petEmojiHolderAttributes[_tokenId].entertained_level,
            petEmojiHolderAttributes[_tokenId].lastChecked,
            petEmojiHolderAttributes[_tokenId].imageURI
        );
    }

    function myPetEmoji()
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            string memory
        )
    {
        return petEmojiStats(petEmojiHolders[msg.sender]);
    }

    function passTime(uint256 _tokenId) public {
        petEmojiHolderAttributes[_tokenId].fed_level =
            petEmojiHolderAttributes[_tokenId].fed_level -
            10;
        petEmojiHolderAttributes[_tokenId].entertained_level =
            petEmojiHolderAttributes[_tokenId].entertained_level -
            10;
        petEmojiHolderAttributes[_tokenId].elation =
            (petEmojiHolderAttributes[_tokenId].fed_level +
                petEmojiHolderAttributes[_tokenId].entertained_level) /
            2;
        updateURI(_tokenId);
        emitUpdate(_tokenId);
    }
    
    function emitUpdate(uint256 _tokenId) internal {
        emit EmojiUpdated(
            petEmojiHolderAttributes[_tokenId].elation,
            petEmojiHolderAttributes[_tokenId].fed_level,
            petEmojiHolderAttributes[_tokenId].entertained_level,
            petEmojiHolderAttributes[_tokenId].lastChecked,
            petEmojiHolderAttributes[_tokenId].imageURI,
            _tokenId
        );
    }

    function updateURI(uint256 _tokenId) private {
        string memory emojiB64 = emojiBase64[0];
        if (petEmojiHolderAttributes[_tokenId].elation == 100) {
            emojiB64 = emojiBase64[0];
        } else if (petEmojiHolderAttributes[_tokenId].elation > 66) {
            emojiB64 = emojiBase64[1];
        } else if (petEmojiHolderAttributes[_tokenId].elation > 33) {
            emojiB64 = emojiBase64[2];
        } else if (petEmojiHolderAttributes[_tokenId].elation > 0) {
            emojiB64 = emojiBase64[3];
        } else if (petEmojiHolderAttributes[_tokenId].elation == 0) {
            emojiB64 = emojiBase64[4];
        }
        string memory finalSVG = string(abi.encodePacked(SVGBase, emojiB64));
        petEmojiHolderAttributes[_tokenId].imageURI = finalSVG;
        _setTokenURI(_tokenId, tokenURI(_tokenId));
    }

    function feed() public {
        // retrieve the token based on the sender. 
        uint256 _tokenId = petEmojiHolders[msg.sender];
        // update fed_level
        petEmojiHolderAttributes[_tokenId].fed_level = 100;
        // recalculate elation
        petEmojiHolderAttributes[_tokenId].elation =
        (petEmojiHolderAttributes[_tokenId].fed_level +
            petEmojiHolderAttributes[_tokenId].entertained_level) /
        2;
        // update the URI based on new attributes
        updateURI(_tokenId);
        emitUpdate(_tokenId);
    }

    function play() public {
        // retrieve the token based on the sender. 
        uint256 _tokenId = petEmojiHolders[msg.sender];
        // update entertained_level
        petEmojiHolderAttributes[_tokenId].entertained_level = 100;
        // recalculate elation
        petEmojiHolderAttributes[_tokenId].elation =
        (petEmojiHolderAttributes[_tokenId].fed_level +
            petEmojiHolderAttributes[_tokenId].entertained_level) /
        2;
        // update the URI based on new attributes
        updateURI(_tokenId);
        emitUpdate(_tokenId);

    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        PetEmojiAttributes memory petEmojiAttributes = petEmojiHolderAttributes[_tokenId];

        string memory str_elation = Strings.toString(petEmojiAttributes.elation);
        string memory str_fed_level = Strings.toString(petEmojiAttributes.fed_level);
        string memory str_entertained_level = Strings.toString(petEmojiAttributes.entertained_level);

        string memory json = string(
            abi.encodePacked(
                '{"name": "Your Little Emoji Pet",',
                '"description": "Keep your pet happy!",',
                '"image": "',
                petEmojiAttributes.imageURI,
                '",',
                '"traits": [',
                '{"trait_type": "fed_level","value": ',
                str_fed_level,
                '}, {"trait_type": "entertained_level", "value": ',
                str_entertained_level,
                '}, {"trait_type": "elation","value": ',
                str_elation,
                "}]",
                "}"
            )
        );

        string memory output = string(abi.encodePacked(json));
        return output;

    }

    function checkUpkeep(
        bytes calldata /* checkData */
    )
        external
        view
        returns (
            bool upkeepNeeded,
            bytes memory /* performData */
        )
    {
        uint256 lastTimeStamp = petEmojiHolderAttributes[0].lastChecked;
        upkeepNeeded = (petEmojiHolderAttributes[0].elation > 0 &&
            (block.timestamp - lastTimeStamp) > 60);
        // We don't use the checkData in this example. The checkData is defined when the Upkeep was registered.
    }

    function performUpkeep(
        bytes calldata /* performData */
    ) external {
        uint256 lastTimeStamp = petEmojiHolderAttributes[0].lastChecked;

        //We highly recommend revalidating the upkeep in the performUpkeep function

        if (
            petEmojiHolderAttributes[0].elation > 0 &&
            ((block.timestamp - lastTimeStamp) > interval)
        ) {
            petEmojiHolderAttributes[0].lastChecked = block.timestamp;
            passTime(0);
        }
        // We don't use the performData in this example. The performData is generated by the Keeper's call to your checkUpkeep function
    }
}