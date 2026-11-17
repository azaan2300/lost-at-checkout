# Data notes

## Quick guide

All tables are in `ba-777-team7.lost_at_checkout` and cover Nov 1, 2020 to Jan 31, 2021.

| Table | One row per | Rows |
|---|---|---|
| clean_actions | shopper action (page view, add to cart, purchase, etc.) | 4,295,584 |
| clean_purchases | order | 5,372 |
| clean_items | product per shopping step (view, add to cart, checkout, purchase) | 3,507,121 |
| clean_products | product, with its clean category | |
| clean_countries | country, with World Bank figures | 217 |

Joins: `country` = `ga4_country` for countries, `item_id` for product categories. Use a LEFT JOIN so unmatched rows aren't dropped.

Things to keep in mind:
- A visit is `user_id` + `session_id` together; session IDs repeat across shoppers.
- Use `clean_purchases` for orders and revenue, not purchase rows in `clean_actions`.
- Take product categories from `clean_products`, not the `category` column in `clean_items`.
- To count products added to cart, count rows, not quantity.

Numbers to check your results against: 270,154 shoppers, 360,129 visits, 5,372 orders, $340,647 revenue, $69.21 average order. Visits reaching each step: 77,020 viewed a product, 15,188 added to cart, 11,106 started checkout, 4,848 purchased.

# Challenges and limitations

Notes for the notebook. Each item says what we found, what we did, and what it means for the analysis.

## Google scrambled the sample

Google obfuscated this GA4 export so it can't be traced back to the real store. Some fields were replaced with placeholders, so results show realistic patterns rather than actual store figures.

- Marketing channel: 21% of actions have a medium of `<Other>` or `(data deleted)`. We kept them and grouped them as "Unknown" instead of dropping them.
- Order IDs: 906 purchases have no order ID, and 15 order IDs are shared by two different shoppers. We kept the missing-ID purchases (flagged with `missing_order_id`) and built a unique `order_key` from order ID plus shopper.
- Revenue: 450 orders have no recorded revenue. We left these blank instead of setting them to 0, so they don't pull down averages.

## Channel is first-touch only

GA4 records the medium that first brought each shopper to the store, not the source of each visit (the per-visit medium field is empty in this sample). Channel comparisons answer "which channel first brought in shoppers who later bought," not "which visit led to the purchase."

## Product quantity is only reliable at checkout and purchase

On product views and add-to-carts, quantity was blank 94–99% of the time, and the values that did appear were impossible (one add-to-cart showed over 2.3 billion units; three were zero or negative). At checkout and purchase it is always filled in and realistic (maximum 160 units on one order). We kept quantity only for checkout and purchase rows. For add-to-cart analysis, count rows: one row is one product added.

## Product categories change between steps

The same product often carries a different (or blank) category at checkout and purchase than when it was viewed. We grouped the 82 raw category labels into 12 clean categories, then gave each product the category it carries most often (`clean_products`). Two issues remain:
- 49 products only ever appear at checkout or purchase with no category, so they stay "Uncategorized."
- Eco-Friendly products show views and add-to-carts but no checkouts or purchases, likely a side effect of the same scrambling.

## World Bank data

- The World Bank dataset ends in 2020. Each figure uses 2020 where available and 2019 otherwise; `gdp_year` and `internet_year` record which.
- Internet use is missing for 87 of 217 countries, and GDP per person for 12.
- Country names had to be matched by hand for 14 countries (for example "Korea, Rep." to "South Korea"). After matching, 97.5% of shoppers link to a country. Taiwan has no World Bank data, and some shoppers have no country recorded.

## Time zone

`action_time` is in UTC. Daily dates come from GA4's own date field.
