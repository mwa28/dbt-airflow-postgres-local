select
    {{
        dbt_utils.star(
            from=ref("stg_sales"),
        )
    }},
    dq_issue
from {{ ref("sales_dq") }}
where dq_issue is not null
