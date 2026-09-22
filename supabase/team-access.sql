-- Juice Studio Planner: admin link + read-only team view.
-- Run once in Supabase → SQL Editor, AFTER creating the admin user
-- (Authentication → Users → Add user → the email and password in the k/ file, "Auto Confirm User" ticked).
-- Safe to run more than once. No planner data is changed.
--
-- What it does
--   1. The three sp_ tables go back to members only: the admin link signs in as a
--      @juicelabs.ai user, so it can read and write; the anon key can't touch them.
--   2. Three read-only views (sp_team_*) give the team page what it needs, minus money:
--      no prices, discounts, price overrides, day rate or markup settings, and no lost quotes.
--
-- Supabase's Security Advisor will flag the sp_team_* views as "security definer views".
-- That's intended: they run as their owner so the team page can read them without
-- being able to read the tables underneath.

-- 1. Members-only tables ------------------------------------------------------------
create or replace function public.is_juice_member()
returns boolean language sql stable as $$
  select coalesce(lower(auth.jwt() ->> 'email') like '%@juicelabs.ai', false)
$$;

drop policy if exists "sp_settings open" on public.sp_settings;
drop policy if exists "sp_jobs open"     on public.sp_jobs;
drop policy if exists "sp_quotes open"   on public.sp_quotes;

drop policy if exists "sp_settings juice members" on public.sp_settings;
drop policy if exists "sp_jobs juice members"     on public.sp_jobs;
drop policy if exists "sp_quotes juice members"   on public.sp_quotes;

create policy "sp_settings juice members" on public.sp_settings for all to authenticated
  using (public.is_juice_member()) with check (public.is_juice_member());
create policy "sp_jobs juice members" on public.sp_jobs for all to authenticated
  using (public.is_juice_member()) with check (public.is_juice_member());
create policy "sp_quotes juice members" on public.sp_quotes for all to authenticated
  using (public.is_juice_member()) with check (public.is_juice_member());

revoke all on public.sp_settings, public.sp_jobs, public.sp_quotes from anon;
grant select, insert, update, delete on public.sp_settings, public.sp_jobs, public.sp_quotes to authenticated;

-- 2. Read-only team views --------------------------------------------------------------
create or replace view public.sp_team_settings as
  select id,
         data - 'dayRate' - 'markupFloor' - 'targetMarkup' - 'history' as data,
         updated_at
  from public.sp_settings;

create or replace view public.sp_team_jobs as
  select id,
         (data - 'pricing' - 'externalCost')
           || jsonb_build_object('pricing', jsonb_build_object('type', data -> 'pricing' -> 'type')) as data,
         updated_at
  from public.sp_jobs;

create or replace view public.sp_team_quotes as
  select q.id,
         (q.data - 'discountPct' - 'lines')
           || jsonb_build_object('lines', coalesce((
                select jsonb_agg(l - 'spOverride' - 'discountPct')
                from jsonb_array_elements(
                  case when jsonb_typeof(q.data -> 'lines') = 'array' then q.data -> 'lines' else '[]'::jsonb end
                ) as l
              ), '[]'::jsonb)) as data,
         q.updated_at
  from public.sp_quotes q
  where coalesce(q.data ->> 'status', '') <> 'lost';

revoke all on public.sp_team_settings, public.sp_team_jobs, public.sp_team_quotes from anon, authenticated;
grant select on public.sp_team_settings, public.sp_team_jobs, public.sp_team_quotes to anon, authenticated;
