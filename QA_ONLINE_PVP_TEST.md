# Arena Forge Pro v3.60.20 — QA report

## Static checks passed
- Render `server.js`: `node --check` passed.
- HTML: 53 JavaScript blocks checked with `node --check`; 3 `application/json` data scripts excluded; 0 JavaScript syntax errors.
- Client and server build IDs match: `v3.60.20`.
- Client queue binding exposes `arena`, `secret`, `dark`, and `flag` only.
- Client battle bridge accepts the same four PvP IDs; the flag path starts the existing `AFP36.start('flag')` game mode and accepts the existing remote-command gate for `gameMode==='flag'`.
- Server `BATTLE_MODES` is exactly `arena`, `secret`, `dark`, `flag`.
- Server still registers all nine mode IDs; `colossus`, `boss`, `tower`, `campaign`, and `sky` have `battleEnabled:false` and remain outside PvP matchmaking.
- Save schema remains `arenaForgeProProfileV19`; existing cloud autosync module remains present.
- Legacy settings matchmaking panel remains hidden; mode-start flow is the queue entry point.
- An isolated Node VM test of flag battle startup and remote-command mode gate passed.

## Incomplete / not verified
- Full Chromium headless page load did not complete within the local execution time limit; a visual/browser runtime smoke test is therefore **not passed**.
- No access from this execution environment to the live Render or Netlify hosts; public health check and live page check could not be reached.
- Two separate authenticated accounts have not completed live queue/match tests for the four PvP modes.
- Real latency, disconnect/reconnect, Supabase cloud restore, and disputed-result tests remain outstanding.
- Ranked results, trophies, and rewards remain disabled; no production-readiness claim is made.
