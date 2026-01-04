{% macro clean_ids(col) %} trim(coalesce({{ col }}, '0')) {% endmacro %}
