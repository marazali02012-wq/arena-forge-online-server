# v3.60.17 QA — Online PvP test

## Integrated in files
- Client and server protocol build ID: v3.60.17.
- Render HTTPS URL entry in game; converted to WSS `/ws` and persisted locally.
- Two-player account-authenticated queue for Arena, Secret Zone, and Dark Passage only.
- Shared random seed and scheduled start.
- Existing duel engine starts the match; opponent commander and two abilities are applied.
- Local successful card deployments, abilities, commander lane changes, and concede actions are relayed over WebSocket.
- Server validates action names, ranges, commander data, and per-player message rate; sequenced actions are sent to the peer.
- Both clients report test outcomes; server checks complementary result reports and leaves `verified=false`.
- Online match end suppresses all trophies, credits, XP, chests, season rewards and ranked progression.
- Unsupported PvE/objective modes remain offline.

## Local checks
- HTML executable inline JavaScript blocks are syntax-checked with Node.
- Render `server.js` is syntax-checked with Node.
- Contract checks verify mode restriction, WSS client methods, battle setup/action/result transport, and reward suppression.

## Not yet done (requires user account/service access)
- Supabase SQL migration has not been run in the user's project.
- Supabase publishable and secret keys have not been added to Render Environment.
- Render Web Service has not been deployed; its real HTTPS URL is not known.
- Two separate Supabase accounts have not completed a live match.
- The server relays commands; it does not run the combat simulation or independently verify winners. This is a network-playtest integration, not production-grade authoritative PvP.
