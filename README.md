# Fraud Analytics ELT Pipeline

An end-to-end ELT pipeline built with Python, DuckDB, dbt, Snowflake, and Tableau to answer a single business question:

> **Where, when, and to whom does credit card fraud occur — and what transaction behaviors predict it?**

[View the Tableau Dashboard →](https://public.tableau.com/app/profile/romtin.kharrazi/viz/FraudDashboard_17809805593950/Dashboard1)

---

## Key Findings

| Finding | Detail |
|---|---|
| Online shopping has the highest fraud rate | 1.80% fraud rate — 3x the dataset average |
| Evening & late night dominate fraud timing | 9x higher fraud rate than morning and afternoon hours |
| Cardholders over 50 are most vulnerable | Males over 50 have a 0.76% fraud rate — highest of any demographic |
| Successive transactions predict fraud | Transactions within 2 minutes of a prior transaction are 2.4x more likely to be fraudulent |

---

## Pipeline Architecture

```
fraudTrain.csv (1,296,675 rows)
        │
        ▼
┌───────────────────┐
│     Raw Layer     │  CSV loaded into Snowflake via UI
│  Snowflake · RAW  │  Untouched source of truth
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│   Staging Layer   │  dbt view — stg_transactions
│ Snowflake · STAGING│  Cleans types, renames columns, strips merchant prefix
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│    Mart Layer     │  dbt tables — 3 aggregation models
│ Snowflake · MARTS │  fraud_by_category · fraud_by_hour · fraudrisk_by_demographics
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│     Tableau       │  Published dashboard with KPIs,
│  Public Dashboard │  category, time-of-day, and demographic breakdowns
└───────────────────┘
```

---

## Tech Stack

| Layer | Tool |
|---|---|
| Ingestion | Python · CSV |
| Storage & Compute | Snowflake |
| Transformation | dbt Core |
| Exploratory Analysis | Python · pandas · DuckDB |
| Visualization | Tableau Public |

---

## Project Structure

```
fintech_pipeline/               ← dbt project root
├── models/
│   ├── staging/
│   │   ├── sources.yml         # Defines Snowflake raw source
│   │   ├── schema.yml          # Column-level tests for stg_transactions
│   │   └── stg_transactions.sql
│   └── marts/
│       ├── schema.yml          # Column-level tests for all mart models
│       ├── fraud_by_category.sql
│       ├── fraud_by_hour.sql
│       └── fraudrisk_by_demographics.sql
├── dbt_project.yml
└── README.md
```

---

## dbt Models

### Staging — `stg_transactions` (view)

Reads from `FINTECH_PIPELINE.RAW.RAW`. Casts timestamps and dates to proper types, rounds transaction amounts, strips the `fraud_` prefix from merchant names, and filters null primary keys. This layer keeps the raw table untouched while producing a clean, typed surface for downstream models.

### Marts (tables)

**`fraud_by_category`** — Aggregates fraud rate, fraud count, total transactions, and average fraud amount by merchant category. Used to answer which spending categories carry the highest fraud risk.

**`fraud_by_hour`** — Buckets transactions into Late Night, Morning, Afternoon, and Evening time windows and computes fraud rate per window. Surfaces the strong evening/late-night fraud concentration.

**`fraudrisk_by_demographics`** — Profiles fraud victims by age group (Under 30 / 30–50 / Over 50) and gender. Age is derived at runtime from `date_of_birth` and `transaction_timestamp` using `DATEDIFF`.

---

## dbt Tests

Schema tests are defined for both the staging and mart layers:

- `unique` and `not_null` on `transaction_id` (primary key)
- `not_null` on `is_fraud`, `amount`, `category`, `transaction_timestamp`
- `accepted_values` on `is_fraud` asserting only `[0, 1]`
- `not_null` on all mart grain columns and key metrics

All tests pass against the full 1.29M-row dataset.

---

## Velocity Fraud Feature

Built in pandas — flags cards with multiple transactions within a 2-minute window, excluding online categories (online transactions can legitimately occur in rapid succession).

| Metric | Value |
|---|---|
| Transactions flagged | 14,732 |
| Confirmed fraud among flagged | 173 |
| Fraud rate — flagged transactions | 1.4% |
| Fraud rate — full dataset | 0.58% |
| **Lift** | **2.4x more likely to be fraudulent** |

---

## How to Run

### Prerequisites

- Snowflake account with a database named `FINTECH_PIPELINE` and schemas `RAW`, `STAGING`, `MARTS`
- Python 3.9+
- dbt Core with the Snowflake adapter

### 1 — Clone and set up environment

```bash
git clone https://github.com/romtink/fintech-pipeline.git
cd fintech-pipeline/fintech_pipeline
python3 -m venv .venv
source .venv/bin/activate
pip install dbt-snowflake
```

### 2 — Configure dbt profile

Create `~/.dbt/profiles.yml`:

```yaml
fintech_pipeline:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <your_account_identifier>
      user: <your_username>
      password: <your_password>
      role: ACCOUNTADMIN
      database: FINTECH_PIPELINE
      warehouse: COMPUTE_WH
      schema: RAW
      threads: 4
```

### 3 — Load raw data

Load `fraudTrain.csv` into `FINTECH_PIPELINE.RAW.RAW` via the Snowflake UI (Snowsight → Data → Load Data) or using a `COPY INTO` command with an internal stage.

Dataset: [Credit Card Transactions Fraud Detection Dataset — Kaggle](https://www.kaggle.com/datasets/kartik2112/fraud-detection)

### 4 — Run the pipeline

```bash
dbt run      # builds staging view and mart tables in Snowflake
dbt test     # runs all schema tests
```

---

## Analytical Decisions

**Why raw → staging → mart?**
Mirrors the architecture used in production data warehouses and dbt projects. Raw data stays untouched as a source of truth. Staging handles cleaning and type casting. Marts pre-aggregate for specific business questions.

**Why strip the `fraud_` prefix from merchant names?**
The raw dataset prefixes every merchant with `fraud_`. Stripped in the staging layer so merchant names are clean and readable in downstream analysis and dashboards.

**Why exclude online categories from the velocity feature?**
Rapid consecutive online transactions are behaviorally normal. Filtering to in-store transactions ensures the feature reflects genuine physical impossibility.

**Why document zero-result findings?**
Impossible travel detection (flagging cards used across geographically impossible distances within a short window) returned zero results. This is documented as a valid finding — the dataset is simulated and does not reflect real geographic coordinates, making the feature non-applicable to this data.

---

## Dataset

[Credit Card Transactions Fraud Detection Dataset](https://www.kaggle.com/datasets/kartik2112/fraud-detection) — Kaggle

Simulated credit card transactions (Jan 2019 – Dec 2020) covering 1,000 customers and 800 merchants, generated using the Sparkov simulation tool.

