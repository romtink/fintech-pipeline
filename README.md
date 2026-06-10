# Fraud Analytics ELT Pipeline

An end-to-end ELT pipeline built with Python, DuckDB, and SQL to answer a single business question:

> **Where, when, and to whom does credit card fraud occur — and what transaction behaviors predict it?**

**[View the Tableau dashboard](https://public.tableau.com/views/FraudDashboard_17809805593950/Dashboard1)**

---

## Key findings

| Finding | Detail |
|---|---|
| Online shopping has the highest fraud rate | 1.80% fraud rate — 3x the dataset average |
| Evening & late night dominate fraud timing | 9x higher fraud rate than morning and afternoon hours |
| Cardholders over the age of 50 are most vulnerable to fraud | Males over 50 have a 0.76% fraud rate — the highest of any demographic |
| Successive transactions predict fraud | Transactions within 2 minutes of a previous transaction are 2.4x more likely to be fraudulent |

---

## Pipeline architecture

```
fraudTrain.csv
      │
      ▼
┌─────────────┐
│  raw layer  │  ingest.py loads CSV → DuckDB raw schema
│             │  1,296,675 rows · untouched source of truth
└──────┬──────┘
       │
       ▼
┌─────────────┐
│staging layer│  transform.py runs stg_transactions.sql
│             │  cleans types, renames columns, strips merchant prefix
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  mart layer │  mart.py runs 3 aggregation models
│             │  fraud_by_category · fraud_by_hour · fraudrisk_by_demographics
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   exports   │  export.py writes mart tables → CSV
│             │  connects to Tableau dashboard
└─────────────┘
```

---

## Project structure

```
fintech-pipeline/
├── src/
│   ├── ingest.py           # Load raw CSV into DuckDB
│   ├── transform.py        # Build staging layer
│   ├── mart.py             # Build mart layer
│   ├── export.py           # Export marts to CSV
│   └── explore.py          # Pandas velocity feature analysis
├── sql/
│   └── staging/
│       └── staging.sql     # Staging transformation logic
├── sql_marts/
│   ├── fraud_by_category.sql
│   ├── fraud_by_hour.sql
│   └── fraudrisk_by_demographics.sql
├── data/
│   └── exports/            # CSV outputs for Tableau
└── requirements.txt
```

---

## Stack

| Layer | Tool |
|---|---|
| Language | Python 3 |
| Database | DuckDB |
| Transformation | SQL |
| Exploration | pandas |
| Visualization | Tableau Public |
| Version control | Git / GitHub |

---

## How to run

**1 — Clone and set up environment**
```bash
git clone https://github.com/romtink/fintech-pipeline.git
cd fintech-pipeline
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

**2 — Download the dataset**

Download from Kaggle: [Credit Card Transactions Fraud Detection Dataset](https://www.kaggle.com/datasets/kartik2112/fraud-detection)

Place `fraudTrain.csv` in `data/raw/` or update the path in `ingest.py` to point to your local file.

**3 — Run the pipeline**
```bash
python3 src/ingest.py       # Load raw data → DuckDB
python3 src/transform.py    # Build staging layer
python3 src/mart.py         # Build mart tables
python3 src/export.py       # Export to CSV
```

---

## Analytical decisions

**Why raw → staging → mart?**
This mirrors the architecture used in production data warehouses and dbt projects. The raw layer is never modified — it's the source of truth. Staging cleans and standardizes. Marts answer specific business questions. This structure makes the pipeline easy to debug, extend, and eventually migrate to dbt + Snowflake.

**Why DuckDB?**
DuckDB runs SQL directly on local files with no server setup. It handles 1.29M rows in milliseconds and uses the same SQL syntax as Snowflake, making the eventual cloud migration straightforward.

**Why strip the `fraud_` prefix from merchant names?**
The raw dataset prefixes every merchant with `fraud_` as an artifact of the simulation tool. This was removed in the staging layer so merchant names are clean and readable in downstream analysis.

**Why filter out online categories for the velocity feature?**
Online transactions don't have a physical location, so velocity flagging based on geography doesn't apply. Filtering to POS transactions only ensures the feature reflects genuine physical impossibility.

---

## Velocity fraud feature

Built in pandas — flags cards with multiple transactions within a 2-minute window, excluding online categories.

```
14,732 transactions flagged
173 confirmed fraud cases
1.4% fraud rate among flagged transactions
0.58% overall dataset fraud rate
→ 2.4x more likely to be fraudulent
```

---

## Dataset

[Credit Card Transactions Fraud Detection Dataset](https://www.kaggle.com/datasets/kartik2112/fraud-detection) — Kaggle

Simulated credit card transactions (Jan 2019 – Dec 2020) covering 1,000 customers and 800 merchants, generated using the Sparkov simulation tool.

---

## Roadmap

- [x] Phase 1 — Raw ingestion (Python + DuckDB)
- [x] Phase 2 — Staging layer (SQL)
- [x] Phase 3 — Mart layer (SQL aggregations)
- [x] Phase 4 — Tableau dashboard (published)
- [ ] Phase 5 — dbt models + Snowflake migration
