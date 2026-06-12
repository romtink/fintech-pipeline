
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select time_of_day
from Fintech_Pipeline.RAW_MARTS.fraud_by_hour
where time_of_day is null



  
  
      
    ) dbt_internal_test