
    
    

select
    category as unique_field,
    count(*) as n_records

from Fintech_Pipeline.RAW_MARTS.fraud_by_category
where category is not null
group by category
having count(*) > 1


