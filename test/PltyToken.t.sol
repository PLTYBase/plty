// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {PltyToken} from "../src/PltyToken.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

/// @dev A trivial V2 used to prove the proxy can be upgraded (rules changed) later.
contract PltyTokenV2 is PltyToken {
    function version() external pure returns (string memory) {
        return "v2";
    }
}

contract PltyTokenTest is Test {
    PltyToken internal token;
    address internal owner = address(0xA11CE);
    address internal alice = address(0xBEEF);

    function setUp() public {
        PltyToken impl = new PltyToken();
        bytes memory initData =
            abi.encodeCall(PltyToken.initialize, ("Kamohashi", "PLTY", 1_000_000_000, "ipfs://initial", owner));
        ERC1967Proxy proxy = new ERC1967Proxy(address(impl), initData);
        token = PltyToken(address(proxy));
    }

    function test_metadata() public view {
        assertEq(token.name(), "Kamohashi");
        assertEq(token.symbol(), "PLTY");
        assertEq(token.decimals(), 18);
    }

    function test_supplyMintedToOwner() public view {
        uint256 expected = 1_000_000_000 * 1e18;
        assertEq(token.totalSupply(), expected);
        assertEq(token.balanceOf(owner), expected);
    }

    function test_initializeCannotRunTwice() public {
        vm.expectRevert();
        token.initialize("X", "X", 1, "x", owner);
    }

    function test_metadataURI_initial() public view {
        assertEq(token.metadataURI(), "ipfs://initial");
    }

    function test_setMetadataURI_byOwner() public {
        vm.prank(owner);
        token.setMetadataURI("ipfs://updated");
        assertEq(token.metadataURI(), "ipfs://updated");
    }

    function test_setMetadataURI_revertsForNonOwner() public {
        vm.prank(alice);
        vm.expectRevert();
        token.setMetadataURI("ipfs://hacked");
    }

    function test_ownerCanMintMore() public {
        vm.prank(owner);
        token.mint(alice, 1_000 ether);
        assertEq(token.balanceOf(alice), 1_000 ether);
        assertEq(token.totalSupply(), 1_000_000_000 * 1e18 + 1_000 ether);
    }

    function test_mint_revertsForNonOwner() public {
        vm.prank(alice);
        vm.expectRevert();
        token.mint(alice, 1 ether);
    }

    function test_holderCanBurn() public {
        vm.prank(owner);
        token.transfer(alice, 100 ether);
        vm.prank(alice);
        token.burn(40 ether);
        assertEq(token.balanceOf(alice), 60 ether);
    }

    function test_ownerCanUpgrade_statePreserved() public {
        PltyTokenV2 v2 = new PltyTokenV2();
        vm.prank(owner);
        token.upgradeToAndCall(address(v2), "");
        // new behaviour available...
        assertEq(PltyTokenV2(address(token)).version(), "v2");
        // ...and existing state preserved through the proxy.
        assertEq(token.symbol(), "PLTY");
        assertEq(token.balanceOf(owner), 1_000_000_000 * 1e18);
    }

    function test_upgrade_revertsForNonOwner() public {
        PltyTokenV2 v2 = new PltyTokenV2();
        vm.prank(alice);
        vm.expectRevert();
        token.upgradeToAndCall(address(v2), "");
    }

    function test_renounceFreezesEverything() public {
        vm.prank(owner);
        token.renounceOwnership();
        assertEq(token.owner(), address(0));
        // after renounce: cannot mint, cannot change metadata, cannot upgrade
        vm.startPrank(owner);
        vm.expectRevert();
        token.mint(owner, 1);
        vm.expectRevert();
        token.setMetadataURI("ipfs://x");
        vm.stopPrank();
    }
}
