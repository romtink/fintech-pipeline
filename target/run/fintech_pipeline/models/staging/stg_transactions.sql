
  create or replace   view Fintech_Pipeline.RAW_STAGING.stg_transactions
  
  
  
  
  as (
    WITH source AS (
    SELECT * FROM FINTECH_PIPELINE.RAW.RAW
)

SELECT
    CAST(transaction_timestamp AS TIMESTAMP)        AS transaction_timestamp,
    card_number,
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
  );

