-- recommendations: each packing advice the app generates.
-- Guests save without an owner (user_id null, identified only by device_id).
-- Signed-in users save to their account (user_id = their id).

create table if not exists public.recommendations (
  id            uuid primary key default gen_random_uuid(),   -- the app generates this id client-side
  user_id       uuid default auth.uid() references auth.users (id) on delete set null,
  device_id     text,
  product_id    text not null,
  storage       text,
  duration      text,
  transport     text,
  pack_type     text,
  lang          text not null default 'en',
  warning_keys  text[] not null default '{}',
  created_at    timestamptz not null default now(),
  constraint recommendations_lang_valid check (lang in ('en','hi','mr'))
);

create index if not exists recommendations_user_idx    on public.recommendations (user_id, created_at desc);
create index if not exists recommendations_device_idx  on public.recommendations (device_id);

alter table public.recommendations enable row level security;

-- Anyone can save advice, but a signed-in user cannot save it under someone else's id.
-- (user_id defaults to auth.uid(), so guests get null and signed-in users get their own id.)
drop policy if exists "recommendations_insert" on public.recommendations;
create policy "recommendations_insert" on public.recommendations
  for insert to anon, authenticated
  with check (user_id is null or user_id = (select auth.uid()));

-- Signed-in users can read their own advice (this powers the count under "My account").
drop policy if exists "recommendations_select_own" on public.recommendations;
create policy "recommendations_select_own" on public.recommendations
  for select to authenticated
  using (user_id = (select auth.uid()));

-- No update/delete from the website. Guest rows cannot be read back by anyone.
