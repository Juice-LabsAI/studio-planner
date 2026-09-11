-- Juice Studio Planner: shared database setup
-- Paste into Supabase: SQL Editor, then New query, then Run. Safe to run more than once.
--
-- Every table this app uses starts with "sp_". Other Juice apps in the same Supabase
-- project should use their own prefix (e.g. "xx_") and can reuse is_juice_member() below.

-- 1. Shared access rule: only signed-in users with a @juicelabs.ai email address.
create or replace function public.is_juice_member()
returns boolean
language sql
stable
as $$
  select coalesce(lower(auth.jwt() ->> 'email') like '%@juicelabs.ai', false)
$$;

-- 2. Tables. Each row holds one JSON document, the same shape the app uses.
create table if not exists public.sp_settings (
  id          text primary key,            -- always 'main'
  data        jsonb not null,
  updated_at  timestamptz not null default now(),
  updated_by  text
);

create table if not exists public.sp_jobs (
  id          text primary key,            -- job type id, e.g. 'brand-film-30'
  data        jsonb not null,
  updated_at  timestamptz not null default now(),
  updated_by  text
);

create table if not exists public.sp_quotes (
  id          text primary key,            -- quote id
  data        jsonb not null,
  updated_at  timestamptz not null default now(),
  updated_by  text
);

-- 3. Row-level security: members can read and write; nobody else can see anything.
alter table public.sp_settings enable row level security;
alter table public.sp_jobs     enable row level security;
alter table public.sp_quotes   enable row level security;

drop policy if exists "sp_settings juice members" on public.sp_settings;
create policy "sp_settings juice members" on public.sp_settings
  for all to authenticated
  using (public.is_juice_member()) with check (public.is_juice_member());

drop policy if exists "sp_jobs juice members" on public.sp_jobs;
create policy "sp_jobs juice members" on public.sp_jobs
  for all to authenticated
  using (public.is_juice_member()) with check (public.is_juice_member());

drop policy if exists "sp_quotes juice members" on public.sp_quotes;
create policy "sp_quotes juice members" on public.sp_quotes
  for all to authenticated
  using (public.is_juice_member()) with check (public.is_juice_member());

revoke all on public.sp_settings, public.sp_jobs, public.sp_quotes from anon;
grant select, insert, update, delete on public.sp_settings, public.sp_jobs, public.sp_quotes to authenticated;

-- 4. Live updates: lets open planners see each other's changes without reloading.
do $$
declare t text;
begin
  foreach t in array array['sp_settings','sp_jobs','sp_quotes'] loop
    if not exists (
      select 1 from pg_publication_tables
      where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = t
    ) then
      execute format('alter publication supabase_realtime add table public.%I', t);
    end if;
  end loop;
end $$;
