
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    category as unique_field,
    count(*) as n_records

from Fintech_Pipeline.RAW_MARTS.fraud_by_category
where category is not null
group by category
having count(*) > 1



  
  
      
    ) dbt_internal_test