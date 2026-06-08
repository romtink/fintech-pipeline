import duckdb
from pathlib import Path

# The following import variable logic allows the file path to be dynamic, enabling other users to replicate my code.

# ROOT_DIR takes the file currently opened and finds the path two levels above it.
ROOT_DIR = Path(__file__).resolve().parent.parent
# DB_PATH takes the ROOT_DIR file and adds /db/pipeline.duckdb/ to it.
DB_PATH  = ROOT_DIR / "db" / "pipeline.duckdb"
# SQL_PATH takes the ROOT_DIR file and adds /sql/staging/staging.sql to it.
SQL_PATH = ROOT_DIR / "sql" / "staging" / "staging.sql"

# Creating my connection variable again, this will be used going forward to run .execute code against my database.
con = duckdb.connect(str(DB_PATH))

# Creates my staging schema named "staging".
con.execute("CREATE SCHEMA IF NOT EXISTS staging")
con.execute("DROP TABLE IF EXISTS staging.stg_transactions")

# Creates a table named stg_transactions using the staging table SQL code I created in the "staging.sql" file.
sql = open(SQL_PATH).read()
con.execute(f"CREATE TABLE staging.stg_transactions AS {sql}")

# Counts the rows imported into the staging table and displays them via print function.
count = con.execute("SELECT COUNT(*) FROM staging.stg_transactions").fetchone()[0]
print(f"staging.stg_transactions: {count:,} rows")

# Checking to see if my slicing of the merchant values worked.
print("\nMerchant values:")
print(con.execute("SELECT DISTINCT merchant FROM staging.stg_transactions LIMIT 5").df())

#
print("\nSchema:")
print(con.execute("DESCRIBE staging.stg_transactions").df().to_string())
