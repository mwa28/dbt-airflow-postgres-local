{{ config(materialized="incremental", unique_key="unit_location_id") }}
select distinct coalesce(unit_location, 'unknown') as unit_location, unit_location_id
from {{ ref("clean_sales") }}
