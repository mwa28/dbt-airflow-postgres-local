{{
    config(
        materialized="incremental",
        unique_key="id",
    )
}}
select {{ get_casted_columns(ref("stg_sales")) }}
from {{ ref("sales_dq") }}
where dq_issue is null
