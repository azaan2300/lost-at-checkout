-- Check the clean items table
-- Rows per shopping step, and how many products landed in each clean category.

SELECT
  category,
  COUNT(*) AS item_rows,
  COUNT(DISTINCT item_id) AS products,
  COUNTIF(action = 'view_item') AS views,
  COUNTIF(action = 'add_to_cart') AS add_to_carts,
  COUNTIF(action = 'begin_checkout') AS checkouts,
  COUNTIF(action = 'purchase') AS purchases,
  COUNTIF(price IS NULL) AS missing_price
FROM `ba-777-team7.lost_at_checkout.clean_items`
GROUP BY category
ORDER BY item_rows DESC;
