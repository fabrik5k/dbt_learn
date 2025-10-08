-- Esses logss serao jogados em dbt.log
{% macro learn_logging() %}
  {{ log("Call your mom!", info=true) }}
  {# log("Call your dad!", info=true) #}
{% endmacro %}
