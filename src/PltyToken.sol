// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {ERC20BurnableUpgradeable} from
    "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import {ERC20PermitUpgradeable} from
    "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PermitUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
 * @title Kamohashi (PLTY) — UUPS upgradeable
 * @notice A meme token on Base, deployed behind a UUPS proxy so the rules can
 *         be changed later, and with an owner-only mint so supply can grow.
 *
 * WHAT IS CHANGEABLE (by design — chosen for maximum flexibility):
 *   - Supply: owner can mint() more at any time.
 *   - Rules / logic: owner can upgrade the implementation (upgradeToAndCall).
 *   - Metadata: owner can setMetadataURI().
 *
 * TRUST TRADE-OFF (read this):
 *   An upgradeable + mintable token is flagged as "rug risk" by Token Sniffer /
 *   honeypot.is, which scares buyers. To win back trust WITHOUT giving up
 *   flexibility, move ownership to a Timelock and/or a multisig (e.g. Safe) so
 *   no single key can mint or upgrade instantly and every change is announced
 *   on-chain in advance. When you no longer need changes, renounceOwnership()
 *   freezes everything forever.
 *
 *   The PROXY address is the token address users hold. The implementation
 *   behind it can be swapped; state (balances, supply) lives in the proxy.
 */
contract PltyToken is
    Initializable,
    ERC20Upgradeable,
    ERC20BurnableUpgradeable,
    ERC20PermitUpgradeable,
    OwnableUpgradeable,
    UUPSUpgradeable
{
    /// @notice Pointer to off-chain metadata JSON (e.g. IPFS).
    string private _metadataURI;

    event MetadataURIUpdated(string oldURI, string newURI);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @notice Runs once, through the proxy, at deploy time (replaces the constructor).
     * @param name_         Token name (e.g. "Kamohashi")
     * @param symbol_       Symbol (e.g. "PLTY")
     * @param totalSupply_  Initial supply in whole tokens (decimals applied internally)
     * @param metadataURI_  Initial metadata URI (e.g. "ipfs://...")
     * @param owner_        Initial owner (mint/upgrade authority) and supply recipient
     */
    function initialize(
        string memory name_,
        string memory symbol_,
        uint256 totalSupply_,
        string memory metadataURI_,
        address owner_
    ) public initializer {
        __ERC20_init(name_, symbol_);
        __ERC20Burnable_init();
        __ERC20Permit_init(name_);
        __Ownable_init(owner_);

        _metadataURI = metadataURI_;
        _mint(owner_, totalSupply_ * 10 ** decimals());
    }

    /// @notice Mint more supply. Owner only. (Supply is expandable by design.)
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    /// @notice Current metadata URI.
    function metadataURI() external view returns (string memory) {
        return _metadataURI;
    }

    /// @notice Swap the metadata URI (logo/description/socials). Owner only.
    function setMetadataURI(string calldata newURI) external onlyOwner {
        emit MetadataURIUpdated(_metadataURI, newURI);
        _metadataURI = newURI;
    }

    /// @dev UUPS: only the owner may upgrade the implementation (the "change the rules" switch).
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
