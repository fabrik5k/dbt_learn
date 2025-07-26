SELECT 
  * 
FROM
  {{ ref('fact_reviews') }} fact_reviews
JOIN 
  {{ ref('dim_listings_cleansed') }} dim_listings 
  ON
    (fact_reviews.listing_id=dim_listings.listing_id)
WHERE 1=1
  AND fact_reviews.review_date < dim_listings.created_at
