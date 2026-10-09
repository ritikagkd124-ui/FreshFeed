-- Reference data from the Produce Cold Storage & Postharvest Handling Technical Manual
-- (docs/produce-cold-storage-manual.pdf).
--
--   storage_groups : the 7 storage compatibility groups (manual §1, "Storage Compatibility
--                    Classification"), with temperature, humidity and ethylene profile.
--   rules          : storage / packaging rules for each commodity class
--                    (§1 fresh produce, §2 dairy, §3 bakery & snacks, §4 fermented).
--                    source_section points back to the manual section each rule comes from.
--
-- Both tables are read-only from the website: anyone can read, nobody can write
-- (edit them in the Supabase dashboard).

-- ---------------------------------------------------------------- storage_groups
create table if not exists public.storage_groups (
  id            smallint primary key,
  temp_c_min    numeric,
  temp_c_max    numeric,
  temp_f_range  text,
  rh_min        numeric,
  rh_max        numeric,
  profile       text,
  notes         text
);

alter table public.storage_groups enable row level security;

drop policy if exists "Public read storage_groups" on public.storage_groups;
create policy "Public read storage_groups" on public.storage_groups
  for select using (true);

insert into public.storage_groups (id, temp_c_min, temp_c_max, temp_f_range, rh_min, rh_max, profile, notes) values
  (1, 0, 2, '32–36°F', 90, 95, 'Ethylene producers', NULL),
  (2, 0, 2, '32–36°F', 95, 100, 'Ethylene sensitive', NULL),
  (3, 0, 2, '32–36°F', 65, 75, 'Moisture sensitive', 'High RH induces root growth and decay'),
  (4, 4.5, 7, '40–45°F', 90, 95, 'Chilling-injury sensitive / odor risk', NULL),
  (5, 10, 10, '50°F', 85, 90, 'Ethylene and chilling-injury sensitive', NULL),
  (6, 13, 15, '55–60°F', 85, 90, 'Ethylene producers and chilling-injury sensitive', NULL),
  (7, 18, 21, '65–70°F', 85, 90, 'Ripening / chilling-injury sensitive', NULL)
on conflict (id) do nothing;

-- ---------------------------------------------------------------- rules
create table if not exists public.rules (
  id                     serial primary key,
  commodity_class        text not null
                         check (commodity_class in ('fresh_produce','dairy','bakery_snack','fermented','all')),
  parameter              text not null,
  condition              text not null,
  threshold              text,
  action                 text not null,
  packaging_implication  text,
  severity               text not null check (severity in ('critical','warning','tip')),
  source_section         text
);

alter table public.rules enable row level security;

drop policy if exists "Public read rules" on public.rules;
create policy "Public read rules" on public.rules
  for select using (true);

insert into public.rules (id, commodity_class, parameter, condition, threshold, action, packaging_implication, severity, source_section) values
  -- §1 Active horticultural tissues (fresh fruits & vegetables)
  (1, 'fresh_produce', 'respiration_rate', 'Extremely high respiration rate', '> 60 mL CO2/kg·h', 'Precool immediately after harvest to prevent sugar loss, yellowing and self-heating', 'Use breathable or micro-perforated packaging; never a fully sealed high-barrier film', 'critical', '§1 Respiration'),
  (2, 'fresh_produce', 'respiration_rate', 'Low respiration rate (apples, garlic, onions, mature potatoes)', NULL, 'Suitable for extended cold storage', NULL, 'tip', '§1 Respiration'),
  (3, 'fresh_produce', 'storage_temperature', 'Cool-season crops (leafy greens, roots, brassicas, apples)', '0–2°C, 90–100% RH', 'Store near freezing at high humidity to prevent wilting and weight loss', 'Micro-perforated film liners help keep humidity high', 'warning', '§1 Temperature & RH'),
  (4, 'fresh_produce', 'chilling_sensitive', 'Warm-season / chilling-sensitive crop', 'Below 2–13°C (crop-specific)', 'Do not store below the crop threshold: causes pitting, browning, failure to ripen and rot', 'Do not recommend cold-chain packaging below group temperature', 'critical', '§1 Chilling Injury'),
  (5, 'fresh_produce', 'storage_temperature', 'Below commodity freezing point', '< -1.8 to -0.2°C (28.8–31.7°F)', 'Avoid: ice crystals rupture cells and tissue collapses on thawing', NULL, 'critical', '§1 Freezing Injury'),
  (6, 'fresh_produce', 'ethylene_role', 'Ethylene producer stored with ethylene-sensitive crop', NULL, 'Keep ethylene producers (Groups 1, 6) apart from ethylene-sensitive crops (Groups 2, 5)', 'Separate packs / storage areas', 'warning', '§1 Storage Compatibility'),
  (7, 'fresh_produce', 'relative_humidity', 'Dry garlic and dry onions', '65–75% RH', 'Keep humidity low: high RH causes sprouting and decay', 'Use ventilated, breathable packs (not moisture-retentive film)', 'warning', '§1 Group 3'),
  -- §2 Dairy
  (8, 'dairy', 'relative_humidity / moisture', 'Milk powders', 'RH > 65% or moisture > 4.0%', 'Keep below 25°C and 65% RH to avoid caking, lost solubility and browning', 'Low-WVTR packaging', 'critical', '§2 Lactose'),
  (9, 'dairy', 'fat_content', 'High-fat dairy powder (whole milk powder)', 'Fat ≥ 26%', 'Prevent oxidation of surface fat', 'Nitrogen flush or vacuum seal in light-barrier packaging (12–24 months)', 'critical', '§2 Lipid Oxidation'),
  (10, 'dairy', 'fat_content', 'High-fat, high-moisture dairy (butter, cheese)', NULL, 'Risk of hydrolytic rancidity and light-induced oxidation', 'Light-barrier packaging (foil laminate); vacuum shrink-wrap for cheese', 'warning', '§2 Lipolysis'),
  (11, 'dairy', 'storage_temperature', 'Cultured dairy (yogurt)', '0–4°C; pH < 3.8 = over-acidified', 'Keep cold to stop post-acidification and whey separation', 'Sealed PP cups with foil lids', 'warning', '§2 Syneresis'),
  -- §3 Low-moisture & baked
  (12, 'bakery_snack', 'water_activity', 'Crisp snacks and crackers', 'aw > 0.35–0.45', 'Moisture pickup makes them soft (loss of crispness)', 'Low-WVTR barrier: metallized OPP or aluminium foil laminate', 'critical', '§3 Water Activity'),
  (13, 'bakery_snack', 'fat_content', 'High-fat snacks', NULL, 'Stop oxidation and rancidity', 'Oxygen barrier + nitrogen flush, headspace O2 < 1.0%', 'critical', '§3 Barrier Packaging'),
  (14, 'bakery_snack', 'water_activity', 'Very dry, fatty products', 'aw < 0.10–0.20', 'Lipid oxidation speeds up at very low aw; do not over-dry', 'Oxygen control is essential', 'warning', '§3 Lipid Oxidation'),
  (15, 'bakery_snack', 'water_activity', 'Porous baked products (crackers)', NULL, 'Oxygen reaches the whole product, not just the surface', 'Needs a full oxygen barrier, not only surface protection', 'tip', '§3 Lipid Oxidation'),
  (16, 'all', 'water_activity', 'Microbial growth limits', 'aw < 0.60 none; bacteria stop 0.87–0.91; molds/yeasts stop 0.70–0.80', 'Use aw to judge microbial risk', NULL, 'tip', '§3 Critical aw'),
  (17, 'bakery_snack', 'water_activity', 'Multi-component products (filled pastries, cream cakes)', 'e.g. filling aw 0.80 vs crust aw 0.30', 'Formulate components to the same aw to stop moisture migration', NULL, 'tip', '§3 Moisture Migration'),
  -- §4 Fermented & acidified
  (18, 'fermented', 'ph', 'Acidified / fermented foods', 'pH < 4.6', 'Mandatory safety threshold: stops Clostridium botulinum; optimal 3.3–4.0', NULL, 'critical', '§4 pH Safety'),
  (19, 'fermented', 'storage_temperature', 'After fermentation reaches target', '0.6–0.9% lactic acid, pH 3.8–4.2', 'Chill immediately to -1 to 4°C to prevent over-souring and softening', NULL, 'warning', '§4 Chilling'),
  (20, 'fermented', 'gas_production', 'Actively fermenting products (kimchi)', NULL, 'CO2 builds pressure in the pack', 'Gas-vented containers', 'warning', '§4 Kimchi'),
  (21, 'fermented', 'brine', 'Brine ferments (sauerkraut)', NULL, 'Keep submerged under brine to prevent yeast film and putrid odor', 'Pack with brine covering product', 'warning', '§4 Sauerkraut'),
  (22, 'fermented', 'texture', 'Softening of fermented vegetables', '0.1–0.5% CaCl2', 'Adding calcium chloride keeps vegetables crisp', NULL, 'tip', '§4 Pectin Retention')
on conflict (id) do nothing;

-- keep the id sequence ahead of the seeded rows
select setval(pg_get_serial_sequence('public.rules', 'id'), greatest((select max(id) from public.rules), 1));
