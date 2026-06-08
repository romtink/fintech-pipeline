-- This mart table aims to answer the question of if time of day affects likelihood of fraud occuring

SELECT
    CASE
        WHEN EXTRACT(hour FROM transaction_timestamp) BETWEEN 0 AND 5 THEN 'Late Night'
        WHEN EXTRACT(hour FROM transaction_timestamp) BETWEEN 6 and 11 THEN 'Morning'
        WHEN EXTRACT(hour FROM transaction_timestamp) BETWEEN 12 and 17 THEN 'Afternoon'
        WHEN EXTRACT(hour FROM transaction_timestamp) BETWEEN 18 and 23 THEN 'Evening'
    END AS time_of_day,
    COUNT(*) as total_transactions,
    SUM(CASE WHEN is_fraud = 1 THEN 1 END) as fraud_count,
    ROUND((SUM(CASE WHEN is_fraud = 1 THEN 1 END) * 100.0) / COUNT(*),2) as fraud_rate,
    ROUND(AVG(CASE WHEN is_fraud = 1 THEN amount END),2) as avg_fraud_amount
FROM staging.stg_transactions
GROUP BY 1
ORDER BY fraud_rate desc



