-- This mart table pre-aggregates by merchant category to allow insightful querying.

SELECT
category,
-- Displays fraud rate as a decimal rounded to two digits per category.
ROUND(SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) ,2) as fraud_rate,

-- Displays a count of all fraud committed under that category.
SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) as fraud_count,

-- Total transactions for each category.
COUNT(*) as total_transactions,

-- Average amount of fraudulent transactions for each category.
AVG(CASE WHEN is_fraud = 1 THEN amount END) as avg_fraud_amount

FROM staging.stg_transactions
GROUP BY 1
ORDER BY fraud_rate desc 
