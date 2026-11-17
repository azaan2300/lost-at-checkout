-- Clean products table
-- One row per product, with one category it keeps at every shopping step.
-- Google sometimes labels the same product differently (or leaves it blank)
-- at checkout and purchase, so each product gets the category it carries most often.
-- Join to clean_items on item_id.

CREATE OR REPLACE TABLE `ba-777-team7.lost_at_checkout.clean_products` AS

-- How often each product appears under each category
WITH label_counts AS (
  SELECT
    item_id,
    category,
    COUNT(*) AS times_seen
  FROM `ba-777-team7.lost_at_checkout.clean_items`
  WHERE category NOT IN ('Uncategorized', 'Other')
  GROUP BY item_id, category
),

-- The highest count for each product
top_counts AS (
  SELECT
    item_id,
    MAX(times_seen) AS max_times_seen
  FROM label_counts
  GROUP BY item_id
)

-- Keep the most common category (ties broken alphabetically)
SELECT
  label_counts.item_id,
  MIN(label_counts.category) AS product_category
FROM label_counts
JOIN top_counts
  ON label_counts.item_id = top_counts.item_id
  AND label_counts.times_seen = top_counts.max_times_seen
GROUP BY label_counts.item_id;
