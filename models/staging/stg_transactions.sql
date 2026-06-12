-- This file creates my staging table, referencing my raw data. All it does is clean up certain values (rounding, REGEXP_REPLACE,casting, and enforces non-null primary key)

WITH source AS (
    SELECT * FROM {{ source('raw', 'RAW') }}
)

SELECT
    CAST(transaction_timestamp AS TIMESTAMP)        AS transaction_timestamp,
    card_number,
    -- The values for merchants all begin with the prefix 'fraud_'. This REGEXP_REPLACE function cleans that up for analytical purposes.
    REGEXP_REPLACE(merchant, '^fraud_', '')         AS merchant,
    category,
    ROUND(amount, 2)                                AS amount,
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
    CAST(date_of_birth AS DATE)                     AS date_of_birth,
    transaction_id,
    merch_lat,
    merch_long,
    is_fraud
FROM source
WHERE transaction_id IS NOT NULL