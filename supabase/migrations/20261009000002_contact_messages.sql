-- contact_messages: messages sent from the website contact form.
-- Anyone (even signed out) can send one. Nobody can read them from the website;
-- read them in the Supabase dashboard -> Table Editor -> contact_messages.

create table if not exists public.contact_messages (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  email       text not null,
  phone       text,
  topic       text not null default 'general',
  message     text not null,
  status      text not null default 'new',   -- new / read / replied (for you to track)
  created_at  timestamptz not null default now(),
  constraint contact_name_len    check (char_length(name) between 2 and 120),
  constraint contact_email_fmt   check (email ~ '^[^@\s]+@[^@\s]+\.[^@\s]+$' and char_length(email) <= 200),
  constraint contact_phone_fmt   check (phone is null or phone ~ '^[0-9+ -]{6,20}$'),
  constraint contact_topic_valid check (topic in ('general','packaging','partnership','bug','other')),
  constraint contact_message_len check (char_length(message) between 10 and 2000),
  constraint contact_status_valid check (status in ('new','read','replied'))
);

create index if not exists contact_messages_created_at_idx
  on public.contact_messages (created_at desc);

alter table public.contact_messages enable row level security;

-- Insert only, and only as a fresh "new" message (a visitor cannot set status).
drop policy if exists "contact_insert_anyone" on public.contact_messages;
create policy "contact_insert_anyone" on public.contact_messages
  for insert to anon, authenticated
  with check (status = 'new');

-- Deliberately no select/update/delete policy: the website can never read messages back.
-- The Supabase dashboard (service role) bypasses RLS, so you can still read and update them there.
