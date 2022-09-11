// SPDX-License-Identifier: MIT
pragma solidity >=0.8.9;

import "forge-std/Test.sol";
import "../src/PetEmoji.sol";

interface CheatCodes {
    function warp(uint256) external;
}

contract PetEmojiTest is DSTest {
    CheatCodes constant cheats = CheatCodes(HEVM_ADDRESS);

    PetEmoji public pe;
    //run before every test
    // - assign contract
    // - mint
    // - create address

    function setUp() public {
        pe = new PetEmoji();
        address addr = 0x1234567890123456789012345678901234567890;
        pe.safeMint(addr);
    }

    // mint
    function testMint() public {
        address addr = 0x1234567890123456789012345678901234567890;
        address owner = pe.ownerOf(0);
        assertEq(addr, owner);
    }

    // uri
    function testUri() public {
        //elation, fed_level, entertained_level, checked, image
        (
            uint elation, 
            uint fed_level, 
            uint entertained_level, 
            uint checked, 
            string memory image
        ) = pe.petEmojiStats(0);
        assertEq(elation, (fed_level + entertained_level) / 2);
        assertEq(fed_level, 100);
        assertEq(entertained_level, 100);
        assertEq(checked, block.timestamp);
    }

    // passtime
    function testPassTime() public {
        pe.passTime(0);
        (uint256 elation, uint256 fed_level, uint256 entertained_level, , ) = pe
            .petEmojiStats(0);
        assertEq(fed_level, 90);
        assertEq(entertained_level, 90);
        assertEq(elation, (90 + 90) / 2);
    }   

    // feed
    function testFeed() public {
        pe.passTime(0);
        pe.feed();
        (uint256 elation, uint256 fed_level, , , ) = pe.petEmojiStats(0);
        assertEq(fed_level, 100);
        assertEq(elation, (100 + 90) / 2);
    }

    // play
    function testPlay() public {
        pe.passTime(0);
        pe.play();
        (uint256 elation, , uint256 entertained_level, , ) = pe.petEmojiStats(0);
        assertEq(entertained_level, 100);
        assertEq(elation, (90 + 100) / 2);
    }

    // image
    function testImgURI() public {
        string memory tokenURI = "";
        (, , , , tokenURI) = pe.petEmojiStats(0);
        string memory firstURI = tokenURI;
        pe.passTime(0);
        pe.passTime(0);
        pe.passTime(0);
        (, , , , tokenURI) = pe.petEmojiStats(0);
        string memory secondURI = tokenURI;
        console.log(secondURI);
        console.log(firstURI);
        assertTrue(compareStringsNot(firstURI, secondURI));
    }

    // check upkeep
    function testCheckUpkeep() public {
        bytes memory data = "";
        bool upkeepNeeded = false;
        (upkeepNeeded, ) = pe.checkUpkeep(data);
        assertTrue(upkeepNeeded == false);
        cheats.warp(block.timestamp + 100);
        (upkeepNeeded, ) = pe.checkUpkeep(data);
        assertTrue(upkeepNeeded);
    }

    // perform upkeep
    function testPerformUpkeep() public {
        bytes memory data = "";
        cheats.warp(block.timestamp + 100);
        pe.performUpkeep(data);
        (uint256 elation, uint256 fed_level, uint256 entertained_level, , ) = pe
            .petEmojiStats(0);
        assertEq(fed_level, 90);
        assertEq(entertained_level, 90);
        assertEq(elation, (90 + 90) / 2);
    }

    // string compare
    function compareStringsNot(string memory a, string memory b) public pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) != keccak256(abi.encodePacked((b))));
    }

}
