
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select fraud_rate_pct
from Fintech_Pipeline.RAW_MARTS.fraudrisk_by_demographics
where fraud_rate_pct is null



  
  
      
    ) dbt_internal_test