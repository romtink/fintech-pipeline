
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select total_transactions
from Fintech_Pipeline.RAW_MARTS.fraudrisk_by_demographics
where total_transactions is null



  
  
      
    ) dbt_internal_test