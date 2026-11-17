-- Check the clean countries table
-- One row per country; counts how many are missing each number
-- and how many had to fall back to 2019.

SELECT
  COUNT(*) AS countries,
  COUNT(DISTINCT country_code) AS unique_codes,
  COUNTIF(income_group IS NULL OR income_group = '') AS missing_income_group,
  COUNTIF(gdp_per_capita_usd IS NULL) AS missing_gdp,
  COUNTIF(gdp_year = 2019) AS gdp_from_2019,
  COUNTIF(internet_users_pct IS NULL) AS missing_internet,
  COUNTIF(internet_year = 2019) AS internet_from_2019,
  COUNTIF(population IS NULL) AS missing_population
FROM `ba-777-team7.lost_at_checkout.clean_countries`;
