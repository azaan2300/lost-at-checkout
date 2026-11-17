-- Check the clean actions table
-- Row count should match the original data (4,295,584 rows).

SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT user_id) AS total_shoppers,
  MIN(action_date) AS first_date,
  MAX(action_date) AS last_date,
  COUNTIF(session_id IS NULL) AS missing_session_id,
  COUNTIF(country IS NULL) AS missing_country,
  COUNTIF(action = 'purchase') AS purchases,
  COUNTIF(action = 'purchase' AND order_id IS NULL) AS purchases_missing_order_id
FROM `ba-777-team7.lost_at_checkout.clean_actions`;
