{% macro dq_cast(col, label=None) %}
    {%- set raw_col = col %}
    {%- set clean_col = col ~ "_cast" %}

    when {{ raw_col }} is not null and {{ clean_col }} is null
    then 'Invalid ' || {{ label or "'" ~ col ~ "'" }}
{% endmacro %}

{% macro dq_notnull(col, label=None) %}
    when {{ col }} is null then {{ label or "'" ~ col ~ "'" }} || ' cannot be null'
{% endmacro %}
