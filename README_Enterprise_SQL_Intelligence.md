# Customer Retention & Revenue Intelligence: An SQL-Driven E-Commerce Investigation

## Project overview
An end-to-end SQL analytics case study using the **real UCI Online Retail dataset**. It investigates revenue trends, product and country performance, repeat purchasing, cohort retention, customer revenue concentration, and data quality.

## Business questions
- What is the scale of cleaned positive sales, invoices, customers, and products?
- How does monthly revenue change, including month-over-month movement?
- Which products and countries contribute most to sales revenue?
- What does repeat purchasing look like within the observation window?
- How does retention vary by first-purchase cohort and cohort age?
- Is revenue concentrated among a small number of identified customers?
- Which data-quality issues should be addressed before business interpretation?

## Dataset and attribution
- **Dataset:** Online Retail
- **Creator:** Daqing Chen; published by the UCI Machine Learning Repository
- **Raw records:** 541,909 transaction lines; 8 fields
- **Date range:** 1 December 2010 – 9 December 2011
- **Currency:** GBP (£)
- **License:** CC BY 4.0
- **Official source:** https://archive.ics.uci.edu/dataset/352/online+retail
- **DOI:** https://doi.org/10.24432/C5BW33

The ZIP includes a derived cleaned CSV, SQLite database, SQL scripts, outputs and charts. The raw workbook is not duplicated. See `data/DATA_SOURCE.md` for the source and derived-file notes.

## Cleaning and metric definitions
1. Standardized field names and parsed dates/numeric fields.
2. Removed exact duplicate rows before analysis.
3. Excluded cancellation invoices (invoice numbers beginning with `C`) from positive-sales metrics.
4. Excluded rows with non-positive quantity or unit price from positive-sales metrics. Negative quantities can represent returns, so they are reported separately rather than counted as positive sales.
5. Retained otherwise valid sales with missing customer IDs for overall sales totals, but excluded them from customer-level metrics.
6. Calculated line revenue as `quantity × unit_price`. This is **sales revenue, not profit**.
7. Calculated repeat rate as identified customers with at least two distinct invoices divided by all identified customers. Cohort retention counts distinct identified customers active in each month after their first recorded purchase.

These are transparent analytical choices, not universal accounting rules. A production workflow should reconcile cancellations, returns, refunds and credit notes against finance definitions.

## Headline findings
The results were computed from the public dataset. See [`outputs/RESULTS_SUMMARY.md`](outputs/RESULTS_SUMMARY.md) for all headline numbers, caveats and cleaning counts. Cleaned positive-sales revenue is **£10,642,110.80** across **19,960** invoices. The observed repeat-customer rate is **65.58%** for customers with IDs.

## SQL and tools
SQLite SQL: CTEs, `GROUP BY`, `CASE`, `COUNT(DISTINCT ...)`, `LAG`, `DENSE_RANK`, date arithmetic, conditional aggregation and window functions. Python/pandas is used for data preparation and output validation; matplotlib creates charts.

## Repository structure
- `data/clean_sales_transactions.csv` — derived positive-sales analysis table
- `data/DATA_SOURCE.md` — source attribution and license notes
- `customer_retention_analytics.db` — SQLite `raw_transactions` and `clean_sales` tables
- `sql/analysis.sql` — query collection
- `outputs/` — audit, KPI, product, country, customer, cohort, RFM and summary outputs
- `visuals/` — monthly trend, top product/country, cohort retention and RFM charts
- `docs/BUSINESS_READOUT.md` — interpretation and follow-up questions

## Limitations
- Historical data from one retailer, not a representative current-market benchmark.
- Missing customer IDs mean customer-level metrics do not cover all sales rows.
- Revenue is not profit; no costs or margin data are available.
- Cohort results are right-censored; compare cohorts at matched month numbers.
- Descriptive segmentation does not predict churn or prove a retention campaign would work.

## Citation
Chen, D. (2015). *Online Retail* [Dataset]. UCI Machine Learning Repository. https://doi.org/10.24432/C5BW33.
