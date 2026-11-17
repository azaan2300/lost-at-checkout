-- Clean countries table
-- One row per real country (regional and income groupings removed).
-- Keeps region, income group, GDP per person, internet use, and population.
-- Each number uses 2020 when available, otherwise 2019 (the data ends in 2020).
-- ga4_country is the country name spelled the way GA4 spells it: join on this.

CREATE OR REPLACE TABLE `ba-777-team7.lost_at_checkout.clean_countries` AS

SELECT
  -- Country identifiers
  c.country_code,
  c.table_name AS country_name,
  CASE c.country_code
    WHEN 'KOR' THEN 'South Korea'
    WHEN 'TUR' THEN 'Turkey'
    WHEN 'HKG' THEN 'Hong Kong'
    WHEN 'CZE' THEN 'Czechia'
    WHEN 'SVK' THEN 'Slovakia'
    WHEN 'PSE' THEN 'Palestine'
    WHEN 'MMR' THEN 'Myanmar (Burma)'
    WHEN 'BIH' THEN 'Bosnia & Herzegovina'
    WHEN 'MAC' THEN 'Macao'
    WHEN 'TTO' THEN 'Trinidad & Tobago'
    WHEN 'BHS' THEN 'Bahamas'
    WHEN 'EGY' THEN 'Egypt'
    WHEN 'RUS' THEN 'Russia'
    WHEN 'VEN' THEN 'Venezuela'
    ELSE c.table_name
  END AS ga4_country,

  -- Country groupings
  c.region,
  c.income_group,

  -- Economic and internet numbers (2020, or 2019 if 2020 is missing)
  COALESCE(n.gdp_2020, n.gdp_2019) AS gdp_per_capita_usd,
  CASE WHEN n.gdp_2020 IS NOT NULL THEN 2020 WHEN n.gdp_2019 IS NOT NULL THEN 2019 END AS gdp_year,
  COALESCE(n.internet_2020, n.internet_2019) AS internet_users_pct,
  CASE WHEN n.internet_2020 IS NOT NULL THEN 2020 WHEN n.internet_2019 IS NOT NULL THEN 2019 END AS internet_year,
  COALESCE(n.population_2020, n.population_2019) AS population

FROM `ba-777-team7.lost_at_checkout.raw_wdi_countries` AS c

-- One row per country with each number in its own column
LEFT JOIN (
  SELECT
    country_code,
    MAX(CASE WHEN indicator_code = 'NY.GDP.PCAP.CD' AND year = 2020 THEN value END) AS gdp_2020,
    MAX(CASE WHEN indicator_code = 'NY.GDP.PCAP.CD' AND year = 2019 THEN value END) AS gdp_2019,
    MAX(CASE WHEN indicator_code = 'IT.NET.USER.ZS' AND year = 2020 THEN value END) AS internet_2020,
    MAX(CASE WHEN indicator_code = 'IT.NET.USER.ZS' AND year = 2019 THEN value END) AS internet_2019,
    MAX(CASE WHEN indicator_code = 'SP.POP.TOTL'    AND year = 2020 THEN value END) AS population_2020,
    MAX(CASE WHEN indicator_code = 'SP.POP.TOTL'    AND year = 2019 THEN value END) AS population_2019
  FROM `ba-777-team7.lost_at_checkout.raw_wdi_indicators`
  WHERE indicator_code IN ('NY.GDP.PCAP.CD', 'IT.NET.USER.ZS', 'SP.POP.TOTL')
    AND year IN (2019, 2020)
  GROUP BY country_code
) AS n
  ON c.country_code = n.country_code

-- Real countries only (groupings like 'World' have no region)
WHERE c.region IS NOT NULL
  AND c.region <> '';
