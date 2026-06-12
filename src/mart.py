import duckdb
from pathlib import Path

# ROOT_DIR, DB_PATH, and con are defined once and reused for all mart tables
ROOT_DIR = Path(__file__).resolve().parent.parent
DB_PATH  = ROOT_DIR / "db" / "pipeline.duckdb"
con      = duckdb.connect(str(DB_PATH))

con.execute("CREATE SCHEMA IF NOT EXISTS marts")

# List of all mart tables to build — add new ones here as the project grows
marts = [
    ("fraud_by_category",       "fraud_by_category.sql"),
    ("fraud_by_hour",           "fraud_by_hour.sql"),
    ("fraudrisk_by_demographics","fraudrisk_by_demographics.sql"),
]

for table_name, sql_file in marts:
    sql_path = ROOT_DIR / "sql_marts" / sql_file

    con.execute(f"DROP TABLE IF EXISTS marts.{table_name}")

    sql = open(sql_path).read()
    print(f"Running: {sql_file}")
    con.execute(f"CREATE TABLE marts.{table_name} AS {sql}")

    count = con.execute(f"SELECT COUNT(*) FROM marts.{table_name}").fetchone()[0]
    print(f"marts.{table_name}: {count:,} rows")

con.close()