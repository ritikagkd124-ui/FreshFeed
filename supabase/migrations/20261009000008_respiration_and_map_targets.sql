-- How fast produce "breathes", and the gas mix that keeps it fresh longest.
--
--   respiration_classes : the 6 respiration classes (very low → extremely high), with
--                         mg CO2/kg·h thresholds at 5°C (Kader 2002) and example crops.
--                         products.respiration_class uses these names. The manual (§1)
--                         says crops above 60 need immediate precooling.
--   map_targets         : target O2 / CO2 levels for modified-atmosphere packaging (MAP)
--                         or controlled-atmosphere storage (CA), nitrogen flushing for
--                         snacks (manual §3), and crops where CA gives no benefit.
--                         Mostly from Cantwell, UC Davis (2001). Linked to products.
--
-- Public read-only.

-- ---------------------------------------------------------------- respiration_classes
create table if not exists public.respiration_classes (
  class       text primary key,
  sort_order  smallint not null,
  rate_min    numeric,
  rate_max    numeric,
  unit_note   text,
  examples    text,
  source      text
);

alter table public.respiration_classes enable row level security;

drop policy if exists "Public read respiration_classes" on public.respiration_classes;
create policy "Public read respiration_classes" on public.respiration_classes
  for select using (true);

insert into public.respiration_classes (class, sort_order, rate_min, rate_max, unit_note, examples, source) values
  ('very_low', 1, NULL, '5', 'Kader thresholds are mg CO2/kg·h at 5°C (Watkins & Nock 2012, Table 1.2). User data labelled them Btu/ton/24 h', 'Nuts, dates, dried fruits, dried vegetables', 'Kader (2002), via Watkins & Nock, Production Guide for Storage of Organic Fruits and Vegetables, Cornell/NYS IPM (2012)'),
  ('low', 2, '5', '10', 'Kader thresholds are mg CO2/kg·h at 5°C (Watkins & Nock 2012, Table 1.2). User data labelled them Btu/ton/24 h', 'Apple, grape, garlic, dry onion, mature potato, sweet potato', 'Kader (2002), via Watkins & Nock, Production Guide for Storage of Organic Fruits and Vegetables, Cornell/NYS IPM (2012)'),
  ('moderate', 3, '10', '20', 'Kader thresholds are mg CO2/kg·h at 5°C (Watkins & Nock 2012, Table 1.2). User data labelled them Btu/ton/24 h', 'Apricot, cherry, peach, pear, nectarine, plum, cabbage, carrot, lettuce, pepper, tomato, cucumber, immature potato', 'Kader (2002), via Watkins & Nock, Production Guide for Storage of Organic Fruits and Vegetables, Cornell/NYS IPM (2012)'),
  ('high', 4, '20', '40', 'Kader thresholds are mg CO2/kg·h at 5°C (Watkins & Nock 2012, Table 1.2). User data labelled them Btu/ton/24 h', 'Strawberry, blackberry, raspberry, lima bean, cauliflower', 'Kader (2002), via Watkins & Nock, Production Guide for Storage of Organic Fruits and Vegetables, Cornell/NYS IPM (2012)'),
  ('very_high', 5, '40', '60', 'Kader thresholds are mg CO2/kg·h at 5°C (Watkins & Nock 2012, Table 1.2). User data labelled them Btu/ton/24 h', 'Artichoke, snap bean, green onion, Brussels sprouts, cilantro', 'Kader (2002), via Watkins & Nock, Production Guide for Storage of Organic Fruits and Vegetables, Cornell/NYS IPM (2012)'),
  ('extremely_high', 6, '60', NULL, 'Kader thresholds are mg CO2/kg·h at 5°C (Watkins & Nock 2012, Table 1.2). User data labelled them Btu/ton/24 h', 'Asparagus, broccoli, sweet corn, mushroom, spinach, green pea', 'Kader (2002), via Watkins & Nock, Production Guide for Storage of Organic Fruits and Vegetables, Cornell/NYS IPM (2012)')
on conflict (class) do nothing;

-- ---------------------------------------------------------------- map_targets
create table if not exists public.map_targets (
  id               serial primary key,
  product_id       integer references public.products (id),
  commodity        text not null,
  atmosphere_type  text not null check (atmosphere_type in ('MAP','CA','N2_flush','no_benefit')),
  o2_min           numeric,
  o2_max           numeric,
  co2_min          numeric,
  co2_max          numeric,
  temp_c_min       numeric,
  temp_c_max       numeric,
  notes            text,
  source           text
);

create index if not exists map_targets_product_id_idx on public.map_targets (product_id);

alter table public.map_targets enable row level security;

drop policy if exists "Public read map_targets" on public.map_targets;
create policy "Public read map_targets" on public.map_targets
  for select using (true);

insert into public.map_targets (id, product_id, commodity, atmosphere_type, o2_min, o2_max, co2_min, co2_max, temp_c_min, temp_c_max, notes, source) values
  (1, '1', 'Fresh apples', 'CA', '1', '2', '1', '3', '-1', '4', 'Controlled atmosphere storage', 'Respiration/MAP data (user-supplied)'),
  (2, '67', 'Strawberries', 'MAP', NULL, NULL, '10', '15', '0', '0', 'MAP pallet covers; O2 target not given', 'Respiration/MAP data (user-supplied)'),
  (3, '53', 'Fried potato chips / snacks (non-respiring)', 'N2_flush', NULL, '1.0', NULL, NULL, NULL, NULL, 'Nitrogen flushing keeps residual O2 below 1%', 'Respiration/MAP data (user-supplied)'),
  (4, '63', 'Apricot', 'CA', '2', '3', '2', '3', '-0.5', '0', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (5, '71', 'Globe artichoke', 'CA', '2', '3', '3', '5', '0', '0', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (6, '9', 'Asparagus', 'CA', NULL, NULL, '5', '12', '2.5', '2.5', 'Elevated CO2 in air (no O2 reduction)', 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (7, '32', 'Avocado (Fuerte, Hass)', 'CA', '2', '5', '3', '10', '3', '7', 'Storage temperature varies by cultivar', 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (8, '33', 'Banana', 'CA', '2', '5', '2', '5', '13', '15', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (9, '72', 'Snap / green beans', 'CA', '2', '3', '4', '7', '4', '7', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (10, '68', 'Blackberries', 'CA', '5', '10', '15', '20', '-0.5', '0', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (11, '69', 'Raspberries', 'CA', '5', '10', '15', '20', '-0.5', '0', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (12, '67', 'Strawberry', 'CA', '5', '10', '15', '20', '0', '0', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (13, '20', 'Cranberry', 'CA', '1', '2', '0', '5', '2', '5', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (14, '10', 'Broccoli', 'CA', '1', '2', '5', '10', '0', '0', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (15, '74', 'Brussels sprouts', 'CA', '1', '2', '5', '7', '0', '0', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (16, '11', 'Cabbage (late crop)', 'CA', '3', '5', '3', '7', '0', '0', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (17, '13', 'Cauliflower', 'CA', '2', '5', '2', '5', '0', '0', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (18, '14', 'Celery', 'CA', '1', '4', '3', '5', '0', '0', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (19, '5', 'Sweet cherries', 'CA', '10', '20', '20', '25', '-1', '0', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (20, '75', 'Cilantro', 'CA', '3', '3', '7', '10', '0', '1', 'Air + 7–10% CO2 also listed', 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (21, '46', 'Sweet corn', 'CA', '2', '4', '5', '10', '0', '0', 'Up to 4 weeks: 5–10% O2 + 15% CO2', 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (22, '26', 'Cucumber (slicing)', 'CA', '3', '5', '0', '5', '10', '12', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (23, '27', 'Eggplant', 'CA', '3', '5', '0', '0', '10', '12', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (24, '17', 'Garlic bulb', 'CA', '0.5', '0.5', '5', '10', '-1', '0', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (25, '62', 'Grape', 'CA', '2', '5', '1', '3', '-0.5', '0', 'Up to 4 weeks: 5–10% O2 + 10–15% CO2', 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (26, '34', 'Grapefruit', 'CA', '3', '10', '5', '10', '10', '15', 'Storage temperature depends on growing region', 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (27, '21', 'Lemon', 'CA', '5', '10', '0', '10', '10', '13', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (28, '22', 'Lime', 'CA', '5', '10', '0', '10', '9', '10', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (29, '23', 'Orange', 'CA', '5', '10', '0', '5', '0', '9', 'Storage temperature depends on growing region', 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (30, '65', 'Lettuce', 'CA', '2', '5', '0', '0', '0', '0', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (31, '36', 'Mango', 'CA', '3', '5', '5', '10', '13', '13', 'UC Davis mango fact sheet gives 3–5% O2 + 5–8% CO2', 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (32, '19', 'Cantaloupe / netted melon', 'CA', '3', '5', '10', '15', '2', '5', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (33, '37', 'Honeydew and orange-flesh melons', 'CA', '3', '5', '5', '10', '5', '10', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (34, '8', 'Mushrooms', 'CA', '3', '21', '5', '15', '0', '0', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (35, '64', 'Nectarine', 'CA', '1', '2', '3', '5', '-0.5', '0', 'Internal breakdown at 3–10°C', 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (36, '28', 'Okra', 'CA', NULL, NULL, '4', '10', '7', '10', 'Elevated CO2 in air (no O2 reduction)', 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (37, '18', 'Onion (mature dry bulbs)', 'CA', '1', '3', '5', '10', '0', '0', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (38, '73', 'Green onions', 'CA', '2', '4', '10', '20', '0', '0', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (39, '38', 'Papaya', 'CA', '2', '5', '5', '8', '7', '13', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (40, '3', 'Peach', 'CA', '1', '2', '3', '5', '-0.5', '0', 'Internal breakdown at 3–10°C', 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (41, '2', 'Pear (European)', 'CA', '1', '3', '0', '5', '-1.5', '-0.5', 'Cultivar variations', 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (42, '76', 'Peas in pods', 'CA', '2', '3', '2', '3', '0', '0', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (43, '29', 'Bell pepper', 'CA', '2', '5', '2', '5', '7', '10', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (44, '4', 'Plums', 'CA', '1', '2', '0', '5', '-0.5', '0', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (45, '16', 'Radish', 'CA', '1', '2', '2', '3', '0', '0', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (46, '47', 'Spinach', 'CA', '5', '10', '5', '10', '0', '0', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (47, '31', 'Summer squash', 'CA', '3', '5', '5', '10', '7', '10', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (48, '45', 'Tomato, mature-green', 'CA', '3', '5', '2', '3', '10', '13', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (49, '39', 'Tomato, firm-ripe', 'CA', '3', '5', '3', '5', '8', '10', NULL, 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (50, '12', 'Carrots, topped', 'no_benefit', NULL, NULL, NULL, NULL, '0', '0', 'No CA benefit; ethylene causes bitterness', 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (51, '25', 'Cassava / yucca', 'no_benefit', NULL, NULL, NULL, NULL, '0', '5', 'No CA benefit', 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (52, '40', 'Ginger', 'no_benefit', NULL, NULL, NULL, NULL, '13', '13', 'No CA benefit; store at 65% RH', 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (53, '30', 'Potato (late crop)', 'no_benefit', NULL, NULL, NULL, NULL, '4', '8', 'No CA benefit', 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (54, '43', 'Watermelon', 'no_benefit', NULL, NULL, NULL, NULL, '10', '15', 'No CA benefit', 'Cantwell, M. (2001). Properties and Recommended Conditions for Long-Term Storage of Fresh Fruits and Vegetables. UC Davis Postharvest Center'),
  (55, '35', 'Guava', 'CA', '2', '5', NULL, NULL, '10', '10', 'Limited research: 2–5% O2 may delay ripening at 10°C; CO2 tolerance not determined', 'Kader, A.A. Guava produce fact sheet, UC Davis Postharvest Research and Extension Center')
on conflict (id) do nothing;

-- keep the id sequence ahead of the seeded rows
select setval(pg_get_serial_sequence('public.map_targets', 'id'), greatest((select max(id) from public.map_targets), 1));
