{{ config(materialized="incremental", unique_key="id") }}
select distinct
    {{
        dbt_utils.star(
            from=ref("clean_leads"),
        )
    }}
from {{ ref("clean_leads") }}
