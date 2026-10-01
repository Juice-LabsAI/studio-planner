-- Juice Studio Planner: let the team keep the job status and post daily updates.
-- Run once in Supabase → SQL Editor, after team-access.sql. Safe to run more than once.
--
-- These three functions are the only extra things the team view can change:
--   sp_set_line     updates the tracking fields on ONE deliverable (brief, assets, owner,
--                   dates, stage, status, blocker, delivered). Any other field is refused,
--                   so prices, quantities and job types can't be touched.
--   sp_log_update   adds one end-of-day update to a project.
--   sp_undo_update  removes an update the team posted, within 15 minutes.

create or replace function public.sp_set_line(p_quote text, p_line text, p_patch jsonb)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  lines jsonb;
  st    text;
  idx   int := -1;
  i     int;
  el    jsonb;
  k     text;
  v     text;
  lim   int;
begin
  select data -> 'lines', data ->> 'status' into lines, st from public.sp_quotes where id = p_quote for update;
  if not found then raise exception 'That project no longer exists'; end if;
  if st = 'lost' then raise exception 'That project is marked lost'; end if;
  if jsonb_typeof(lines) <> 'array' then raise exception 'That project has no deliverables'; end if;

  for i in 0 .. jsonb_array_length(lines) - 1 loop
    if lines -> i ->> 'id' = p_line then idx := i; exit; end if;
  end loop;
  if idx < 0 then raise exception 'That deliverable no longer exists'; end if;
  el := lines -> idx;

  for k in select jsonb_object_keys(p_patch) loop
    if k in ('blocked', 'delivered') then
      el := jsonb_set(el, array[k], to_jsonb(coalesce((p_patch ->> k)::boolean, false)));
    elsif k in ('start', 'end') then
      v := coalesce(p_patch ->> k, '');
      if v <> '' and v !~ '^\d{4}-\d{2}-\d{2}$' then raise exception 'Dates must look like 2026-10-01'; end if;
      el := jsonb_set(el, array[k], to_jsonb(v));
    elsif k in ('label', 'stageNote', 'bdetail', 'baction', 'brief', 'assets', 'stage', 'wstatus', 'btype', 'assignee') then
      lim := case k when 'label' then 120 when 'stageNote' then 400 when 'bdetail' then 600 when 'baction' then 600 else 60 end;
      el := jsonb_set(el, array[k], to_jsonb(left(coalesce(p_patch ->> k, ''), lim)));
    else
      raise exception 'The team view cannot change "%"', k;
    end if;
  end loop;

  update public.sp_quotes
     set data = jsonb_set(data, array['lines', idx::text], el), updated_at = now(), updated_by = 'team'
   where id = p_quote;
  return el;
end $$;

create or replace function public.sp_log_update(p_quote text, p_entry jsonb)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  st text;
  e  jsonb;
begin
  select data ->> 'status' into st from public.sp_quotes where id = p_quote for update;
  if not found then raise exception 'That project no longer exists'; end if;
  if st = 'lost' then raise exception 'That project is marked lost'; end if;
  if coalesce(p_entry ->> 'date', '') !~ '^\d{4}-\d{2}-\d{2}$' then raise exception 'Pick a valid date'; end if;
  if coalesce(p_entry ->> 'by', '') = '' then raise exception 'Say who is posting the update'; end if;
  if coalesce(p_entry ->> 'done', '') = '' then raise exception 'Write what was done today'; end if;

  e := jsonb_build_object(
    'id',      left(coalesce(nullif(p_entry ->> 'id', ''), gen_random_uuid()::text), 40),
    'date',    p_entry ->> 'date',
    'by',      left(p_entry ->> 'by', 60),
    'lineId',  left(coalesce(p_entry ->> 'lineId', ''), 40),
    'stage',   left(coalesce(p_entry ->> 'stage', ''), 40),
    'done',    left(p_entry ->> 'done', 1200),
    'pending', left(coalesce(p_entry ->> 'pending', ''), 1200),
    'blocker', left(coalesce(p_entry ->> 'blocker', ''), 600),
    'files',   left(coalesce(p_entry ->> 'files', ''), 500),
    'at',      now(),
    'src',     'team'
  );

  update public.sp_quotes
     set data = jsonb_set(data, '{updates}',
                  (case when jsonb_typeof(data -> 'updates') = 'array' then data -> 'updates' else '[]'::jsonb end)
                  || jsonb_build_array(e)),
         updated_at = now(),
         updated_by = 'team'
   where id = p_quote;
  return e;
end $$;

create or replace function public.sp_undo_update(p_quote text, p_id text)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  before_n int;
  after_u  jsonb;
begin
  select jsonb_array_length(case when jsonb_typeof(data -> 'updates') = 'array' then data -> 'updates' else '[]'::jsonb end),
         coalesce((select jsonb_agg(x)
                     from jsonb_array_elements(case when jsonb_typeof(data -> 'updates') = 'array' then data -> 'updates' else '[]'::jsonb end) x
                    where not (x ->> 'id' = p_id
                               and x ->> 'src' = 'team'
                               and (x ->> 'at')::timestamptz > now() - interval '15 minutes')),
                  '[]'::jsonb)
    into before_n, after_u
    from public.sp_quotes where id = p_quote for update;
  if not found or jsonb_array_length(after_u) = before_n then return false; end if;

  update public.sp_quotes
     set data = jsonb_set(data, '{updates}', after_u), updated_at = now(), updated_by = 'team'
   where id = p_quote;
  return true;
end $$;

revoke all on function public.sp_set_line(text, text, jsonb) from public;
revoke all on function public.sp_log_update(text, jsonb)      from public;
revoke all on function public.sp_undo_update(text, text)      from public;
grant execute on function public.sp_set_line(text, text, jsonb) to anon, authenticated;
grant execute on function public.sp_log_update(text, jsonb)     to anon, authenticated;
grant execute on function public.sp_undo_update(text, text)     to anon, authenticated;
