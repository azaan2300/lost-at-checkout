-- Check the clean purchases table
-- total_orders and unique_order_keys should match (no duplicate orders).

SELECT
  COUNT(*) AS total_orders,
  COUNT(DISTINCT order_key) AS unique_order_keys,
  COUNTIF(missing_order_id) AS orders_missing_id,
  COUNTIF(revenue IS NULL) AS orders_missing_revenue,
  COUNTIF(purchase_records > 1) AS orders_combined,
  SUM(revenue) AS total_revenue,
  ROUND(AVG(revenue), 2) AS avg_order_value
FROM `ba-777-team7.lost_at_checkout.clean_purchases`;
