# SQL Query Guide

This guide explains the main business questions answered by `sql/analysis.sql`. The queries use the project's `clean_sales` table unless noted otherwise. The source audit and cleaning-impact queries also refer to `raw_transactions`.

## 1. Business overview
**Question:** What is the overall scale of the cleaned sales data?

Counts sales lines, invoices, identified customers, products, and countries, and calculates recorded revenue and average revenue per invoice.

**Use with care:** Average invoice value is the average recorded sales amount per invoice in this dataset; it is not profit.

## 2. Monthly revenue and month-over-month change
**Question:** How does recorded revenue change over time?

Groups sales by month and uses `LAG()` to compare each month with the previous month.

**Interpretation:** A positive or negative change identifies a pattern to investigate. It does not explain the cause.

## 3. Product performance
**Question:** Which products contribute the most recorded revenue?

Summarises units sold, revenue, invoice count, and share of revenue by product, then returns the top 20.

**Next check:** Add cost, returns, and stock data before making profitability or inventory decisions.

## 4. Country performance
**Question:** How do recorded sales differ by country?

Compares invoices, identified customers, units sold, revenue, and revenue per invoice.

**Interpretation:** Countries with different sales volumes should not be compared on revenue alone.

## 5. Customer observed spend
**Question:** Which identified customers account for the highest recorded spend?

Calculates each customer's invoice count, units bought, recorded spend, average invoice value, first and last purchase dates, and revenue rank.

The query labels this as an observed-spend proxy—not predictive customer lifetime value.

## 6. Repeat-purchase rate
**Question:** What share of identified customers placed at least two distinct invoices?

Classifies customers as repeat purchasers or one-time purchasers within the observed period.

**Limitation:** Customers first seen near the end of the dataset have less time to return. The measure is not a prediction of future loyalty.

## 7. Cohort retention
**Question:** What proportion of each first-purchase cohort was active in later months?

Finds each customer's first purchase month and counts customers with activity in each later month, compared with the cohort's original size.

**Limitation:** Later cohorts have fewer observable months. Blank or absent future periods are not zero retention.

## 8. Top-10 customer revenue concentration
**Question:** What share of identified-customer revenue is associated with the highest-spending ten customers?

Calculates top-customer revenue and its share of the total identified-customer revenue.

**Business use:** Helps flag concentration worth monitoring; it does not imply those customers will continue spending at the same level.

## 9. Hourly and weekday demand
**Question:** At what hours and on which weekdays were invoices most frequent?

Summarises invoice counts and recorded revenue by hour and weekday.

**Business use:** Could inform follow-up questions about staffing or demand patterns. Check the source timezone and business operating context before using it operationally.

## 10. Order value distribution
**Question:** How varied are invoice totals?

Calculates the number of invoices and the mean, minimum, and maximum invoice revenue. The mean can be affected by unusually large orders, so a median and percentiles would be useful additions.

## 11. Cancellation and return audit
**Question:** How many raw rows look like cancellations or have negative quantities?

Runs against `raw_transactions` to audit invoice numbers beginning with `C` and negative-quantity rows. These are audit indicators; the precise treatment of returns and cancellations should be documented alongside the cleaning rules.

## 12. Data-cleaning impact
**Question:** How much did the row count and recorded revenue change after cleaning?

Compares raw rows, exact duplicate rows, and cleaned positive-sales rows and revenue. Interpret the counts alongside the documented filters; row-count differences can reflect multiple cleaning rules.

## 13. RFM segmentation
**Question:** How can customers be grouped by recency, frequency, and monetary value?

Creates five-level scores for recency, purchase frequency, and recorded spend, then assigns descriptive labels such as Champions, Loyal / Active, At Risk, New / Promising, or Needs Nurture.

**Limitation:** Segment labels are descriptive and depend on the scoring rules and snapshot date. They are not a validated prediction of future behaviour.

## How to run the queries

1. Use a SQLite-compatible database containing the project's `raw_transactions` and `clean_sales` tables.
2. Open `sql/analysis.sql` in a SQLite client or compatible SQL editor.
3. Run one query block at a time, starting with the business overview.
4. Confirm that table and column names match the database schema.
5. Compare outputs with the project's results files and investigate any mismatch before publishing results.

## Technical note

The queries use SQLite-style functions and syntax, including `strftime`-derived fields stored in the cleaned table, `julianday()`, window functions, and `USING`. A different SQL engine may require small syntax changes.
