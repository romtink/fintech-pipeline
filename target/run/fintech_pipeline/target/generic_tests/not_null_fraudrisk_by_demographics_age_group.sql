
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select age_group
from Fintech_Pipeline.RAW_MARTS.fraudrisk_by_demographics
where age_group is null



  
  
      
    ) dbt_internal_test