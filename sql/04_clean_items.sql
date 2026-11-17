-- Clean items table
-- One row per product per shopping step (viewed, added to cart, checkout, purchased).
-- Products with no name or price ('(not set)') are removed.
-- Quantity is kept only for checkout and purchase rows.
-- The 82 messy category labels are grouped into 12 clean categories.

CREATE OR REPLACE TABLE `ba-777-team7.lost_at_checkout.clean_items` AS

SELECT
  -- When and who
  PARSE_DATE('%Y%m%d', event_date) AS action_date,
  user_pseudo_id AS user_id,
  (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS session_id,

  -- Shopping step
  event_name AS action,

  -- Product details
  item.item_id,
  item.item_name,
  item.price,
  item.item_revenue,

  -- Quantity is only reliable at checkout and purchase
  -- (blank or impossible values like 2 billion units on views and add-to-carts)
  CASE
    WHEN event_name IN ('begin_checkout', 'purchase') THEN item.quantity
    ELSE NULL
  END AS quantity,

  -- Original category label (kept for reference)
  item.item_category AS category_raw,

  -- Clean category (checked in order, first match wins)
  CASE
    WHEN item.item_category IS NULL
      OR item.item_category IN ('', '(not set)', 'Uncategorized Items') THEN 'Uncategorized'
    WHEN LOWER(item.item_category) LIKE '%sale%'
      OR LOWER(item.item_category) LIKE '%clearance%' THEN 'Sale & Clearance'
    WHEN LOWER(item.item_category) LIKE '%new%' THEN 'New Arrivals'
    WHEN LOWER(item.item_category) LIKE '%apparel%'
      OR LOWER(item.item_category) LIKE '%t-shirt%'
      OR LOWER(item.item_category) LIKE '%men%'
      OR LOWER(item.item_category) LIKE '%kid%'
      OR LOWER(item.item_category) LIKE '%hats%'
      OR LOWER(item.item_category) LIKE '%socks%'
      OR LOWER(item.item_category) LIKE '%warm gear%' THEN 'Apparel'
    WHEN LOWER(item.item_category) LIKE '%drinkware%'
      OR LOWER(item.item_category) LIKE '%mug%'
      OR LOWER(item.item_category) LIKE '%water bottle%' THEN 'Drinkware'
    WHEN LOWER(item.item_category) LIKE '%bag%'
      OR LOWER(item.item_category) LIKE '%backpack%'
      OR LOWER(item.item_category) LIKE '%totes%' THEN 'Bags'
    WHEN LOWER(item.item_category) LIKE '%stationery%'
      OR LOWER(item.item_category) LIKE '%notebook%'
      OR LOWER(item.item_category) LIKE '%writing%'
      OR LOWER(item.item_category) LIKE '%sticker%'
      OR LOWER(item.item_category) LIKE '%office%' THEN 'Stationery & Office'
    WHEN LOWER(item.item_category) LIKE '%brand%'
      OR item.item_category IN ('Google', 'YouTube', 'Android') THEN 'Brand Collections'
    WHEN LOWER(item.item_category) LIKE '%campus%' THEN 'Campus Collection'
    WHEN LOWER(item.item_category) LIKE '%eco-friendly%' THEN 'Eco-Friendly'
    WHEN LOWER(item.item_category) LIKE '%gift card%' THEN 'Gift Cards'
    WHEN LOWER(item.item_category) LIKE '%lifestyle%'
      OR LOWER(item.item_category) LIKE '%small goods%'
      OR LOWER(item.item_category) LIKE '%accessor%'
      OR LOWER(item.item_category) LIKE '%electronic%'
      OR LOWER(item.item_category) LIKE '%fun%' THEN 'Lifestyle & Accessories'
    ELSE 'Other'
  END AS category

FROM `ba-777-team7.lost_at_checkout.raw_ga4_actions`,
  UNNEST(items) AS item
WHERE event_name IN ('view_item', 'add_to_cart', 'begin_checkout', 'purchase')
  AND item.item_name IS NOT NULL
  AND item.item_name <> '(not set)';
