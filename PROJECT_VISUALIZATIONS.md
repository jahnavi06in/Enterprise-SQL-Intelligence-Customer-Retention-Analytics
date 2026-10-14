# Visual Findings

This page brings the project's charts together and explains the question behind each one. The charts use the historical UCI Online Retail transaction data (December 2010–December 2011), with sales-analysis filters documented in `DATA_SOURCE_AND_METHODOLOGY.md`.

## 1. Monthly revenue trend

![Monthly revenue trend](monthly_revenue.png)

**Question:** How did recorded sales vary over time?

**How to read it:** Look for month-to-month changes and unusually high or low periods. A spike is a prompt for investigation, not an explanation by itself. Calendar effects, large orders, returns treatment, and changes in customer activity may all matter.

## 2. Product revenue

![Top products by revenue](top_products_revenue.png)

**Question:** Which products generated the most recorded revenue?

**How to read it:** High revenue can help identify products worth examining, but it does not establish profitability. Product cost, discounts, returns, and stock availability would be needed for a fuller commercial view.

## 3. Revenue by country

![Top countries by revenue](country_revenue.png)

**Question:** Which countries account for the largest share of recorded sales?

**How to read it:** The data is heavily weighted toward the United Kingdom. Comparisons across countries should account for the very different sales volumes and should not be treated as a current market-sizing exercise.

## 4. Customer cohort retention

![Customer cohort retention](customer_retention_cohort.png)

**Question:** What proportion of each first-purchase cohort made another purchase in later months?

**How to read it:** Each cohort starts at 100% in its first purchase month. Later cells show the share observed purchasing again in the corresponding month since first purchase. Later cohorts have fewer months of follow-up, so blank cells mean the period is not observed in this dataset—not zero retention.

## 5. RFM customer segments

![RFM customer segments](rfm_customer_segments.png)

**Question:** How can customers be grouped by observed purchase behaviour?

**How to read it:** Recency, frequency, and monetary value provide a descriptive view of customer activity. Segment thresholds are project-defined and should be reviewed with business stakeholders before they are used to target customers.

## Important caveats

- This is historical data from 2010–2011, not a view of current retail performance.
- Revenue is calculated from quantity multiplied by unit price; it is not profit.
- Customer analysis only includes transactions with an identified customer ID.
- The charts depend on the cleaning rules and definitions described in the methodology file.
- These patterns are descriptive. They do not establish why customers behaved a certain way or predict future purchases.
