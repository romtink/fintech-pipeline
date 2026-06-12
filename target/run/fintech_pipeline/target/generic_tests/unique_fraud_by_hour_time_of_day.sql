
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    time_of_day as unique_field,
    count(*) as n_records

from Fintech_Pipeline.RAW_MARTS.fraud_by_hour
where time_of_day is not null
group by time_of_day
having count(*) > 1



  
  
      
    ) dbt_internal_test