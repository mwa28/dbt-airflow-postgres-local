{% macro convert_dates(col) %}
    case
        when {{ col }} ~ '^\d{1,2}/\d{1,2}/\d{4} \d{1,2}:\d{2}$'
        then to_timestamp({{ col }}, 'MM/DD/YYYY HH24:MI')
        else null
    end
{% endmacro %}
{% macro convert_bigint(col) %}
    case
        when {{ col }} ~ '^[0-9]+(\.[0-9]+)?$'
        then round(nullif({{ col }}, '')::numeric)::bigint
        else null
    end
{% endmacro %}
{% macro convert_bool(col) %}
    cast(
        (
            case
                when upper(coalesce({{ col }}::text, '')) = 'TRUE'
                then true
                when upper(coalesce({{ col }}::text, '')) = 'FALSE'
                then false
                else false
            end
        ) as boolean
    )
{% endmacro %}
