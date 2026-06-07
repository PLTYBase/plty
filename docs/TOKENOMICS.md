# PLTY Tokenomics

> `token.config.json` is the source of truth for numbers. This file is for the *thinking*.

## Basics

| Item | Value |
|---|---|
| Name | Kamohashi |
| Symbol | PLTY |
| Chain | Base (chainId 8453) |
| Standard | ERC-20, **UUPS upgradeable** (+ Permit / Burnable) |
| Decimals | 18 |
| Initial supply | 1,000,000,000 (1B) |
| Supply policy | **Expandable** — owner can `mint()` more |
| Upgradeable | **Yes** — owner can swap the logic via the proxy |

## Distribution philosophy ($350 launch edition)

With a small budget, **simple = trustworthy**. Complex splits on a thin pool create suspicion.

Recommended minimal setup:

| Use | Supply % | Notes |
|---|---|---|
| Liquidity pool (LP) | 90–100% | Most of supply into the DEX pool. Burn or lock the LP tokens to prove you can't pull it |
| Dev/marketing reserve | 0–10% | Zero is the most trusted. If you keep some, hold it in a public wallet, transparently |

## ⚠️ Because PLTY is mintable + upgradeable, trust needs active work

You picked maximum flexibility. The cost is that auto-scanners flag mintable/upgradeable tokens as rug-risk. Offset it deliberately:

1. **Put the owner behind a Timelock + multisig (Safe).** No instant mint/upgrade; every change is visible in advance. Biggest single trust win.
2. **Publish a supply policy.** e.g. "no mint without a 7-day notice and a community vote," or "mint capped at +X% per year." Put it in this repo and pin it.
3. **`renounceOwnership()` when stable** → flips to fully immutable, clears the flags permanently. Consider committing to a date.

## The trust kit (do right after launch + screenshot it)

1. **Move ownership to a multisig/timelock** (not a hot wallet)
2. **Lock/burn LP** — proof liquidity can't be pulled
3. **Verify contract** on Basescan (proxy + implementation; matches this Git repo)
