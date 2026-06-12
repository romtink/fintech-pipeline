
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select fraud_rate
from Fintech_Pipeline.RAW_MARTS.fraud_by_hour
where fraud_rate is null



  
  
      
    ) dbt_internal_test