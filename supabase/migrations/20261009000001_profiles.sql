-- profiles: one row per signed-up user (name, phone, role, district, state, language).
-- The row itself is created by the trigger in 20261009000005_handle_new_user.sql.

create table if not exists public.profiles (
  id          uuid primary key references auth.users (id) on delete cascade,
  full_name   text,
  phone       text,
  role        text not null default 'farmer',
  district    text,
  state       text,
  lang        text not null default 'en',
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  constraint profiles_full_name_len check (full_name is null or char_length(full_name) between 2 and 120),
  constraint profiles_phone_fmt     check (phone is null or phone ~ '^[0-9+ -]{6,20}$'),
  constraint profiles_role_valid    check (role in ('farmer','fpo','trader','processor','student','other')),
  constraint profiles_lang_valid    check (lang in ('en','hi','mr'))
);

-- keep updated_at fresh on every edit
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

-- Access rules: each user can read and edit only their own profile.
alter table public.profiles enable row level security;

drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own" on public.profiles
  for select to authenticated
  using (id = (select auth.uid()));

drop policy if exists "profiles_insert_own" on public.profiles;
create policy "profiles_insert_own" on public.profiles
  for insert to authenticated
  with check (id = (select auth.uid()));

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own" on public.profiles
  for update to authenticated
  using (id = (select auth.uid()))
  with check (id = (select auth.uid()));

-- No delete policy: profiles are removed only when the auth user is deleted (cascade).
