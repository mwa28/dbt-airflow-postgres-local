{{ config(materialized="incremental", unique_key="id") }}

select
    {{ convert_dates("date_of_last_request") }} as date_of_last_request_cast,
    {{ convert_dates("created_at") }} as created_at_cast,
    {{ convert_dates("date_of_last_contact") }} as date_of_last_contact_cast,
    {{ convert_dates("updated_at") }} as updated_at_cast,
    {{ clean_string("campaign") }} as campaign,
    {{ clean_string("method_of_contact") }} as method_of_contact,
    {{ clean_string("lead_source") }} as lead_source,
    {{ clean_string("status_name") }} as status_name,
    {{ clean_string("location") }} as location,
    {{ clean_string("lead_type") }} as lead_type,
    {{ clean_ids("area_id") }} as area_id,
    {{ clean_ids("customer_id") }} as customer_id,
    {{ clean_ids("id") }} as id,
    {{ clean_ids("user_id") }} as user_id,
    {{ clean_ids("lead_type_id") }} as lead_type_id,
    {{ clean_string("best_time_to_call") }} as best_time_to_call,
    {{ convert_bool("buyer") }} as buyer_cast,
    {{ convert_bool("seller") }} as seller_cast,
    {{ convert_bool("commercial") }} as commercial_cast,
    {{ convert_bool("merged") }} as merged_cast,
    {{ convert_bool("do_not_call") }} as do_not_call_cast,
    {{
        dbt_utils.star(
            from=source("raw", "leads"),
            except=[
                "campaign",
                "method_of_contact",
                "lead_source",
                "status_name",
                "location",
                "area_id",
                "customer_id",
                "id",
                "user_id",
                "lead_type_id",
                "lead_type",
                "best_time_to_call",
                "copied_at",
            ],
        )
    }}
from {{ source("raw", "leads") }}
{% if is_incremental() %}
    where copied_at >= (select max(copied_at) from {{ this }})
{% endif %}
