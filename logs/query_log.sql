-- created_at: 2026-06-12T05:40:46.889350+00:00
-- finished_at: 2026-06-12T05:40:49.104779+00:00
-- elapsed: 2.2s
-- outcome: success
-- dialect: snowflake
-- node_id: not available
-- query_id: 01c4fe54-0305-dfb8-000e-8dc2000471ae
-- desc: execute adapter call
with tables as (
            select
        table_catalog as "table_database",
        table_schema as "table_schema",
        table_name as "table_name",
        case
            when is_dynamic = 'YES' and table_type = 'BASE TABLE' THEN 'DYNAMIC TABLE'
            else table_type
        end as "table_type",
        comment as "table_comment",

        -- note: this is the _role_ that owns the table
        table_owner as "table_owner",

        'Clustering Key' as "stats:clustering_key:label",
        clustering_key as "stats:clustering_key:value",
        'The key used to cluster this table' as "stats:clustering_key:description",
        (clustering_key is not null) as "stats:clustering_key:include",

        'Row Count' as "stats:row_count:label",
        row_count as "stats:row_count:value",
        'An approximate count of rows in this table' as "stats:row_count:description",
        (row_count is not null) as "stats:row_count:include",

        'Approximate Size' as "stats:bytes:label",
        bytes as "stats:bytes:value",
        'Approximate size of the table as reported by Snowflake' as "stats:bytes:description",
        (bytes is not null) as "stats:bytes:include",

        'Last Modified' as "stats:last_modified:label",
        to_varchar(convert_timezone('UTC', last_altered), 'yyyy-mm-dd HH24:MI'||'UTC') as "stats:last_modified:value",
        'The timestamp for last update/change' as "stats:last_modified:description",
        (last_altered is not null and table_type='BASE TABLE') as "stats:last_modified:include"
    from FINTECH_PIPELINE.INFORMATION_SCHEMA.tables 
            where (
                (
                    
    "table_schema" ilike 'RAW' and upper("table_schema") = upper('RAW')

                    and 
    "table_name" ilike 'RAW' and upper("table_name") = upper('RAW')

                )
            )
        ),
        columns as (
            select
        table_catalog as "table_database",
        table_schema as "table_schema",
        table_name as "table_name",

        column_name as "column_name",
        ordinal_position as "column_index",
        data_type as "column_type",
        comment as "column_comment"
    from FINTECH_PIPELINE.INFORMATION_SCHEMA.columns 
            where (
                (
                    
    "table_schema" ilike 'RAW' and upper("table_schema") = upper('RAW')

                    and 
    "table_name" ilike 'RAW' and upper("table_name") = upper('RAW')

                )
            )
        )
        select *
    from tables
    join columns using ("table_database", "table_schema", "table_name")
    order by "column_index"
/* {"app": "dbt", "connection_name": "", "dbt_version": "2.0.0", "profile_name": "fintech_pipeline", "target_name": "dev"} */;
-- created_at: 2026-06-12T05:40:46.911887+00:00
-- finished_at: 2026-06-12T05:40:49.104779+00:00
-- elapsed: 2.2s
-- outcome: success
-- dialect: snowflake
-- node_id: not available
-- query_id: 01c4fe54-0305-da8f-000e-8dc20002c2ee
-- desc: execute adapter call
with tables as (
            select
        table_catalog as "table_database",
        table_schema as "table_schema",
        table_name as "table_name",
        case
            when is_dynamic = 'YES' and table_type = 'BASE TABLE' THEN 'DYNAMIC TABLE'
            else table_type
        end as "table_type",
        comment as "table_comment",

        -- note: this is the _role_ that owns the table
        table_owner as "table_owner",

        'Clustering Key' as "stats:clustering_key:label",
        clustering_key as "stats:clustering_key:value",
        'The key used to cluster this table' as "stats:clustering_key:description",
        (clustering_key is not null) as "stats:clustering_key:include",

        'Row Count' as "stats:row_count:label",
        row_count as "stats:row_count:value",
        'An approximate count of rows in this table' as "stats:row_count:description",
        (row_count is not null) as "stats:row_count:include",

        'Approximate Size' as "stats:bytes:label",
        bytes as "stats:bytes:value",
        'Approximate size of the table as reported by Snowflake' as "stats:bytes:description",
        (bytes is not null) as "stats:bytes:include",

        'Last Modified' as "stats:last_modified:label",
        to_varchar(convert_timezone('UTC', last_altered), 'yyyy-mm-dd HH24:MI'||'UTC') as "stats:last_modified:value",
        'The timestamp for last update/change' as "stats:last_modified:description",
        (last_altered is not null and table_type='BASE TABLE') as "stats:last_modified:include"
    from Fintech_Pipeline.INFORMATION_SCHEMA.tables 
            where (
                (
                    
    "table_schema" ilike 'RAW_STAGING' and upper("table_schema") = upper('RAW_STAGING')

                    and 
    "table_name" ilike 'stg_transactions' and upper("table_name") = upper('stg_transactions')

                )
            )
        ),
        columns as (
            select
        table_catalog as "table_database",
        table_schema as "table_schema",
        table_name as "table_name",

        column_name as "column_name",
        ordinal_position as "column_index",
        data_type as "column_type",
        comment as "column_comment"
    from Fintech_Pipeline.INFORMATION_SCHEMA.columns 
            where (
                (
                    
    "table_schema" ilike 'RAW_STAGING' and upper("table_schema") = upper('RAW_STAGING')

                    and 
    "table_name" ilike 'stg_transactions' and upper("table_name") = upper('stg_transactions')

                )
            )
        )
        select *
    from tables
    join columns using ("table_database", "table_schema", "table_name")
    order by "column_index"
/* {"app": "dbt", "connection_name": "", "dbt_version": "2.0.0", "profile_name": "fintech_pipeline", "target_name": "dev"} */;
-- created_at: 2026-06-12T05:40:46.919486+00:00
-- finished_at: 2026-06-12T05:40:49.258122+00:00
-- elapsed: 2.3s
-- outcome: success
-- dialect: snowflake
-- node_id: not available
-- query_id: 01c4fe54-0305-da8f-000e-8dc20002c2f2
-- desc: execute adapter call
with tables as (
            select
        table_catalog as "table_database",
        table_schema as "table_schema",
        table_name as "table_name",
        case
            when is_dynamic = 'YES' and table_type = 'BASE TABLE' THEN 'DYNAMIC TABLE'
            else table_type
        end as "table_type",
        comment as "table_comment",

        -- note: this is the _role_ that owns the table
        table_owner as "table_owner",

        'Clustering Key' as "stats:clustering_key:label",
        clustering_key as "stats:clustering_key:value",
        'The key used to cluster this table' as "stats:clustering_key:description",
        (clustering_key is not null) as "stats:clustering_key:include",

        'Row Count' as "stats:row_count:label",
        row_count as "stats:row_count:value",
        'An approximate count of rows in this table' as "stats:row_count:description",
        (row_count is not null) as "stats:row_count:include",

        'Approximate Size' as "stats:bytes:label",
        bytes as "stats:bytes:value",
        'Approximate size of the table as reported by Snowflake' as "stats:bytes:description",
        (bytes is not null) as "stats:bytes:include",

        'Last Modified' as "stats:last_modified:label",
        to_varchar(convert_timezone('UTC', last_altered), 'yyyy-mm-dd HH24:MI'||'UTC') as "stats:last_modified:value",
        'The timestamp for last update/change' as "stats:last_modified:description",
        (last_altered is not null and table_type='BASE TABLE') as "stats:last_modified:include"
    from Fintech_Pipeline.INFORMATION_SCHEMA.tables 
            where (
                (
                    
    "table_schema" ilike 'RAW_MARTS' and upper("table_schema") = upper('RAW_MARTS')

                    and 
    "table_name" ilike 'fraud_by_category' and upper("table_name") = upper('fraud_by_category')

                )
             or 
                (
                    
    "table_schema" ilike 'RAW_MARTS' and upper("table_schema") = upper('RAW_MARTS')

                    and 
    "table_name" ilike 'fraud_by_hour' and upper("table_name") = upper('fraud_by_hour')

                )
             or 
                (
                    
    "table_schema" ilike 'RAW_MARTS' and upper("table_schema") = upper('RAW_MARTS')

                    and 
    "table_name" ilike 'fraudrisk_by_demographics' and upper("table_name") = upper('fraudrisk_by_demographics')

                )
            )
        ),
        columns as (
            select
        table_catalog as "table_database",
        table_schema as "table_schema",
        table_name as "table_name",

        column_name as "column_name",
        ordinal_position as "column_index",
        data_type as "column_type",
        comment as "column_comment"
    from Fintech_Pipeline.INFORMATION_SCHEMA.columns 
            where (
                (
                    
    "table_schema" ilike 'RAW_MARTS' and upper("table_schema") = upper('RAW_MARTS')

                    and 
    "table_name" ilike 'fraud_by_category' and upper("table_name") = upper('fraud_by_category')

                )
             or 
                (
                    
    "table_schema" ilike 'RAW_MARTS' and upper("table_schema") = upper('RAW_MARTS')

                    and 
    "table_name" ilike 'fraud_by_hour' and upper("table_name") = upper('fraud_by_hour')

                )
             or 
                (
                    
    "table_schema" ilike 'RAW_MARTS' and upper("table_schema") = upper('RAW_MARTS')

                    and 
    "table_name" ilike 'fraudrisk_by_demographics' and upper("table_name") = upper('fraudrisk_by_demographics')

                )
            )
        )
        select *
    from tables
    join columns using ("table_database", "table_schema", "table_name")
    order by "column_index"
/* {"app": "dbt", "connection_name": "", "dbt_version": "2.0.0", "profile_name": "fintech_pipeline", "target_name": "dev"} */;
-- created_at: 2026-06-12T05:40:46.961921+00:00
-- finished_at: 2026-06-12T05:40:49.281312+00:00
-- elapsed: 2.3s
-- outcome: success
-- dialect: snowflake
-- node_id: not available
-- query_id: 01c4fe54-0305-da8f-000e-8dc20002c2f6
-- desc: execute adapter call
with tables as (
            select
        table_catalog as "table_database",
        table_schema as "table_schema",
        table_name as "table_name",
        case
            when is_dynamic = 'YES' and table_type = 'BASE TABLE' THEN 'DYNAMIC TABLE'
            else table_type
        end as "table_type",
        comment as "table_comment",

        -- note: this is the _role_ that owns the table
        table_owner as "table_owner",

        'Clustering Key' as "stats:clustering_key:label",
        clustering_key as "stats:clustering_key:value",
        'The key used to cluster this table' as "stats:clustering_key:description",
        (clustering_key is not null) as "stats:clustering_key:include",

        'Row Count' as "stats:row_count:label",
        row_count as "stats:row_count:value",
        'An approximate count of rows in this table' as "stats:row_count:description",
        (row_count is not null) as "stats:row_count:include",

        'Approximate Size' as "stats:bytes:label",
        bytes as "stats:bytes:value",
        'Approximate size of the table as reported by Snowflake' as "stats:bytes:description",
        (bytes is not null) as "stats:bytes:include",

        'Last Modified' as "stats:last_modified:label",
        to_varchar(convert_timezone('UTC', last_altered), 'yyyy-mm-dd HH24:MI'||'UTC') as "stats:last_modified:value",
        'The timestamp for last update/change' as "stats:last_modified:description",
        (last_altered is not null and table_type='BASE TABLE') as "stats:last_modified:include"
    from Fintech_Pipeline.INFORMATION_SCHEMA.tables 
            where (
                (
                    
    "table_schema" ilike 'RAW_raw' and upper("table_schema") = upper('RAW_raw')

                    and 
    "table_name" ilike 'raw_customers' and upper("table_name") = upper('raw_customers')

                )
             or 
                (
                    
    "table_schema" ilike 'RAW_raw' and upper("table_schema") = upper('RAW_raw')

                    and 
    "table_name" ilike 'raw_items' and upper("table_name") = upper('raw_items')

                )
             or 
                (
                    
    "table_schema" ilike 'RAW_raw' and upper("table_schema") = upper('RAW_raw')

                    and 
    "table_name" ilike 'raw_orders' and upper("table_name") = upper('raw_orders')

                )
             or 
                (
                    
    "table_schema" ilike 'RAW_raw' and upper("table_schema") = upper('RAW_raw')

                    and 
    "table_name" ilike 'raw_products' and upper("table_name") = upper('raw_products')

                )
             or 
                (
                    
    "table_schema" ilike 'RAW_raw' and upper("table_schema") = upper('RAW_raw')

                    and 
    "table_name" ilike 'raw_stores' and upper("table_name") = upper('raw_stores')

                )
             or 
                (
                    
    "table_schema" ilike 'RAW_raw' and upper("table_schema") = upper('RAW_raw')

                    and 
    "table_name" ilike 'raw_supplies' and upper("table_name") = upper('raw_supplies')

                )
            )
        ),
        columns as (
            select
        table_catalog as "table_database",
        table_schema as "table_schema",
        table_name as "table_name",

        column_name as "column_name",
        ordinal_position as "column_index",
        data_type as "column_type",
        comment as "column_comment"
    from Fintech_Pipeline.INFORMATION_SCHEMA.columns 
            where (
                (
                    
    "table_schema" ilike 'RAW_raw' and upper("table_schema") = upper('RAW_raw')

                    and 
    "table_name" ilike 'raw_customers' and upper("table_name") = upper('raw_customers')

                )
             or 
                (
                    
    "table_schema" ilike 'RAW_raw' and upper("table_schema") = upper('RAW_raw')

                    and 
    "table_name" ilike 'raw_items' and upper("table_name") = upper('raw_items')

                )
             or 
                (
                    
    "table_schema" ilike 'RAW_raw' and upper("table_schema") = upper('RAW_raw')

                    and 
    "table_name" ilike 'raw_orders' and upper("table_name") = upper('raw_orders')

                )
             or 
                (
                    
    "table_schema" ilike 'RAW_raw' and upper("table_schema") = upper('RAW_raw')

                    and 
    "table_name" ilike 'raw_products' and upper("table_name") = upper('raw_products')

                )
             or 
                (
                    
    "table_schema" ilike 'RAW_raw' and upper("table_schema") = upper('RAW_raw')

                    and 
    "table_name" ilike 'raw_stores' and upper("table_name") = upper('raw_stores')

                )
             or 
                (
                    
    "table_schema" ilike 'RAW_raw' and upper("table_schema") = upper('RAW_raw')

                    and 
    "table_name" ilike 'raw_supplies' and upper("table_name") = upper('raw_supplies')

                )
            )
        )
        select *
    from tables
    join columns using ("table_database", "table_schema", "table_name")
    order by "column_index"
/* {"app": "dbt", "connection_name": "", "dbt_version": "2.0.0", "profile_name": "fintech_pipeline", "target_name": "dev"} */;
