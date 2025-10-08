-- Esse é um exemplo de macro que pode ser usado como função
-- genérica do dbt.
{% test positive_value(model, column_name) %}
SELECT
  *
FROM
  {{ model }}
WHERE
  {{ column_name }} < 1
{% endtest %}
