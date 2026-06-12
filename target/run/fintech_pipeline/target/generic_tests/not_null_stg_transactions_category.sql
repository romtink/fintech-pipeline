
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select category
from Fintech_Pipeline.RAW_STAGING.stg_transactions
where category is null



  
  
      
    ) dbt_internal_test