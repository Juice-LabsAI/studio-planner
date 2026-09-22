-- Juice Studio Planner: let the team view log credits.
-- Run once in Supabase → SQL Editor, after team-access.sql. Safe to run more than once.
--
-- The team view still can't edit projects. These two functions are the only things it can
-- change, and each does one narrow job:
--   sp_log_credits  adds one credit-usage entry to a project (checked: positive credits,
--                   valid date, project exists and isn't lost). Nothing else on the project changes.
--   sp_undo_credit  removes an entry the team logged, but only within 15 minutes of logging it.
-- Admins can still edit or delete any entry from the admin link.

create or replace function public.sp_log_credits(p_quote text, p_entry jsonb)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  st text;
  cr numeric;
  e  jsonb;
begin
  select data ->> 'status' into st from public.sp_quotes where id = p_quote for update;
  if not found then raise exception 'That project no longer exists'; end if;
  if st = 'lost' then raise exception 'That project is marked lost'; end if;

  begin
    cr := (p_entry ->> 'credits')::numeric;
  exception when others then
    raise exception 'Credits must be a number';
  end;
  if cr is null or cr <= 0 or cr > 10000000 then raise exception 'Credits must be more than 0'; end if;
  if coalesce(p_entry ->> 'date', '') !~ '^\d{4}-\d{2}-\d{2}$' then raise exception 'Pick a valid date'; end if;
  if coalesce(p_entry ->> 'by', '') = '' then raise exception 'Say who is logging'; end if;

  e := jsonb_build_object(
    'id',      left(coalesce(nullif(p_entry ->> 'id', ''), gen_random_uuid()::text), 40),
    'date',    p_entry ->> 'date',
    'person',  left(coalesce(p_entry ->> 'person', ''), 60),
    'prov',    left(coalesce(p_entry ->> 'prov', ''), 40),
    'credits', cr,
    'note',    left(coalesce(p_entry ->> 'note', ''), 300),
    'by',      left(p_entry ->> 'by', 60),
    'at',      now(),
    'src',     'team'
  );

  update public.sp_quotes
     set data = jsonb_set(data, '{usage}',
                  (case when jsonb_typeof(data -> 'usage') = 'array' then data -> 'usage' else '[]'::jsonb end)
                  || jsonb_build_array(e)),
         updated_at = now(),
         updated_by = 'team'
   where id = p_quote;

  return e;
end $$;

create or replace function public.sp_undo_credit(p_quote text, p_id text)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  before_n int;
  after_u  jsonb;
begin
  select jsonb_array_length(case when jsonb_typeof(data -> 'usage') = 'array' then data -> 'usage' else '[]'::jsonb end),
         coalesce((select jsonb_agg(x)
                     from jsonb_array_elements(case when jsonb_typeof(data -> 'usage') = 'array' then data -> 'usage' else '[]'::jsonb end) x
                    where not (x ->> 'id' = p_id
                               and x ->> 'src' = 'team'
                               and (x ->> 'at')::timestamptz > now() - interval '15 minutes')),
                  '[]'::jsonb)
    into before_n, after_u
    from public.sp_quotes where id = p_quote for update;
  if not found or jsonb_array_length(after_u) = before_n then return false; end if;

  update public.sp_quotes
     set data = jsonb_set(data, '{usage}', after_u), updated_at = now(), updated_by = 'team'
   where id = p_quote;
  return true;
end $$;

revoke all on function public.sp_log_credits(text, jsonb) from public;
revoke all on function public.sp_undo_credit(text, text)  from public;
grant execute on function public.sp_log_credits(text, jsonb) to anon, authenticated;
grant execute on function public.sp_undo_credit(text, text)  to anon, authenticated;
