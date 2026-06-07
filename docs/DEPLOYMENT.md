# PLTY Deployment Record

## Base mainnet (chainId 8453) — 2026-06-07

| Item | Value |
|---|---|
| **Token (proxy) — use this** | `0xDe129391E97F34609bd1AD414FC5D40d5a7Fb50e` |
| Implementation (logic) | `0x0f032DC529b19C3654050adc4fe04BD2c7Bd0459` |
| Owner (mint/upgrade authority) | **`0x00441BE49ca8Cc23adb17081cdD3D9e330F63A6C`** — Safe 2-of-3 multisig |
| Deployer (original owner, now signer) | `0xc5D7B3E0C2d87938C49bc7A8b73b21a06d63b368` |
| Name / Symbol | Kamohashi / PLTY |
| Decimals | 18 |
| Initial supply | 1,000,000,000 PLTY |
| Standard | ERC-20, UUPS upgradeable (Permit, Burnable, mint) |
| Verified on Basescan | ✅ both proxy + implementation |

**Links**
- Basescan: https://basescan.org/address/0xDe129391E97F34609bd1AD414FC5D40d5a7Fb50e
- DEX Screener (live once a pool exists): https://dexscreener.com/base/0xDe129391E97F34609bd1AD414FC5D40d5a7Fb50e

**Deploy transactions**
- Implementation CREATE: `0x5387814ce49ffb64d34d6a18e18004cc4f8e52a57f21890c3895c0e69eed0868`
- Proxy CREATE: `0x2b876eb2f1f5972ce0152b676ab5f23a9b5739c036cf853adf89f96a65b85bd4`

## Ownership → Safe multisig (done 2026-06-07)

Ownership moved from the deployer to a **2-of-3 Safe** on Base.

- Safe (owner): `0x00441BE49ca8Cc23adb17081cdD3D9e330F63A6C`
- Signers (2-of-3): `0xc5D7…b368`, `0x9A48…C11A`, `0x23F3…A1b4`
- transferOwnership tx: `0x20eeeba555fd9361fb908c2454c0b0b07d62a28be831bcce0df1b681bc4a1dd1`

Any mint / upgrade / setMetadataURI / renounce now requires 2-of-3 signatures via the Safe.

## Liquidity pool (done 2026-06-07)

- DEX: Aerodrome (volatile PLTY/USDC)
- **Pool/pair address:** `0xb0c2495ed6f792c9d22165796c36e5868df0cc63`
- Seeded: 900,000,000 PLTY + 300 USDC → initial price ~$0.00000033 (FDV ~$333)
- LP tokens (~0.5196) moved to the Safe `0x0044…3A6C` (held by 2-of-3; **not yet locked/burned** — revisit later for a stronger rug-proof signal)
- 100,000,000 PLTY reserve also held in the Safe `0x0044…3A6C`
- DEX Screener: https://dexscreener.com/base/0xb0c2495ed6f792c9d22165796c36e5868df0cc63

## Next steps

1. **Community (step 3):** Telegram, launch announcement + memes on X (@PLTYBase). ← NEXT
2. Submit token info/logo to DEX Screener; apply to CoinGecko / CoinMarketCap.
3. Decide LP: keep in Safe, or lock (UNCX/team.finance) / burn for a stronger rug-proof signal.
4. `renounceOwnership()` (via Safe) when stable → freezes the contract forever.
