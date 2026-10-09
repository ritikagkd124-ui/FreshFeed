-- Align recommendations / feedback with what FreshFeed.html actually sends.
--
-- FreshFeed.html saves one row per piece of advice:
--   recommendations { id (uuid made in the browser), device_id, product_id (products.id, a number),
--                     storage, duration, transport, pack_type, lang, warning_keys }
-- and one row per "did it work?" answer:
--   feedback { recommendation_id, device_id, rating, comment }
--
-- This migration links product_id to the products table and adds the same value checks
-- the live database uses, so bad data is rejected by the database, not just the app.
-- Safe to run more than once.

-- ---------------------------------------------------------------- recommendations
-- product_id: text -> integer, linked to products(id)
do $$
begin
  if exists (select 1 from information_schema.columns
             where table_schema = 'public' and table_name = 'recommendations'
               and column_name = 'product_id' and data_type = 'text') then
    alter table public.recommendations
      alter column product_id type integer using nullif(product_id, '')::integer;
  end if;
end $$;

alter table public.recommendations alter column product_id drop not null;

do $$
begin
  if not exists (select 1 from pg_constraint where conname = 'recommendations_product_id_fkey') then
    alter table public.recommendations
      add constraint recommendations_product_id_fkey foreign key (product_id) references public.products (id);
  end if;
end $$;

create index if not exists recommendations_product_id_idx on public.recommendations (product_id);

-- value checks (match the choices in FreshFeed.html)
alter table public.recommendations drop constraint if exists recommendations_storage_check;
alter table public.recommendations add  constraint recommendations_storage_check
  check (storage in ('room','cold','fridge'));

alter table public.recommendations drop constraint if exists recommendations_duration_check;
alter table public.recommendations add  constraint recommendations_duration_check
  check (duration in ('d3','w1','w2','m1','m3'));          -- 3 days, 1 week, 2 weeks, 1 month, 3 months

alter table public.recommendations drop constraint if exists recommendations_transport_check;
alter table public.recommendations add  constraint recommendations_transport_check
  check (transport in ('local','truck','courier','export'));

alter table public.recommendations drop constraint if exists recommendations_pack_type_check;
alter table public.recommendations add  constraint recommendations_pack_type_check
  check (char_length(pack_type) <= 40);

alter table public.recommendations drop constraint if exists recommendations_device_id_check;
alter table public.recommendations add  constraint recommendations_device_id_check
  check (char_length(device_id) <= 64);

alter table public.recommendations drop constraint if exists recommendations_warning_keys_check;
alter table public.recommendations add  constraint recommendations_warning_keys_check
  check (coalesce(array_length(warning_keys, 1), 0) <= 20);

-- ---------------------------------------------------------------- feedback
alter table public.feedback drop constraint if exists feedback_device_id_check;
alter table public.feedback add  constraint feedback_device_id_check
  check (char_length(device_id) <= 64);
