{{ config(materialized="incremental", unique_key="id") }}

select
    {{ convert_bigint("unit_value") }} as unit_value_cast,
    {{ convert_bigint("actual_value") }} as actual_value_cast,
    {{ convert_bigint("expected_value") }} as expected_value_cast,
    {{ convert_dates("date_of_reservation") }} as date_of_reservation_cast,
    {{ convert_dates("reservation_update_date") }} as reservation_update_date_cast,
    {{ convert_dates("date_of_contraction") }} as date_of_contraction_cast,
    abs(
        (
            'x' || substr(
                md5(coalesce({{ clean_string("sale_category") }}, 'Unknown')), 1, 16
            )
        )::bit(64)::bigint
    ) as sale_category_id,
    abs(
        (
            'x' || substr(
                md5(coalesce({{ clean_string("unit_location") }}, 'Unknown')), 1, 16
            )
        )::bit(64)::bigint
    ) as unit_location_id,
    {{ clean_string("sale_category") }} as sale_category,
    {{ clean_ids("area_id") }} as area_id,
    {{ clean_ids("compound_id") }} as compound_id,
    {{ clean_ids("id") }} as id,
    {{ clean_ids("lead_id") }} as lead_id,
    {{ clean_string("unit_location") }} as unit_location,
    {{ clean_string("property_type") }} as property_type,
    {{ convert_bigint("years_of_payment") }} as years_of_payment_cast,
    {{
        dbt_utils.star(
            from=source("raw", "sales"),
            except=[
                "area_id",
                "compound_id",
                "id",
                "lead_id",
                "unit_location",
                "property_type",
                "sale_category",
                "copied_at",
            ],
        )
    }}
from {{ source("raw", "sales") }}
{% if is_incremental() %}
    where copied_at >= (select max(copied_at) from {{ this }})
{% endif %}
