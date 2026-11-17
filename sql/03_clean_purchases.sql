-- Clean purchases table
-- One row per order. Repeated purchase records for the same order are combined.
-- Purchases without an order ID are kept and flagged.

CREATE OR REPLACE TABLE `ba-777-team7.lost_at_checkout.clean_purchases` AS

SELECT
  -- Unique order key: order ID + shopper (a few order IDs are shared by two shoppers).
  -- Purchases with no order ID use the purchase time instead.
  CONCAT(COALESCE(order_id, CONCAT('no-id-', CAST(action_time AS STRING))), '-', user_id) AS order_key,
  order_id,
  user_id,
  order_id IS NULL AS missing_order_id,

  -- When the order was placed
  MIN(action_date) AS purchase_date,
  MIN(action_time) AS purchase_time,

  -- Order value (blank when the data didn't record it)
  MAX(revenue) AS revenue,

  -- Shopper details
  MAX(country) AS country,
  MAX(device) AS device,
  MAX(channel) AS channel,
  MAX(holiday_day) AS holiday_day,
  MAX(holiday_period) AS holiday_period,

  -- How many purchase records were combined into this order
  COUNT(*) AS purchase_records

FROM `ba-777-team7.lost_at_checkout.clean_actions`
WHERE action = 'purchase'
GROUP BY order_key, order_id, user_id;
