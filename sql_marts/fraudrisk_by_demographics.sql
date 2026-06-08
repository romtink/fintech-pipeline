-- This mart table profiles fraud victims by age group and gender.
-- Age buckets: Under 30, 30-50, Over 50
-- One row per age_group + gender combination

SELECT
    CASE -- Creates age buckets by taking the difference between transaction date and date of birth in years.
        WHEN DATEDIFF('year', date_of_birth, CAST(transaction_timestamp as DATE)) < 30 THEN 'Under 30'
        WHEN DATEDIFF('year', date_of_birth, CAST(transaction_timestamp as DATE)) BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END                                                                         AS age_group,
    gender,
    COUNT(*)                                                                    AS total_transactions,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END)                              AS fraud_count,
    ROUND(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fraud_rate_pct,
    ROUND(AVG(CASE WHEN is_fraud = 1 THEN amount END), 2)                       AS avg_fraud_amount
FROM staging.stg_transactions
GROUP BY 1, 2
ORDER BY fraud_rate_pct DESC