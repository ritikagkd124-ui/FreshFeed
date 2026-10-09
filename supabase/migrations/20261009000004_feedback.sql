-- feedback: "did this advice work?" answers, linked to a recommendation.

create table if not exists public.feedback (
  id                  uuid primary key default gen_random_uuid(),
  recommendation_id   uuid references public.recommendations (id) on delete cascade,
  user_id             uuid default auth.uid() references auth.users (id) on delete set null,
  device_id           text,
  rating              text not null,
  comment             text,
  created_at          timestamptz not null default now(),
  constraint feedback_rating_valid  check (rating in ('worked','partly','failed')),
  constraint feedback_comment_len   check (comment is null or char_length(comment) <= 500)
);

create index if not exists feedback_recommendation_idx on public.feedback (recommendation_id);
create index if not exists feedback_user_idx           on public.feedback (user_id, created_at desc);

alter table public.feedback enable row level security;

drop policy if exists "feedback_insert" on public.feedback;
create policy "feedback_insert" on public.feedback
  for insert to anon, authenticated
  with check (user_id is null or user_id = (select auth.uid()));

drop policy if exists "feedback_select_own" on public.feedback;
create policy "feedback_select_own" on public.feedback
  for select to authenticated
  using (user_id = (select auth.uid()));
