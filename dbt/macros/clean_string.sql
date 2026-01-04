{% macro clean_string(col) %}
    cast(lower(trim(replace(normalize({{ col }}), '_', ' '))) as text)
{% endmacro %}
