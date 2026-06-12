-- This code references the staging table to create a mart table displaying fraud rate, count, total transactions, and average fraud amount aggregated by category

WITH stg AS (
    SELECT * FROM Fintech_Pipeline.RAW_STAGING.stg_transactions
)

SELECT
    category,
    ROUND(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)  AS fraud_rate,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END)                                AS fraud_count,
    COUNT(*)                                                                      AS total_transactions,
    AVG(CASE WHEN is_fraud = 1 THEN amount END)                                  AS avg_fraud_amount
FROM stg
GROUP BY 1
ORDER BY fraud_rate DESC