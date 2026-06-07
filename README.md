# 🦆 Kamohashi ($PLTY)

> The world's weirdest mammal — now the world's weirdest coin.
> An egg-laying, venomous, bridge-loving platypus, live as an **upgradeable ERC-20** on **Base**.

This repo manages everything for the PLTY token: **contract / deploy / metadata / website / launch playbook** in one place.

---

## Why Base

- Best fit for "**change things later**" + "**manage the source in Git**" → a custom ERC-20 fully owned in Foundry.
- Coinbase ecosystem, low fees, fast. Auto-indexed on DEX Screener the moment a pool is created.
- Bonus: platypus = **Bridge** = **Base**. The pun writes itself.

## What's changeable (this build is fully flexible)

PLTY is deployed behind a **UUPS proxy** with an owner-only `mint()`. By design, the owner can:

| Capability | How |
|---|---|
| ➕ **Increase supply** | `mint(to, amount)` — add tokens anytime |
| 🔧 **Change the rules / logic** | `upgradeToAndCall(newImpl)` — swap the implementation; balances are preserved |
| 🖼️ **Update metadata** | `setMetadataURI()` — logo / description / socials |
| 🧊 **Freeze it all, permanently** | `renounceOwnership()` — once owner = 0, nothing can change again |
| 🟢 **Brand layer** (off-chain) | Edit `web/`, `metadata/`, `docs/` in Git anytime |

> The **proxy address is the token address** users hold. The implementation behind it can be swapped; state (balances, supply) lives in the proxy.

## ⚠️ The trust trade-off — read this

An upgradeable + mintable token is the most flexible option, but tools like **Token Sniffer / honeypot.is flag it as "rug risk,"** because the owner *could* mint or rewrite the rules. That scares buyers and can slow down a launch.

You chose flexibility — here's how to keep it **and** rebuild trust:

1. **Move ownership to a Timelock + multisig (e.g. Safe).** Then no single key can mint/upgrade instantly, and every change is announced on-chain in advance. This is the single biggest trust win for an upgradeable token.
2. **Be loud about it.** Pin the policy: "upgrades go through a 48h timelock + 3/5 multisig."
3. **`renounceOwnership()` when you no longer need changes** — flips PLTY to fully immutable and clears the rug-risk flags for good.

## Repository layout

```
.
├── token.config.json      ★ Single source of truth for params (name/symbol/supply/owner)
├── src/PltyToken.sol       UUPS-upgradeable ERC20 (+ Permit, Burnable, mint, metadata)
├── script/Deploy.s.sol     Deploys implementation + ERC1967 proxy, runs initialize()
├── test/PltyToken.t.sol    Tests: supply, mint, upgrade, renounce, permissions
├── metadata/token.json     Metadata for CoinGecko/CMC/DexScreener
├── web/index.html          Landing page (host free on GitHub Pages / Vercel)
├── docs/
│   ├── LAUNCH_PLAYBOOK.md   ← Shortest path to launch on a $350 budget (read this first)
│   └── TOKENOMICS.md
└── memes/                  Meme assets
```

## Quickstart

```bash
# 1. Foundry
curl -L https://foundry.paradigm.xyz | bash && foundryup

# 2. Dependencies
forge install OpenZeppelin/openzeppelin-contracts OpenZeppelin/openzeppelin-contracts-upgradeable foundry-rs/forge-std

# 3. Test
forge test -vv

# 4. Deploy (full steps in docs/LAUNCH_PLAYBOOK.md)
cp .env.example .env          # fill in PRIVATE_KEY / BASESCAN_API_KEY
#   set "owner" in token.config.json to your deployer address (or a multisig)
forge script script/Deploy.s.sol --rpc-url base_sepolia --broadcast --verify   # testnet first
forge script script/Deploy.s.sol --rpc-url base --broadcast --verify           # mainnet
```

→ Use the printed **Proxy** address as the token. Put it in `web/index.html` and `metadata/token.json`.

## Changing things after launch

| What to change | How |
|---|---|
| Supply | `mint(to, amount)` (owner) |
| Rules / logic | Write a new implementation, `upgradeToAndCall` (owner) |
| Logo / description / socials | Edit `metadata/token.json`, re-upload to IPFS, `setMetadataURI` |
| Website / docs / brand | Edit `web/` and `docs/` |
| Lock everything forever | `renounceOwnership()` |

## ⚠️ Disclaimer

$PLTY is a meme coin — a party, not an investment vehicle. Not financial advice. $350 does not move the price (people and hype do). Never put in more than you can afford to lose.

## License

MIT
