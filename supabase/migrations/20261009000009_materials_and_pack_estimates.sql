-- Packaging materials, which material goes with which pack type, and rough costs.
--
--   materials       : 19 packaging materials (films, laminates, crates, jute, glass ...) with
--                     oxygen (OTR) and water-vapour (WVTR) transmission, barrier level,
--                     recyclability and eco flags. Film data: Poly Print OTR/WVTR tables;
--                     PLA: NatureWorks data sheet; barrier needs from the manual (§2, §3).
--   pack_materials  : for each pack type the app can recommend, the primary material,
--                     alternatives, outer packaging and a greener (eco) option.
--   pack_estimates  : rough thickness and price in rupees per bag / pouch / crate / jar
--                     (estimates — always compare local suppliers).
--
-- Public read-only.

-- ---------------------------------------------------------------- materials
create table if not exists public.materials (
  id                serial primary key,
  code              text not null unique,
  name              text not null,
  kind              text not null check (kind in ('film','coated_film','laminate','rigid','fabric','paper','glass')),
  otr_min           numeric,
  otr_max           numeric,
  otr_basis         text,
  wvtr_min          numeric,
  wvtr_max          numeric,
  wvtr_basis        text,
  co2tr             numeric,
  o2_barrier        text check (o2_barrier in ('near_total','very_high','high','medium','low','open')),
  moisture_barrier  text check (moisture_barrier in ('near_total','very_high','high','medium','low','open')),
  recyclable        text,
  biodegradable     boolean default false,
  reusable          boolean default false,
  notes             text,
  source            text
);

alter table public.materials enable row level security;

drop policy if exists "Public read materials" on public.materials;
create policy "Public read materials" on public.materials
  for select using (true);

insert into public.materials (id, code, name, kind, otr_min, otr_max, otr_basis, wvtr_min, wvtr_max, wvtr_basis, co2tr, o2_barrier, moisture_barrier, recyclable, biodegradable, reusable, notes, source) values
  (1, 'LDPE', 'Low-density polyethylene (LDPE)', 'film', '7000', '8500', '25 µm (1 mil), 23°C, 0% RH', '16', '23', '25 µm, 37.8°C, 90% RH', NULL, 'low', 'medium', 'Yes — PE (resin code 4) where collected', 'false', 'false', 'Most common bag film; lets oxygen through easily', 'Poly Print, Understanding Film Properties: OTR and WVTR tables'),
  (2, 'LDPE_MICROPERF', 'Micro-perforated LDPE film', 'film', NULL, NULL, 'Set by the number and size of perforations, not the base film', NULL, NULL, NULL, NULL, 'medium', 'medium', 'Yes — PE (resin code 4) where collected', 'false', 'false', 'Perforations raise gas flow far above plain LDPE while keeping humidity high', 'Base film values: see LDPE'),
  (3, 'HDPE', 'High-density polyethylene (HDPE)', 'film', '2300', '3100', '25 µm, 23°C, 0% RH', '4.7', '7.8', '25 µm, 37.8°C, 90% RH', NULL, 'low', 'high', 'Yes — PE (resin code 2)', 'false', 'false', NULL, 'Poly Print, Understanding Film Properties: OTR and WVTR tables'),
  (4, 'CPP', 'Cast polypropylene (CPP)', 'film', '2300', '3100', '25 µm, 23°C, 0% RH', '9.3', '11', '25 µm, 37.8°C, 90% RH', NULL, 'low', 'medium', 'Yes — PP (resin code 5) where collected', 'false', 'false', NULL, 'Poly Print, Understanding Film Properties: OTR and WVTR tables'),
  (5, 'BOPP', 'Biaxially oriented polypropylene (BOPP)', 'film', '1550', '2500', '25 µm, 23°C, 0% RH', '3.9', '6.2', '25 µm, 37.8°C, 90% RH', NULL, 'low', 'high', 'Yes — PP (resin code 5) where collected', 'false', 'false', 'Clear film for snacks and bakery', 'Poly Print, Understanding Film Properties: OTR and WVTR tables'),
  (6, 'MET_OPP', 'Metallized OPP', 'coated_film', '19', '160', 'Metallized OPP, 23°C, 0% RH', NULL, NULL, NULL, NULL, 'high', 'high', 'Difficult — metallized multilayer', 'false', 'false', 'Common chips / snack film; WVTR not in source', 'Poly Print, Understanding Film Properties: OTR table (coated/metallized)'),
  (7, 'OPET', 'Oriented polyester (PET)', 'film', '31', '93', '25 µm, 23°C, 0% RH', '16', '20', '25 µm, 37.8°C, 90% RH', NULL, 'high', 'medium', 'Yes — PET (resin code 1)', 'false', 'false', NULL, 'Poly Print, Understanding Film Properties: OTR and WVTR tables'),
  (8, 'MET_PET', 'Metallized PET', 'coated_film', '0.16', '1.7', 'Metallized OPET, 23°C, 0% RH', NULL, NULL, NULL, NULL, 'very_high', 'high', 'Difficult — metallized multilayer', 'false', 'false', 'WVTR not in source', 'Poly Print, Understanding Film Properties: OTR table (coated/metallized)'),
  (9, 'PVDC_PET', 'PVdC-coated PET', 'coated_film', '4.7', '7.8', 'PVdC-coated OPET, 23°C, 0% RH', NULL, NULL, NULL, NULL, 'very_high', 'high', 'Difficult — coated film', 'false', 'false', NULL, 'Poly Print, Understanding Film Properties: OTR table (coated/metallized)'),
  (10, 'NYLON', 'Biaxial nylon-6 (PA)', 'film', '18.6', '39', '25 µm, 23°C, 0% RH', NULL, NULL, NULL, NULL, 'high', 'low', 'Difficult — usually in multilayer', 'false', 'false', 'Used in vacuum bags laminated with PE', 'Poly Print, Understanding Film Properties: OTR table'),
  (11, 'EVOH', 'EVOH barrier layer', 'film', '0.08', '0.19', '25 µm, 23°C, 0% RH', '22', '124', '25 µm, 37.8°C, 90% RH', NULL, 'near_total', 'low', 'Difficult — used as a thin inner layer', 'false', 'false', 'Oxygen barrier drops when wet; always sandwiched between moisture-barrier layers', 'Poly Print, Understanding Film Properties: OTR and WVTR tables'),
  (12, 'PLA', 'Polylactic acid film (PLA, biaxially oriented)', 'film', '550', '550', '25 µm (per mil), ASTM D1434', '325', '325', '25 µm (per mil), ASTM E96', '3000', 'medium', 'low', 'Industrially compostable; not in home compost', 'true', 'false', 'Bio-based; lets through much more moisture than PE or PP', 'NatureWorks Ingeo 4043D technical data sheet (typical values)'),
  (13, 'AL_FOIL_LAM', 'Aluminium foil laminate', 'laminate', NULL, NULL, 'Near-total barrier when free of pinholes', NULL, NULL, NULL, NULL, 'near_total', 'near_total', 'Difficult — foil/plastic multilayer', 'false', 'false', 'Also blocks light', 'Produce storage manual (§3); problem statement'),
  (14, 'LENO_MESH', 'Leno mesh (net) bag', 'fabric', NULL, NULL, 'Open weave — air passes freely', NULL, NULL, NULL, NULL, 'open', 'open', 'Yes — PP where collected', 'false', 'true', NULL, 'Qualitative'),
  (15, 'JUTE', 'Jute sack', 'fabric', NULL, NULL, 'Open weave — air passes freely', NULL, NULL, NULL, NULL, 'open', 'open', 'Natural fibre', 'true', 'true', NULL, 'Qualitative'),
  (16, 'CRATE', 'Ventilated plastic crate', 'rigid', NULL, NULL, 'Vented sides — air passes freely', NULL, NULL, NULL, NULL, 'open', 'open', 'Yes — HDPE/PP', 'false', 'true', 'Protects produce from crushing', 'Qualitative'),
  (17, 'CORRUGATED', 'Corrugated fibreboard box', 'paper', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'open', 'low', 'Yes — paper', 'true', 'false', 'Outer box for transport', 'Qualitative'),
  (18, 'GLASS', 'Glass jar', 'glass', NULL, NULL, 'Impermeable', NULL, NULL, 'Impermeable', NULL, 'near_total', 'near_total', 'Yes — glass, and reusable', 'false', 'true', NULL, 'Qualitative'),
  (19, 'PP_CUP_FOIL', 'PP cup with foil lid', 'rigid', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'high', 'high', 'PP cup recyclable where collected', 'false', 'false', NULL, 'Produce storage manual (§2)')
on conflict (id) do nothing;

select setval(pg_get_serial_sequence('public.materials', 'id'), greatest((select max(id) from public.materials), 1));

-- ---------------------------------------------------------------- pack_materials
create table if not exists public.pack_materials (
  id             serial primary key,
  pack_type      text not null,
  material_code  text not null references public.materials (code),
  role           text not null check (role in ('primary','alternative','outer','eco')),
  note           text
);

create index if not exists pack_materials_material_code_idx on public.pack_materials (material_code);

alter table public.pack_materials enable row level security;

drop policy if exists "Public read pack_materials" on public.pack_materials;
create policy "Public read pack_materials" on public.pack_materials
  for select using (true);

insert into public.pack_materials (id, pack_type, material_code, role, note) values
  (1, 'micro_perforated', 'LDPE_MICROPERF', 'primary', NULL),
  (2, 'micro_perforated', 'LDPE', 'alternative', 'Base film; plain LDPE usually lets through too little oxygen for fast-breathing produce'),
  (3, 'micro_perforated', 'CORRUGATED', 'outer', NULL),
  (4, 'micro_perforated', 'PLA', 'eco', 'Breathes more and lets moisture out faster than LDPE'),
  (5, 'open_perforated', 'LDPE_MICROPERF', 'primary', NULL),
  (6, 'open_perforated', 'CRATE', 'outer', NULL),
  (7, 'open_perforated', 'CRATE', 'eco', 'Reusable crate with a damp cloth or leaf lining'),
  (8, 'ventilated', 'CRATE', 'primary', NULL),
  (9, 'ventilated', 'JUTE', 'eco', NULL),
  (10, 'mesh_dry', 'LENO_MESH', 'primary', NULL),
  (11, 'mesh_dry', 'JUTE', 'eco', NULL),
  (12, 'sealed_dry', 'MET_PET', 'primary', NULL),
  (13, 'sealed_dry', 'AL_FOIL_LAM', 'alternative', NULL),
  (14, 'n2_barrier', 'MET_OPP', 'primary', NULL),
  (15, 'n2_barrier', 'AL_FOIL_LAM', 'alternative', NULL),
  (16, 'moisture_barrier', 'MET_OPP', 'primary', NULL),
  (17, 'moisture_barrier', 'AL_FOIL_LAM', 'alternative', NULL),
  (18, 'moisture_retain', 'LDPE', 'primary', NULL),
  (19, 'moisture_retain', 'PLA', 'eco', 'Food dries out faster'),
  (20, 'vacuum', 'NYLON', 'primary', 'Nylon/PE laminate vacuum bag'),
  (21, 'sealed_cup', 'PP_CUP_FOIL', 'primary', NULL),
  (22, 'light_barrier', 'AL_FOIL_LAM', 'primary', NULL),
  (23, 'vented_container', 'HDPE', 'primary', 'Rigid HDPE tub with a gas-release vent'),
  (24, 'vented_container', 'GLASS', 'eco', 'Glass jar with a loosely fitted lid while fermenting'),
  (25, 'brine_jar', 'GLASS', 'primary', NULL),
  (26, 'brine_jar', 'GLASS', 'eco', 'Glass is reusable and recyclable'),
  (27, 'hot_fill_glass', 'GLASS', 'primary', NULL),
  (28, 'hot_fill_glass', 'GLASS', 'eco', 'Glass is reusable and recyclable')
on conflict (id) do nothing;

select setval(pg_get_serial_sequence('public.pack_materials', 'id'), greatest((select max(id) from public.pack_materials), 1));

-- ---------------------------------------------------------------- pack_estimates
create table if not exists public.pack_estimates (
  pack_type              text primary key,
  thickness_min_um       numeric,
  thickness_max_um       numeric,
  film_price_min_inr_kg  numeric,
  film_price_max_inr_kg  numeric,
  bag_len_cm             numeric,
  bag_wid_cm             numeric,
  film_density_g_cm3     numeric default 0.92,
  unit_price_min_inr     numeric,
  unit_price_max_inr     numeric,
  unit                   text not null,
  size_note              text,
  basis                  text,
  is_estimate            boolean not null default true
);

alter table public.pack_estimates enable row level security;

drop policy if exists "Public read pack_estimates" on public.pack_estimates;
create policy "Public read pack_estimates" on public.pack_estimates
  for select using (true);

insert into public.pack_estimates (pack_type, thickness_min_um, thickness_max_um, film_price_min_inr_kg, film_price_max_inr_kg, bag_len_cm, bag_wid_cm, film_density_g_cm3, unit_price_min_inr, unit_price_max_inr, unit, size_note, basis, is_estimate) values
  ('brine_jar', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '15', '35', 'jar', '500 g glass jar with lid', 'Trade estimate', 'true'),
  ('hot_fill_glass', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '15', '35', 'jar', '500 g glass jar with lid', 'Trade estimate', 'true'),
  ('light_barrier', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '3', 'wrapper', '100–500 g foil laminate wrapper', 'Trade estimate', 'true'),
  ('mesh_dry', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '8', '15', 'sack', '50 kg leno mesh bag', 'Trade estimate', 'true'),
  ('micro_perforated', '25', '40', '150', '230', '50', '40', '0.92', NULL, NULL, 'bag', '5 kg bag, 50×40 cm', 'Film price: plain LDPE ₹120–190/kg (Indian market listings, 2026) plus an estimated premium for micro-perforation', 'true'),
  ('moisture_barrier', '40', '60', NULL, NULL, NULL, NULL, NULL, '1', '3', 'pouch', '100–250 g pouch', 'Trade estimate', 'true'),
  ('moisture_retain', '40', '50', '120', '190', '35', '25', '0.92', NULL, NULL, 'bag', 'Bread / cake bag, 35×25 cm', 'Film price: LDPE ₹120–190/kg (Indian market listings, 2026)', 'true'),
  ('n2_barrier', '40', '60', NULL, NULL, NULL, NULL, NULL, '1', '3', 'pouch', '100–200 g snack pouch (nitrogen flushing machine extra)', 'Trade estimate', 'true'),
  ('open_perforated', '25', '40', '150', '230', '50', '40', '0.92', NULL, NULL, 'bag', '5 kg bag, 50×40 cm', 'Film price: plain LDPE ₹120–190/kg (Indian market listings, 2026) plus an estimated premium for perforation', 'true'),
  ('outer_corrugated', NULL, NULL, NULL, NULL, NULL, NULL, '0.92', '25', '60', 'box', '5-ply corrugated box for 10–20 kg', 'Trade estimate', 'true'),
  ('outer_crate', NULL, NULL, NULL, NULL, NULL, NULL, '0.92', '150', '300', 'crate', '20–25 kg plastic crate, reusable for years', 'Trade estimate', 'true'),
  ('sealed_cup', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '3', '6', 'cup', '200–400 g PP cup with foil lid', 'Trade estimate', 'true'),
  ('sealed_dry', '80', '100', NULL, NULL, NULL, NULL, NULL, '3', '8', 'pouch', '1 kg metallized / foil laminate pouch', 'Trade estimate', 'true'),
  ('vacuum', '70', '90', NULL, NULL, NULL, NULL, NULL, '3', '8', 'bag', '250 g–1 kg nylon/PE vacuum bag', 'Trade estimate', 'true'),
  ('vented_container', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '15', '30', 'tub', '1 kg HDPE tub with vent', 'Trade estimate', 'true'),
  ('ventilated', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '150', '300', 'crate', '20–25 kg plastic crate, reusable for years', 'Trade estimate', 'true')
on conflict (pack_type) do nothing;
