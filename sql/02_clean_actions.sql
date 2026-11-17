-- Clean actions table
-- One row per action a shopper took on the site.
-- Keeps only the columns we need, fixes data types, and adds labels.

CREATE OR REPLACE TABLE `ba-777-team7.lost_at_checkout.clean_actions` AS

SELECT
  -- Date and time of the action
  PARSE_DATE('%Y%m%d', event_date) AS action_date,
  TIMESTAMP_MICROS(event_timestamp) AS action_time,

  -- Shopper and visit
  user_pseudo_id AS user_id,
  (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS session_id,

  -- Action taken (page_view, add_to_cart, purchase, etc.)
  event_name AS action,

  -- Location and device
  CASE
    WHEN geo.country = '(not set)' THEN NULL
    ELSE geo.country
  END AS country,
  device.category AS device,

  -- How the shopper first found the store
  traffic_source.medium AS first_medium,
  CASE
    WHEN traffic_source.medium = 'organic'  THEN 'Organic Search'
    WHEN traffic_source.medium = 'cpc'      THEN 'Paid Search'
    WHEN traffic_source.medium = 'referral' THEN 'Referral'
    WHEN traffic_source.medium = '(none)'   THEN 'Direct'
    ELSE 'Unknown'
  END AS channel,

  -- Order details (filled in for purchases only)
  CASE
    WHEN ecommerce.transaction_id = '(not set)' THEN NULL
    ELSE ecommerce.transaction_id
  END AS order_id,
  ecommerce.purchase_revenue AS revenue,

  -- Key shopping days
  CASE
    WHEN event_date = '20201127' THEN 'Black Friday'
    WHEN event_date = '20201130' THEN 'Cyber Monday'
    WHEN event_date = '20201225' THEN 'Christmas Day'
    ELSE 'Regular Day'
  END AS holiday_day,

  -- Holiday season periods (numbered so they sort in order)
  CASE
    WHEN event_date <  '20201127' THEN '1. Early November'
    WHEN event_date <= '20201130' THEN '2. Black Friday to Cyber Monday'
    WHEN event_date <= '20201224' THEN '3. December Run-Up'
    WHEN event_date <= '20201231' THEN '4. Christmas Week'
    ELSE '5. January'
  END AS holiday_period

FROM `ba-777-team7.lost_at_checkout.raw_ga4_actions`;
