# Arena Forge Pro — online PvP test v3.60.17

This is an **unranked, peer-relayed multiplayer test** for Arena, Secret Zone, and Dark Passage. It reuses the game's existing three-lane duel battle engine. The server authenticates both accounts, matches two players in an isolated mode queue, receives commander setup, issues a shared seed/start time, and relays card/ability/commander movement commands between the two connected clients.

The combat simulation itself still runs on each player's device. Render does not independently simulate or verify damage, unit movement, or the winner. The server checks only message shape, selected numeric ranges, command rate, and whether the two client-reported results are complementary. A modified client could cheat. Online trophies, rank changes, credits, XP, chests, and mode rewards are disabled. Treat results as test-only.

Boss Raid, Colossus Awakening, Tower, Campaign, Sky Islands, and Flag Battle remain local/offline in this build; they are not sent into unsupported online queues.

## Upload to GitHub

Upload the six files from this flat bundle into the GitHub repository root. The server and SQL migration are intentionally flattened for easier mobile upload. The environment-variable template is only a reference; do not upload real secrets.

## Supabase — user action required

1. Open the Supabase project already used by the game.
2. Open SQL Editor and run `001_afp_multimode_online.sql` once.
3. In Project Settings → API / API Keys, copy Project URL, publishable (or anon) key, and secret/service-role key.
4. Enter these only in Render → Environment. Never put the secret key in GitHub or the HTML.

## Render deployment — user action required

Create a Web Service from repository `marazali2012-wq/arena-forge-online-server` with:
- Root Directory: leave blank (repository root)
- Runtime: Node
- Build Command: `npm install`
- Start Command: `npm start`
- Health Check Path: `/health`

Add:
- `AFP_BUILD_ID` = `v3.60.17`
- `SUPABASE_URL` = Supabase Project URL
- `SUPABASE_PUBLISHABLE_KEY` = publishable/anon key
- `SUPABASE_SECRET_KEY` = secret/service-role key (server-only)

After Render deploys, it displays an HTTPS service URL. Paste that URL into the game's online server-address prompt when pressing SAVAŞ. The game converts it to `wss://.../ws` and remembers it on that device.

## Live test

Use two separate accounts logged into the same Supabase project, on two different browsers/devices. Open this exact v3.60.17 HTML on both, select Arena / Secret / Dark, press SAVAŞ, and paste the same Render URL the first time. Both users must reach the same mode queue. Once matched, both send their commander/ability setup. The match then starts with a shared seed and relays actions.

## Known limitations

- This is client-simulated, not server-authoritative combat; synchronization may diverge under latency or differing frame timing.
- The server cannot prevent a modified client from fabricating actions or results.
- Two-account live testing has not yet been performed.
- Free Render services may sleep while idle, delaying initial connection.
- No online reward, trophy, ranked, or verified progression is enabled.
