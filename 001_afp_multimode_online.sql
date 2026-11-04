-- Arena Forge Pro | 9-mode online foundation
-- Run once in the Supabase SQL Editor. This creates server-written records only.
-- The client is NOT allowed to award trophies, mode rewards, or submit verified results.

begin;

create table if not exists public.afp_mode_matches (
  id uuid primary key default gen_random_uuid(),
  mode_id text not null check (mode_id in (
    'colossus','boss','tower','campaign','arena','sky','secret','flag','dark'
  )),
  server_room_id text not null unique,
  status text not null default 'matched' check (status in ('matched','started','aborted','finished')),
  protocol_version integer not null default 1 check (protocol_version > 0),
  build_id text not null check (length(build_id) between 1 and 48),
  verified boolean not null default false,
  result_json jsonb,
  created_at timestamptz not null default now(),
  started_at timestamptz,
  finished_at timestamptz
);

create table if not exists public.afp_mode_match_players (
  match_id uuid not null references public.afp_mode_matches(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  seat smallint not null check (seat between 1 and 6),
  joined_at timestamptz not null default now(),
  left_at timestamptz,
  primary key (match_id, user_id),
  unique (match_id, seat)
);

create table if not exists public.afp_mode_progress (
  user_id uuid not null references auth.users(id) on delete cascade,
  mode_id text not null check (mode_id in (
    'colossus','boss','tower','campaign','arena','sky','secret','flag','dark'
  )),
  payload jsonb not null default '{}'::jsonb,
  revision bigint not null default 1 check (revision > 0),
  updated_at timestamptz not null default now(),
  primary key (user_id, mode_id),
  check (octet_length(payload::text) <= 65536)
);

create index if not exists afp_mode_matches_mode_created_idx
  on public.afp_mode_matches (mode_id, created_at desc);
create index if not exists afp_mode_match_players_user_idx
  on public.afp_mode_match_players (user_id, joined_at desc);

alter table public.afp_mode_matches enable row level security;
alter table public.afp_mode_match_players enable row level security;
alter table public.afp_mode_progress enable row level security;

-- Remove broad/default rights. The server uses SUPABASE_SECRET_KEY outside the client.
revoke all on public.afp_mode_matches from anon, authenticated;
revoke all on public.afp_mode_match_players from anon, authenticated;
revoke all on public.afp_mode_progress from anon, authenticated;

grant select on public.afp_mode_matches to authenticated;
grant select on public.afp_mode_match_players to authenticated;
grant select on public.afp_mode_progress to authenticated;

drop policy if exists "afp users read own match rows" on public.afp_mode_matches;
create policy "afp users read own match rows"
  on public.afp_mode_matches for select to authenticated
  using (exists (
    select 1 from public.afp_mode_match_players p
    where p.match_id = afp_mode_matches.id and p.user_id = (select auth.uid())
  ));

drop policy if exists "afp users read own player rows" on public.afp_mode_match_players;
create policy "afp users read own player rows"
  on public.afp_mode_match_players for select to authenticated
  using (user_id = (select auth.uid()));

drop policy if exists "afp users read own mode progress" on public.afp_mode_progress;
create policy "afp users read own mode progress"
  on public.afp_mode_progress for select to authenticated
  using (user_id = (select auth.uid()));

commit;
