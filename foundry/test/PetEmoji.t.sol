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
        //elation, food_level, enrichment, checked, image
        (
            uint elation, 
            uint food_level, 
            uint enrichment, 
            uint checked, 
            string memory image
        ) = pe.petStats(0);
    }

    // passtime

    // feed

    // play

    // image

    // check upkeep

    //  perform upkeep 

}
