{{ config(materialized="incremental", unique_key="sale_category_id") }}
select distinct coalesce(sale_category, 'Unknown') as sale_category, sale_category_id
from {{ ref("clean_sales") }}
