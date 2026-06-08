-- Here I am creating a staging table from the raw data. The goal is here is to keep the raw data untouched.
-- I renamed a couple columns for simplicity purposes and dropped the index column "column00".

SELECT
    -- Ensuring dates save as date types.
    CAST(trans_date_trans_time as TIMESTAMP)   AS transaction_timestamp,
    cc_num                                     AS card_number,
    -- I'm using REGEXP_REPLACE to drop the prefix "fraud_" from all values of the merchant column.
    REGEXP_REPLACE(merchant, '^fraud_', '')    AS merchant,
    category,
    -- Rounded amount to two decimals.
    ROUND(amt,2)                               AS amount,
    first,
    last,
    gender,
    street,
    city,
    state,
    zip,
    lat,
    long,
    city_pop,
    job,
    -- Ensuring dates save as date types.
    CAST(dob as DATE)                          AS date_of_birth,
    -- The transaction_id field is going to be the primary key, even though you can't enforce it in DuckDB.
    trans_num                                  AS transaction_id,
    merch_lat,
    merch_long,
    is_fraud
FROM raw.transactions
-- Ensuring that the primary key is not null
WHERE trans_num IS NOT NULL