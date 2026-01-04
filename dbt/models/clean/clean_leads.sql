{{ config(materialized="incremental", unique_key="id") }}
select {{ get_casted_columns(ref("stg_leads")) }}
from {{ ref("leads_dq") }}
where dq_issue is null
