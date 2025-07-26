-- Isso é um exemplo de materialização de um modelo de materialização incremental
-- Caso queiramos reconstruir o modelo incremental, o que vamos fazer é 
{{
  config(
    materialized = 'incremental',
    on_schema_change='fail'
  )
}}
WITH src_reviews AS (
  SELECT * FROM {{ ref('src_reviews') }}
)
SELECT 
  {{ dbt_utils.surrogate_key(['listing_id', 'review_date', 'reviewer_name', 'review_text']) }} 
  AS review_id,
  *
FROM src_reviews
WHERE review_text is not null
{% if is_incremental() %}
  AND review_date > (SELECT max(review_date) FROM {{ this }})
{% endif %}
