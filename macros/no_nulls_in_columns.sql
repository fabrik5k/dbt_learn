-- Essa macro funciona como se fosse uma função comum numa
-- linguagem de programação, que recebe como parametro um 
-- modelo dbt sql e pra cada coluna dentro desse modelo ele 
-- vai verificar se há alguma coluna nula
{% macro no_nulls_in_columns(model) %}
  SELECT * 
  FROM {{ model }} 
  WHERE
  {% for col in adapter.get_columns_in_relation(model) -%}
    {{ col.column }} IS NULL OR
  {% endfor %}
  FALSE
{% endmacro %}
