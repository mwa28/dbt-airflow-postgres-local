{{ config(materialized="view") }}
select
    *,
    case
        {{ dq_cast("unit_value") }}
        {{ dq_cast("expected_value") }}
        {{ dq_cast("actual_value") }}
        {{ dq_cast("date_of_reservation") }}
        {{ dq_cast("reservation_update_date") }}
        {{ dq_cast("date_of_contraction") }}
        {{ dq_cast("years_of_payment") }}
        {{ dq_notnull("id") }}
        {{ dq_notnull("lead_id") }}
        {{ dq_notnull("unit_location_id") }}
        {{ dq_notnull("property_type_id") }}
        {{ dq_notnull("sale_category_id") }}
        {{ dq_notnull("compound_id") }}
        {{ dq_notnull("area_id") }}
    end as dq_issue
from {{ ref("stg_sales") }}
