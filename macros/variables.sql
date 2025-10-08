-- O comando abaixo executara e mostrara as varaviveis printadas na tela
---  dbt run-operation learn_variables --vars '{"user_name":Fabio_dbt_teste}'
{% macro learn_variables() %}
  {% set your_name_jinja="Zoltan"  %}

  {{ log("Hello" ~ your_name_jinja, info=True) }}
  {{ log("Hello dbt user " ~ var("user_name", "NO USER NAME IS SET") ~ "!", info=True) }}
{% endmacro %}
