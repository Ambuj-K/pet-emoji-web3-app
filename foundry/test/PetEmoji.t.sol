// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/PetEmoji.sol";

contract PetEmojiTest is DSTest {
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
        ) = pe.petStats(0);
        assertEq(elation, (food_level + boredom_level) / 2);
        assertEq(food_level, 100);
        assertEq(entertained_level, 100);
        assertEq(checked, block.timestamp);
    }

    // passtime
    function testPassTime() public {
        eg.passTime(0);
        (uint256 elation, uint256 fed_level, uint256 entertained_level, , ) = pe
            .petEmojiStats(0);
        assertEq(fed_level, 90);
        assertEq(entertained_level, 90);
        assertEq(elation, (90 + 90) / 2);
    }   

    // feed

    // play

    // image

    // check upkeep

    //  perform upkeep 

}
