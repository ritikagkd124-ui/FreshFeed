-- When someone signs up (Supabase Auth), create their profile automatically.
-- The sign-up form sends full_name, phone, role and lang as user metadata:
--   sb.auth.signUp({ email, password, options: { data: { full_name, phone, role, lang } } })
-- Values are validated here, so a bad or missing value falls back to a safe default
-- instead of making sign-up fail.

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  meta   jsonb := coalesce(new.raw_user_meta_data, '{}'::jsonb);
  v_name  text := nullif(btrim(meta ->> 'full_name'), '');
  v_phone text := nullif(btrim(meta ->> 'phone'), '');
  v_role  text := meta ->> 'role';
  v_lang  text := meta ->> 'lang';
begin
  if v_name is not null and char_length(v_name) not between 2 and 120 then v_name := null; end if;
  if v_phone is not null and v_phone !~ '^[0-9+ -]{6,20}$' then v_phone := null; end if;
  if v_role is null or v_role not in ('farmer','fpo','trader','processor','student','other') then v_role := 'farmer'; end if;
  if v_lang is null or v_lang not in ('en','hi','mr') then v_lang := 'en'; end if;

  insert into public.profiles (id, full_name, phone, role, lang)
  values (new.id, v_name, v_phone, v_role, v_lang)
  on conflict (id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Only the trigger should run this function, never an API caller.
revoke execute on function public.handle_new_user() from public, anon, authenticated;
