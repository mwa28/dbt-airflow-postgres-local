{{ config(materialized="incremental", unique_key="property_type_id") }}
select distinct property_type, property_type_id
from {{ ref("clean_sales") }}
