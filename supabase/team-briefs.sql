-- Juice Studio Planner: incoming briefs.
-- Run once in Supabase → SQL Editor, after team-access.sql. Safe to run more than once.
--
-- A brief is a job the client has asked for before anyone has quoted it. The team adds
-- and edits them; an admin turns one into a quote. They live in the settings row, so they
-- are backed up with everything else.
--   sp_add_brief    adds one brief (brand and task required).
--   sp_patch_brief  edits one brief. The team can only set the plain text fields and mark
--                   a brief dropped — linking a brief to a quote stays an admin action.
--   sp_del_brief    removes a brief within 15 minutes of it being added.

create or replace function public.sp_add_brief(p_entry jsonb)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare e jsonb;
begin
  if coalesce(p_entry ->> 'brand', '') = '' then raise exception 'Say which brand the brief is for'; end if;
  if coalesce(p_entry ->> 'task', '')  = '' then raise exception 'Say what the client has asked for'; end if;
  if coalesce(p_entry ->> 'by', '')    = '' then raise exception 'Say who is adding it'; end if;
  if coalesce(p_entry ->> 'date', '') !~ '^\d{4}-\d{2}-\d{2}$' then raise exception 'Pick a valid date'; end if;
  if coalesce(p_entry ->> 'due', '') <> '' and coalesce(p_entry ->> 'due', '') !~ '^\d{4}-\d{2}-\d{2}$' then raise exception 'Pick a valid date'; end if;

  e := jsonb_build_object(
    'id',      left(coalesce(nullif(p_entry ->> 'id', ''), gen_random_uuid()::text), 40),
    'brand',   left(p_entry ->> 'brand', 80),
    'project', left(coalesce(p_entry ->> 'project', ''), 120),
    'task',    left(p_entry ->> 'task', 200),
    'notes',   left(coalesce(p_entry ->> 'notes', ''), 600),
    'date',    p_entry ->> 'date',
    'due',     coalesce(p_entry ->> 'due', ''),
    'by',      left(p_entry ->> 'by', 60),
    'status',  'new',
    'pid',     '',
    'at',      now(),
    'src',     'team'
  );

  update public.sp_settings
     set data = jsonb_set(data, '{briefs}',
                  (case when jsonb_typeof(data -> 'briefs') = 'array' then data -> 'briefs' else '[]'::jsonb end)
                  || jsonb_build_array(e)),
         updated_at = now(), updated_by = 'team'
   where id = 'main';
  if not found then raise exception 'The planner is not set up yet'; end if;
  return e;
end $$;

create or replace function public.sp_patch_brief(p_id text, p_patch jsonb)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  briefs jsonb;
  idx    int := -1;
  i      int;
  el     jsonb;
  k      text;
  v      text;
begin
  select case when jsonb_typeof(data -> 'briefs') = 'array' then data -> 'briefs' else '[]'::jsonb end
    into briefs from public.sp_settings where id = 'main' for update;
  if not found then raise exception 'The planner is not set up yet'; end if;

  for i in 0 .. jsonb_array_length(briefs) - 1 loop
    if briefs -> i ->> 'id' = p_id then idx := i; exit; end if;
  end loop;
  if idx < 0 then raise exception 'That brief no longer exists'; end if;
  el := briefs -> idx;

  for k in select jsonb_object_keys(p_patch) loop
    v := coalesce(p_patch ->> k, '');
    if k = 'status' then
      if v not in ('new', 'dropped') then raise exception 'A brief can only be left open or dropped here'; end if;
      el := jsonb_set(el, array[k], to_jsonb(v));
    elsif k = 'due' then
      if v <> '' and v !~ '^\d{4}-\d{2}-\d{2}$' then raise exception 'Dates must look like 2026-10-01'; end if;
      el := jsonb_set(el, array[k], to_jsonb(v));
    elsif k in ('brand', 'project', 'task', 'notes') then
      el := jsonb_set(el, array[k], to_jsonb(left(v, case k when 'notes' then 600 when 'task' then 200 else 120 end)));
    else
      raise exception 'The team view cannot change "%"', k;
    end if;
  end loop;

  update public.sp_settings
     set data = jsonb_set(data, array['briefs', idx::text], el), updated_at = now(), updated_by = 'team'
   where id = 'main';
  return el;
end $$;

create or replace function public.sp_del_brief(p_id text)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  before_n int;
  after_b  jsonb;
begin
  select jsonb_array_length(case when jsonb_typeof(data -> 'briefs') = 'array' then data -> 'briefs' else '[]'::jsonb end),
         coalesce((select jsonb_agg(x)
                     from jsonb_array_elements(case when jsonb_typeof(data -> 'briefs') = 'array' then data -> 'briefs' else '[]'::jsonb end) x
                    where not (x ->> 'id' = p_id
                               and x ->> 'src' = 'team'
                               and coalesce(x ->> 'pid', '') = ''
                               and (x ->> 'at')::timestamptz > now() - interval '15 minutes')),
                  '[]'::jsonb)
    into before_n, after_b
    from public.sp_settings where id = 'main' for update;
  if not found or jsonb_array_length(after_b) = before_n then return false; end if;

  update public.sp_settings
     set data = jsonb_set(data, '{briefs}', after_b), updated_at = now(), updated_by = 'team'
   where id = 'main';
  return true;
end $$;

revoke all on function public.sp_add_brief(jsonb)         from public;
revoke all on function public.sp_patch_brief(text, jsonb)  from public;
revoke all on function public.sp_del_brief(text)           from public;
grant execute on function public.sp_add_brief(jsonb)        to anon, authenticated;
grant execute on function public.sp_patch_brief(text, jsonb) to anon, authenticated;
grant execute on function public.sp_del_brief(text)          to anon, authenticated;
