# Arena Forge Pro — online backend v3.60.20

This package serves the four PvP queues and keeps the other five modes registered for online profile/save progression only.

## Mode routing

**Authenticated 1v1 PvP queues**
- `arena` — Savaş Arenaları
- `secret` — Gizli Bölge
- `dark` — Karanlık Geçit
- `flag` — Bayrak Savaşı

**Online account/save sync, local PvE battle (no PvP queue)**
- `colossus` — Kolosus Uyanışı
- `boss` — Boss Raid
- `tower` — Yükseliş Kulesi
- `campaign` — Hikâye Seferi
- `sky` — Gökyüzü Adaları

The server's `/health` endpoint lists all nine registered modes in `modes` and only the four PvP queues in `battleModes`. The five PvE modes are rejected by `joinQueue` with `online_battle_not_supported_for_mode`.

## Deploy to the existing Render service

1. Replace the repository-root `server.js` with the `server.js` in this ZIP. Keep the existing `package.json` and dependencies.
2. In Render → Environment set `AFP_BUILD_ID` to `v3.60.20`.
3. Keep `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`, and `SUPABASE_SECRET_KEY` unchanged. Never put the secret key in the client HTML or public repository.
4. Redeploy and check `/health`: `buildId` must be `v3.60.20`; `battleModes` must contain exactly `arena`, `secret`, `dark`, `flag`.

No new SQL migration is needed for this server-side mode-list correction. Existing `afp_mode_matches.mode_id` is used as a text identifier.

## Test limitations

This is an unranked, peer-relayed test server. Each client simulates combat locally; the server does not calculate authoritative damage or independently verify winners. Ranked trophies, credits, chests, XP, and match rewards remain disabled. Complete two-account live QA is still required for every PvP mode, especially the flag objectives.
