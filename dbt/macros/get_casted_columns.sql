{% macro get_casted_columns(relation) %}
    {% set cols = adapter.get_columns_in_relation(relation) %}
    {% set select_list = [] %}

    {% for col in cols %}
        {% set col_name = col.name %}
        {% set col_type = col.data_type | lower %}

        {# 1. If a _cast version exists, use it and rename #}
        {% if col_name.endswith("_cast") %}
            {% set new_name = col_name[:-5] %}
            {% do select_list.append(col_name ~ " as " ~ new_name) %}

            {# 2. If this column has a _cast sibling, skip the raw version #}
            {% elif (col_name ~ "_cast") in cols | map(attribute="name") %}
            {# skip raw version #}
            {# 3. If column is VARCHAR, cast to TEXT #}
            {% elif "varchar" in col_type or "character varying" in col_type %}
            {% do select_list.append("cast(" ~ col_name ~ " as text) as " ~ col_name) %}

        {# 4. Otherwise, keep column as-is #}
        {% else %} {% do select_list.append(col_name) %}
        {% endif %}
    {% endfor %}

    {{ select_list | join(",\n    ") }}
{% endmacro %}
