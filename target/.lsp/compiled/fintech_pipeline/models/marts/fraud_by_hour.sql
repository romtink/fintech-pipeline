-- This code references the staging table to display fraud rate/count, total transactions, and average fraud amount grouped by hours of the day

WITH stg AS (
    SELECT * FROM Fintech_Pipeline.RAW_STAGING.stg_transactions
)

SELECT
    -- Defines hour logic for morning, afternoon, evening, and late night in six hour intervals
    CASE
        WHEN EXTRACT(hour FROM transaction_timestamp) BETWEEN 0 AND 5  THEN 'Late Night'
        WHEN EXTRACT(hour FROM transaction_timestamp) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN EXTRACT(hour FROM transaction_timestamp) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN EXTRACT(hour FROM transaction_timestamp) BETWEEN 18 AND 23 THEN 'Evening'
    END                                                                         AS time_of_day,
    COUNT(*)                                                                    AS total_transactions,
    SUM(CASE WHEN is_fraud = 1 THEN 1 END)                                     AS fraud_count,
    ROUND(SUM(CASE WHEN is_fraud = 1 THEN 1 END) * 100.0 / COUNT(*), 2)        AS fraud_rate,
    ROUND(AVG(CASE WHEN is_fraud = 1 THEN amount END), 2)                       AS avg_fraud_amount
FROM stg
GROUP BY 1
ORDER BY fraud_rate DESC