-- Raw GA4 actions
-- Points to Google's public sample data for the Google Merchandise Store
-- (Nov 2020 - Jan 2021). This is a view, so no data is copied.

CREATE OR REPLACE VIEW `ba-777-team7.lost_at_checkout.raw_ga4_actions` AS
SELECT *
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;
