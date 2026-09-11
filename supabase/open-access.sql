-- Juice Studio Planner: switch the sp_ tables to open access (no sign-in).
-- Run once in Supabase SQL Editor after schema.sql. Only touches the three sp_ tables' access rules;
-- no data is changed. Supabase will warn about "destructive operations" because of the
-- "drop policy" lines: they only remove the old @juicelabs.ai-only rules on these tables.
--
-- After this, anyone with the page address (or the anon key) can read and edit planner data.

drop policy if exists "sp_settings juice members" on public.sp_settings;
drop policy if exists "sp_jobs juice members"     on public.sp_jobs;
drop policy if exists "sp_quotes juice members"   on public.sp_quotes;

drop policy if exists "sp_settings open" on public.sp_settings;
drop policy if exists "sp_jobs open"     on public.sp_jobs;
drop policy if exists "sp_quotes open"   on public.sp_quotes;

create policy "sp_settings open" on public.sp_settings for all to anon, authenticated using (true) with check (true);
create policy "sp_jobs open"     on public.sp_jobs     for all to anon, authenticated using (true) with check (true);
create policy "sp_quotes open"   on public.sp_quotes   for all to anon, authenticated using (true) with check (true);

grant select, insert, update, delete on public.sp_settings, public.sp_jobs, public.sp_quotes to anon, authenticated;
