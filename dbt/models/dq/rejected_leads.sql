select
    {{
        dbt_utils.star(
            from=ref("stg_leads"),
        )
    }},
    dq_issue
from {{ ref("leads_dq") }}
where dq_issue is not null
