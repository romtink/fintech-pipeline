
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select total_transactions
from Fintech_Pipeline.RAW_MARTS.fraud_by_hour
where total_transactions is null



  
  
      
    ) dbt_internal_test