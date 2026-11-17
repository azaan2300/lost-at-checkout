-- Check product prices and quantities in clean_items
-- Looks for missing, zero, or negative values and unusually high prices,
-- broken out by shopping step.

SELECT
  action,
  COUNT(*) AS item_rows,

  -- Price checks
  COUNTIF(price IS NULL) AS missing_price,
  COUNTIF(price = 0) AS zero_price,
  COUNTIF(price < 0) AS negative_price,
  MIN(price) AS min_price,
  ROUND(AVG(price), 2) AS avg_price,
  MAX(price) AS max_price,

  -- Quantity checks
  COUNTIF(quantity IS NULL) AS missing_quantity,
  COUNTIF(quantity <= 0) AS zero_or_negative_quantity,
  MAX(quantity) AS max_quantity
FROM `ba-777-team7.lost_at_checkout.clean_items`
GROUP BY action
ORDER BY item_rows DESC;
