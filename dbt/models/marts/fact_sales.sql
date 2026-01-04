{{ config(materialized="incremental", unique_key="id") }}
select
    {{
        dbt_utils.star(
            from=ref("clean_sales"),
            except=[
                "property_type",
                "sale_category",
                "unit_location",
            ],
        )
    }}
from {{ ref("clean_sales") }}
