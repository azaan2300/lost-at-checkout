-- Check the country join
-- Joins shoppers to World Bank countries and counts how many matched,
-- grouped by World Bank income group. Unmatched countries are listed by name.

SELECT
  IFNULL(c.income_group, 'No World Bank match') AS income_group,
  COUNT(DISTINCT a.country) AS countries,
  COUNT(DISTINCT a.user_id) AS shoppers,
  STRING_AGG(DISTINCT CASE WHEN c.country_code IS NULL THEN IFNULL(a.country, '(blank)') END) AS unmatched_countries
FROM `ba-777-team7.lost_at_checkout.clean_actions` AS a
LEFT JOIN `ba-777-team7.lost_at_checkout.clean_countries` AS c
  ON a.country = c.ga4_country
GROUP BY income_group
ORDER BY shoppers DESC;
