import duckdb
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parent.parent
DB_PATH  = ROOT_DIR / "db" / "pipeline.duckdb"
OUT_DIR  = ROOT_DIR / "data" / "exports"
OUT_DIR.mkdir(parents=True, exist_ok=True)

con = duckdb.connect(str(DB_PATH))

marts = [
    "fraud_by_category",
    "fraud_by_hour",
    "fraudrisk_by_demographics",
]

for mart in marts:
    df = con.execute(f"SELECT * FROM marts.{mart}").df()
    df.to_csv(OUT_DIR / f"{mart}.csv", index=False)
    print(f"Exported {mart}.csv — {len(df):,} rows")

con.close()