{{ config(materialized="view") }}
select
    *,
    case
        {{ dq_cast("buyer") }}
        {{ dq_cast("seller") }}
        {{ dq_cast("commercial") }}
        {{ dq_cast("merged") }}
        {{ dq_cast("do_not_call") }}
        {{ dq_notnull("customer_id") }}
        {{ dq_notnull("lead_type_id") }}
    end as dq_issue
from {{ ref("stg_leads") }}
