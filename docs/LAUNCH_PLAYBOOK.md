# $PLTY Launch Playbook ($350 budget / Base)

The shortest path from "launch" to "indexed → people gathering." Just go top to bottom.

---

## Phase 0: Prep (before spending anything)

- [ ] Create a **fresh, disposable deployer wallet** (MetaMask, etc.). Keep it separate from your main assets.
- [ ] Move the $350 USDC into that wallet. Add a little ETH on Base for gas ($5 is plenty).
      - Bridge USDC/ETH to Base via Coinbase withdrawal or [bridge.base.org](https://bridge.base.org).
- [ ] Create your X (Twitter) account and Telegram group **first** (consistent @ and logo).
- [ ] Stock 10–20 memes (the existing platypus art + variations).
- [ ] Grab a domain (`plty.info` (done)).

## Phase 1: Deploy the token

```bash
# 1. Install Foundry (if not already)
curl -L https://foundry.paradigm.xyz | bash && foundryup

# 2. Get dependencies
forge install OpenZeppelin/openzeppelin-contracts OpenZeppelin/openzeppelin-contracts-upgradeable foundry-rs/forge-std

# 3. Test locally
forge test -vv

# 4. Set up .env (PRIVATE_KEY / BASESCAN_API_KEY)
cp .env.example .env  # edit the values

# 5. Set "owner" in token.config.json to your deployer address

# 6. Rehearse on testnet first (free; get Base Sepolia test ETH from a faucet)
forge script script/Deploy.s.sol --rpc-url base_sepolia --broadcast --verify

# 7. Mainnet (Base)
forge script script/Deploy.s.sol --rpc-url base --broadcast --verify
```

→ Note the printed **Proxy address** (that's the token users hold). Put it in `web/index.html` and `metadata/token.json`. Keep the implementation address too for verification.

## Phase 2: Create the liquidity pool — this is where you get INDEXED

- [ ] On [Aerodrome](https://aerodrome.finance) (Base's main DEX), create a **PLTY/USDC** pool.
      - e.g. most of the PLTY supply (90–100%) + $280 USDC.
      - Note: a thin pool means a very volatile price. That's the reality of $350. You raise price with people, not capital.
- [ ] **A few minutes after** pool creation, you're **auto-listed for free** on [DEX Screener](https://dexscreener.com) and [DEXTools](https://www.dextools.io). Search and confirm.
- [ ] **Burn or lock the LP tokens** ([team.finance](https://team.finance), etc.) → proof you can't rug.

## Phase 3: Trust (same day) — PLTY is upgradeable+mintable, so this matters

Because the owner *can* mint and upgrade, scanners flag it as rug-risk. Counter it:

- [ ] **Move ownership off your hot wallet** to a multisig (e.g. [Safe](https://safe.global)) and/or a Timelock:
      `cast send <PROXY> "transferOwnership(address)" <SAFE_ADDR> --rpc-url base --private-key $PRIVATE_KEY`
- [ ] **Verify both contracts** on Basescan (proxy + implementation) → shows **Verified (green)**, source matches this Git repo.
- [ ] **Publish a supply/upgrade policy** (e.g. "upgrades via 48h timelock + 3/5 multisig; no surprise mints") and pin it.
- [ ] Check the score on [Token Sniffer](https://tokensniffer.com) / [honeypot.is](https://honeypot.is) → screenshot it to socials.
- [ ] Optional, when you no longer need changes: `cast send <PROXY> "renounceOwnership()" ...` → makes PLTY fully immutable and clears the flags for good.

## Phase 4: Strengthen indexing / apply to listings

- [ ] Submit the free DEX Screener "Token Info" update (logo, socials, description).
- [ ] Apply to [CoinGecko](https://www.coingecko.com/en/coins/new) and [CoinMarketCap](https://support.coinmarketcap.com) (free, reviewed, days+).
- [ ] GeckoTerminal usually auto-populates from the DEX pool.

## Phase 5: Gather people (this is the real work)

- [ ] Spam the launch announcement on X/TG (10 memes in a row).
- [ ] Pin the story: "the world's weirdest animal = the world's weirdest coin."
- [ ] Always show the trust proofs (renounced, LP locked, Verified).
- [ ] Reach out to small KOLs / meme accounts (on $350, lean on free RTs; be careful with paid).
- [ ] Community events: meme contests, burn events, etc.

---

## Budget allocation (rough)

| Item | Amount |
|---|---|
| Liquidity pool | ~$280 |
| Gas (deploy + various tx) | ~$10 |
| Domain | $1–15 |
| Reserve (socials / assets / small KOL) | remainder |

> ⚠️ DEX Screener trending Boosts and paid Enhanced Info run $300+ and will eat your whole budget. **You're auto-listed for free, so skip them at first.**

## Honest expectations

$350 is enough to launch, get indexed, and start a community.
But **$350 will not pump the price** — price comes from hype and people, not liquidity.
Treat it as a party, and never risk more than you can afford to lose.
