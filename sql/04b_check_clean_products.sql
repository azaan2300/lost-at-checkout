-- Check the clean products table
-- Shopping steps by product category, using the one-category-per-product lookup.
-- Products that never had a real category show as 'Uncategorized'.

SELECT
  IFNULL(p.product_category, 'Uncategorized') AS product_category,
  COUNT(DISTINCT i.item_id) AS products,
  COUNTIF(i.action = 'view_item') AS views,
  COUNTIF(i.action = 'add_to_cart') AS add_to_carts,
  COUNTIF(i.action = 'begin_checkout') AS checkouts,
  COUNTIF(i.action = 'purchase') AS purchases
FROM `ba-777-team7.lost_at_checkout.clean_items` AS i
LEFT JOIN `ba-777-team7.lost_at_checkout.clean_products` AS p
  ON i.item_id = p.item_id
GROUP BY product_category
ORDER BY views DESC;
