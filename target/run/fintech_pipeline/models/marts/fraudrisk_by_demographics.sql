
  
    



create or replace transient  table Fintech_Pipeline.RAW_MARTS.fraudrisk_by_demographics
    
    
    
    
    as (WITH stg AS (
    SELECT * FROM Fintech_Pipeline.RAW_STAGING.stg_transactions
)

SELECT
    CASE
        WHEN DATEDIFF('year', date_of_birth, CAST(transaction_timestamp AS DATE)) < 30        THEN 'Under 30'
        WHEN DATEDIFF('year', date_of_birth, CAST(transaction_timestamp AS DATE)) BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END                                                                         AS age_group,
    gender,
    COUNT(*)                                                                    AS total_transactions,
    SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END)                              AS fraud_count,
    ROUND(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fraud_rate_pct,
    ROUND(AVG(CASE WHEN is_fraud = 1 THEN amount END), 2)                       AS avg_fraud_amount
FROM stg
GROUP BY 1, 2
ORDER BY fraud_rate_pct DESC
    )
;



  