# SQL for Lost at Checkout

Run the files in number order. Everything is saved in the `ba-777-team7.lost_at_checkout` dataset.

## Naming

Files and saved queries: `<step>_<what it builds>`
- Step numbers keep the run order (`00`, `01`, `02` ...)
- `check_` in the name marks a query that only verifies a step and changes nothing

Tables and views:
- `raw_` = untouched source data (views that point to the public datasets)
- `clean_` = cleaned tables we build and analyze

An "action" is anything a shopper did on the site: viewed a page, viewed a product, added to cart, started checkout, purchased. Google's raw data calls these "events"; we rename them when we clean the data.

## Steps so far

| File | Builds | Notes |
|---|---|---|
| 00_create_dataset | `lost_at_checkout` dataset | |
| 01_raw_ga4_data | `raw_ga4_actions` (view) | Points to Google's public GA4 sample data |
| 02_clean_actions | `clean_actions` (table) | One row per shopper action |
| 02_check_clean_actions | nothing | Row count and missing-value checks |
| 03_clean_purchases | `clean_purchases` (table) | One row per order; repeats combined, missing IDs flagged |
| 03_check_clean_purchases | nothing | No duplicate orders; counts and revenue totals |
| 04_clean_items | `clean_items` (table) | One row per product per shopping step; 82 category labels grouped into 12; quantity kept only at checkout and purchase |
| 04_check_clean_items | nothing | Rows, products and funnel steps by clean category |
| 04c_check_item_values | nothing | Price and quantity checks by shopping step |
| 04b_clean_products | `clean_products` (table) | One category per product (its most common label); join to clean_items on item_id |
| 04b_check_clean_products | nothing | Funnel steps by product category using the join |
| 05_raw_wdi_data | `raw_wdi_indicators`, `raw_wdi_countries` (views) | Point to the World Bank's public dataset |
| 06_clean_countries | `clean_countries` (table) | One row per country: region, income group, GDP per person, internet use, population (2020, else 2019) |
| 06_check_clean_countries | nothing | Row count and missing values |
| 06_check_country_join | nothing | How many shoppers match a World Bank country |

## Join keys

| From | To | Key |
|---|---|---|
| clean_actions / clean_purchases | clean_countries | `country` = `ga4_country` |
| clean_items | clean_products | `item_id` |
| clean_purchases | clean_actions (purchase rows) | `user_id` + `order_id` |
