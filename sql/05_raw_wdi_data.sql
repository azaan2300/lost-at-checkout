-- Raw World Bank data (World Development Indicators)
-- Two views pointing to the World Bank's public dataset in BigQuery.
-- Views store no data; they just give the source a short name in our dataset.

-- Yearly numbers for every country (GDP, internet use, population, etc.)
CREATE OR REPLACE VIEW `ba-777-team7.lost_at_checkout.raw_wdi_indicators` AS
SELECT *
FROM `bigquery-public-data.world_bank_wdi.indicators_data`;

-- Country details (region, income group)
CREATE OR REPLACE VIEW `ba-777-team7.lost_at_checkout.raw_wdi_countries` AS
SELECT *
FROM `bigquery-public-data.world_bank_wdi.country_summary`;
