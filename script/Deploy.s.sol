// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {PltyToken} from "../src/PltyToken.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

/**
 * Deploys the UUPS-upgradeable PLTY:
 *   1) deploy the implementation (logic) contract
 *   2) deploy an ERC1967 proxy pointing at it, calling initialize() once
 *
 * The PROXY address is the token address — give that to DEXes, explorers, users.
 * Parameters come from token.config.json (edit config, not code).
 *
 * Usage:
 *   forge script script/Deploy.s.sol --rpc-url base_sepolia --broadcast --verify   # testnet
 *   forge script script/Deploy.s.sol --rpc-url base --broadcast --verify           # mainnet
 */
contract Deploy is Script {
    function run() external returns (address proxy, address implementation) {
        string memory cfg = vm.readFile("token.config.json");

        string memory name_ = vm.parseJsonString(cfg, ".name");
        string memory symbol_ = vm.parseJsonString(cfg, ".symbol");
        uint256 supply_ = vm.parseJsonUint(cfg, ".totalSupply");
        string memory metadataURI_ = vm.parseJsonString(cfg, ".initialMetadataURI");
        address owner_ = vm.parseJsonAddress(cfg, ".owner");

        uint256 pk = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(pk);
        PltyToken impl = new PltyToken();
        bytes memory initData =
            abi.encodeCall(PltyToken.initialize, (name_, symbol_, supply_, metadataURI_, owner_));
        ERC1967Proxy proxyContract = new ERC1967Proxy(address(impl), initData);
        vm.stopBroadcast();

        proxy = address(proxyContract);
        implementation = address(impl);

        console.log("PLTY (Kamohashi)");
        console.log("  Proxy  (= token address, use this):", proxy);
        console.log("  Impl   (logic, swappable)         :", implementation);
        console.log("  Owner  (mint/upgrade authority)   :", owner_);
        console.log("  Supply (whole)                    :", supply_);
    }
}
