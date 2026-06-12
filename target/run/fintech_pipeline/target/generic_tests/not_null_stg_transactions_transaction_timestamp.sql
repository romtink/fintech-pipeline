
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select transaction_timestamp
from Fintech_Pipeline.RAW_STAGING.stg_transactions
where transaction_timestamp is null



  
  
      
    ) dbt_internal_test