import kagglehub

# Download latest version
path = kagglehub.dataset_download("kartik2112/fraud-detection")

print("Path to dataset files:", path)

import duckdb
import pandas as pd
import numpy as np
from pathlib import Path

# Created variables that store the path for the CSV dataset and the DuckDB database.
CSV_PATH = Path("/Users/romtinkharrazi/.cache/kagglehub/datasets/kartik2112/fraud-detection/versions/1/fraudTrain.csv")
DB_PATH  = Path("/Users/romtinkharrazi/Python Projects/fintech-pipeline/db/pipeline.duckdb")

# Created a connection variable to my DuckDB Database Path. This will be used in the future to reference this specific connection.
con = duckdb.connect(str(DB_PATH))

# Created a Schema and Table for the raw "fraudTrain" data.
con.execute("CREATE SCHEMA IF NOT EXISTS raw")
con.execute("DROP TABLE IF EXISTS raw.transactions")

# Imported everything from fraudTrain.csv into the raw.transactions table.
con.execute(f"""
    CREATE TABLE raw.transactions AS
    SELECT * FROM read_csv_auto('{CSV_PATH}', header=true)
""")

# Collected count of how many rows were imported, and printed the result using an f-string.
# Fetch one returns one row of the raw series. The row consists of a tuple. Adding "[0]" returns only the count we want.
count = con.execute("SELECT COUNT(*) FROM raw.transactions").fetchone()[0]
print(f"Loaded {count:,} rows into raw.transactions")

# Allows us to view the column names, column types, and additional information about the shape of our data
print(con.execute("DESCRIBE raw.transactions").df())

# This function forces all columns to display. 
pd.set_option('display.max_columns', None)

# Displays the first 5 rows of our data, allowing us to gather information on how to restructure the data going forward.
print(con.execute("SELECT * FROM raw.transactions LIMIT 5").df())

# I now have an idea what I want to restructure to transform the data 

# Renaming columns = 
#'column00':'index'
#'trans_date_trans_time':'transaction_timestamp'
#'cc_num':'card_number'
#'amt':'amount'
#'dob':'date_of_birth'
#'trans_num':'transaction_id'

# Primary Key = 'transaction_id'

# Value Manipulation =
# Column "merchant" has its values all beginning with "fraud_". I want to slice the values to appear with only the data.
        # ex: "fraud_Rippin, Kub and Mann" -> "Rippin, Kub and Mann"