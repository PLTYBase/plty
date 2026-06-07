# PLTY Deployment Record

## Base mainnet (chainId 8453) — 2026-06-07

| Item | Value |
|---|---|
| **Token (proxy) — use this** | `0xDe129391E97F34609bd1AD414FC5D40d5a7Fb50e` |
| Implementation (logic) | `0x0f032DC529b19C3654050adc4fe04BD2c7Bd0459` |
| Owner (mint/upgrade authority) | `0xc5D7B3E0C2d87938C49bc7A8b73b21a06d63b368` |
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

## Next steps after deploy

1. **Create liquidity pool** (Aerodrome, PLTY/USDC) → makes it tradeable + auto-indexes on DEX Screener.
2. **Lock/burn LP tokens** → proof liquidity can't be pulled.
3. **Move ownership to a Safe multisig / Timelock** → trust for an upgradeable+mintable token.
4. Submit token info/logo to DEX Screener; apply to CoinGecko / CoinMarketCap.
5. `renounceOwnership()` when stable → freezes the contract forever.
