# Attempting to do exploratory analysis on the staging data for any possible reasons for fraud.

import duckdb
import pandas as pd
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parent.parent
DB_PATH  = ROOT_DIR / "db" / "pipeline.duckdb"

con = duckdb.connect(str(DB_PATH))

pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', 50)

# Loading in staged data.
stg_transactions = con.execute("SELECT * FROM staging.stg_transactions").df()

# Removing online transactions for the purposes of this analysis, it is possible to purchase online in rapid intervals.
df = stg_transactions[~stg_transactions['category'].str.endswith('_net')]
df['unique_user'] = df['first'] + " " + df['last'] + " " + df['city']
df = df.sort_values(['unique_user','transaction_timestamp'])

user_grouped = df[['unique_user','transaction_timestamp','category','state','is_fraud']]

# Calculated the previous transaction timestamp in the current row using shift(n) method.
user_grouped['prev_timestamp'] = user_grouped.groupby('unique_user')['transaction_timestamp'].shift(1)

# Calculated time between current transaction and previous transaction.
user_grouped['difference'] = user_grouped['transaction_timestamp'] - user_grouped['prev_timestamp']

# Impossible purchase returns rows only where there was a previous point-of-sale transaction within 2 minutes
impossible_purchase = user_grouped[(user_grouped['difference'] < pd.Timedelta(minutes=2))]
print(impossible_purchase['is_fraud'].value_counts())
print(stg_transactions['is_fraud'].value_counts())

# FINDINGS: Results show a 1.4% fraud rate vs a 0.58% fraud rate.
# Transactions succeeding a previous transaction within 2 minutes are 2.4x more likely to be fraudulent. 

impossible_purchase.to_csv(ROOT_DIR / "data" / "exports" / "velocity_flags.csv", index=False)
