# FreshFeed
IEEE Synapse Hackathon

**Right pack. Longer freshness.** FreshFeed tells farmers, FPOs, traders and small food businesses which bag, box or film to use so their produce stays fresh longer, and what to avoid. Available in English, हिंदी and मराठी.

**Live app:** https://freshfeed-peach.vercel.app

## The problem

A large share of fruits and vegetables in India spoil after harvest. Often the cause is the wrong packaging: produce sealed in plastic when it needs to breathe, chilled when it cannot take the cold, or snacks packed in film that lets moisture in. The science to avoid this exists, but it sits in technical handbooks that farmers and small food makers rarely see.

## What FreshFeed does

1. **Pick the food:** 80 foods across fresh fruits & vegetables, dried produce, dairy, bakery & snacks, and fermented foods (tap, search or speak).
2. **Answer three questions:** where it will be stored (room, cold store, fridge), for how long (3 days to 3 months), and how it travels (local market, truck, courier, export).
3. **Get the advice:**
   - the right pack type and material, in plain words
   - warnings before losses (chilling injury, ethylene damage, too-long storage, food-safety rules)
   - expected shelf life at the right temperature and humidity
   - rough cost and thickness in rupees, plus a greener option
   - a printable spec sheet with a QR code to send to a supplier on WhatsApp
   - **Expert mode:** respiration rates, target O₂ / CO₂ and the film oxygen transmission (OTR) needed
4. **Tell us if it worked:** a one-tap feedback (worked / partly / failed) that is saved for improving the advice.

Advice can also be read aloud, and the app keeps working offline using a built-in copy of the data.

## How it works

```
FreshFeed.html (React, runs in the browser)
   │  reads reference data ───────────────►  Supabase (Postgres)
   │  products, rules, map_targets,           food-packaging-recommender
   │  materials, pack_materials,
   │  pack_estimates
   │
   │  saves each advice + feedback ───────►  recommendations, feedback
   │
   └─ recommendation engine (in the app): matches the food's storage group,
      respiration class, ethylene role, chilling sensitivity, water activity,
      fat, pH and gas targets against the chosen storage, time and transport
```

- **Frontend:** `FreshFeed.html`, a single-page React app (no build step).
- **Backend:** Supabase. Reference tables are read-only to the public. Advice and feedback can be saved by anyone, but nobody can read other people's rows from the website (row-level security).
- **Hosting:** Vercel. Every push to `main` redeploys; `/` opens the app (`vercel.json`).

## Database

All tables are rebuilt by the SQL files in [`supabase/migrations/`](supabase/migrations/).

| Table | Rows | What it holds |
|---|---|---|
| `storage_groups` | 7 | Storage compatibility groups: temperature, humidity, ethylene profile |
| `rules` | 22 | Storage and packaging rules per food class, each linked to its manual section |
| `products` | 80 | The foods: names in 3 languages, storage conditions, respiration rates, shelf life |
| `respiration_classes` | 6 | Very low → extremely high respiration, with CO₂ thresholds |
| `map_targets` | 55 | Target O₂ / CO₂ for modified or controlled atmosphere, N₂ flush, and "no benefit" crops |
| `materials` | 19 | Packaging materials with oxygen / moisture barrier, recyclability, eco flags |
| `pack_materials` | 28 | Main, alternative, outer and eco material for each pack type |
| `pack_estimates` | 16 | Rough thickness and rupee cost per bag, pouch, crate or jar |
| `recommendations` | – | Each piece of advice the app gives (saved without personal data) |
| `feedback` | – | "Did it work?" answers linked to a recommendation |

## Data sources

- *Produce Cold Storage & Postharvest Handling Technical Manual* ([`docs/produce-cold-storage-manual.pdf`](docs/produce-cold-storage-manual.pdf))
- USDA Agriculture Handbook 66 (2016): respiration rates
- Cantwell, M. (2001), UC Davis Postharvest Center: storage life and controlled-atmosphere targets
- Kader, A.A. (2002), via Watkins & Nock (2012): respiration classes
- Poly Print film tables and NatureWorks Ingeo data sheet: film OTR / WVTR
- Packaging prices are trade estimates; always compare two or three local suppliers.

## Run it yourself

1. Open `FreshFeed.html` in a browser, or host the folder on any static host (Vercel, Netlify, GitHub Pages).
2. To use your own Supabase project: run the files in `supabase/migrations/` in order (SQL editor or `supabase db push`), then change the Supabase URL and publishable key near the top of the script in `FreshFeed.html`.

## Repository

| Path | What it is |
|---|---|
| `FreshFeed.html` | The app (final frontend) |
| `supabase/migrations/` | Database tables, security rules and seed data |
| `docs/` | Source manual |
| `vercel.json` | Hosting config (opens the app at `/`) |

## Team

- **ritikagkd124-ui:** frontend, reference database, hosting
- **aayushsurve888:** Supabase accounts, recommendations and feedback tables, contact form, translations
