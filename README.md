here# Enterprise SQL Intelligence & Customer Retention Analytics

### SQL-Based Business Analytics | Retail Revenue | Customer Insights

An end-to-end SQL analytics project exploring retail revenue performance, product contribution, customer purchasing behaviour, repeat purchasing, and customer segmentation using the UCI Online Retail dataset.

The project combines data preparation, SQL analysis, documented business metrics, and visualizations to demonstrate how transaction data can support evidence-based commercial decisions.

## Project Objectives

- Analyse revenue trends and monthly performance.
- Identify high-revenue products and geographic markets.
- Measure historical repeat purchasing and customer retention.
- Examine customer revenue concentration.
- Apply RFM analysis to explore customer purchasing patterns.
- Investigate transaction quality and data-cleaning requirements.

## Dataset

**Source:** UCI Machine Learning Repository — Online Retail  
**Observation period:** 1 December 2010 – 9 December 2011  
**Original records:** 541,909 transaction lines  
**Currency:** GBP (£)

The dataset contains transaction-level records from a UK-based online retailer.

Dataset: https://archive.ics.uci.edu/dataset/352/online+retail  
DOI: https://doi.org/10.24432/C5BW33

This is a historical case study, not a representation of current retail market conditions.

## Key Results

These metrics were reproduced by running `Prepare_data.py` and `analysis.sql` on the full dataset.

| Metric | Result |
|---|---:|
| Original transaction lines | 541,909 |
| Clean positive-sales lines | 524,878 |
| Unique invoices | 19,960 |
| Identified customers | 4,338 |
| Unique products | 3,922 |
| Countries represented | 38 |
| Recorded sales revenue | £10,642,110.80 |
| Average invoice value | £533.17 |
| Repeat customers | 2,845 |
| Repeat-customer rate | 65.58% |

**Revenue calculation:** Quantity × Unit Price.

Revenue represents gross recorded sales, not profit. Cancellation invoices are excluded but not netted against the original orders (the raw data contains £896,812 of cancellation value). Customer metrics exclude transactions without an identified customer.

## Business Insights

### 1. Revenue Trends

The documented results identify:

- **Highest-revenue month:** November 2011 — £1,503,866.78.
- **Lowest-revenue month:** February 2011 — £522,545.56.

These results highlight periods for further investigation but do not independently explain the reasons behind the changes.

### 2. Product Performance

DOTCOM POSTAGE is the highest-revenue product in the documented results.

- **Recorded revenue:** £206,248.77.
- **Share of cleaned positive-sales revenue:** 1.94%.

Revenue contribution alone does not establish product profitability because costs and margins are not included.

### 3. Geographic Performance

The United Kingdom accounts for £9,001,744.09 in documented recorded revenue.

Further analysis could compare invoice values, purchasing frequency, and retention across geographic markets.

### 4. Repeat Purchasing

The documented repeat-customer rate is **65.58%**.

A total of 2,845 out of 4,338 identified customers made at least two distinct purchases during the observation period.

This is a historical repeat-purchase measure, not a prediction of future customer behaviour.

### 5. Customer Revenue Concentration

The results summary reports that the ten highest-revenue identified customers account for 17.30% of identified-customer revenue.

This metric helps describe how revenue is distributed across customers. It does not independently establish business risk.

## SQL Analysis

The project includes SQL queries for:

- Business and revenue overview.
- Monthly revenue and month-over-month changes.
- Product revenue ranking.
- Country-level performance.
- Customer spending analysis.
- Repeat-purchase measurement.
- Customer cohort retention.
- Top-customer revenue concentration.
- Hourly and weekday transaction patterns.
- Invoice-level revenue distribution.
- Transaction quality and cancellation audits.
- Duplicate-record analysis.
- RFM customer segmentation.
- Customer activity and retention summaries.

The SQL analysis uses SQLite-compatible queries and assumes the prepared `clean_sales` and `raw_transactions` tables are available.

## RFM Customer Segmentation

RFM analysis examines customers using three dimensions:

- **Recency:** Time since the customer's most recent purchase.
- **Frequency:** Number of distinct invoices associated with the customer.
- **Monetary:** Total observed customer revenue.

Relative scores can help compare customer purchasing patterns and identify groups for further investigation.

RFM segments are descriptive categories based on historical activity. They are not predictive labels or guarantees of future behaviour.

## How to Reproduce

1. Download `Online Retail.xlsx` from the UCI link above and upload it to `/content` in Google Colab.
2. Run `Prepare_data.py` to create `customer_retention_analytics.db`.
3. Run the queries in `analysis.sql` against that database.

## Data Preparation

The preparation workflow includes:

- Loading the original transaction dataset.
- Preserving the original transaction records for auditing.
- Identifying exact duplicate records.
- Reviewing cancellations and negative quantities.
- Checking non-positive prices and quantities.
- Preparing cleaned positive-sales transactions.
- Calculating line revenue as quantity multiplied by unit price.
- Creating the `clean_sales` and `raw_transactions` SQLite tables.
- Verifying row counts and revenue totals.

Customer-level calculations exclude transactions without an identified customer where customer identity is required.

## Tools & Skills

- **SQL:** Aggregations, filtering, CTEs, window functions, ranking, and customer analysis.
- **Python:** Data preparation and transformation.
- **Pandas:** Tabular data cleaning and processing.
- **SQLite:** Database creation and querying.
- **Data Analytics:** Revenue analysis, cohort retention, repeat purchasing, and RFM segmentation.
- **Data Quality:** Duplicate detection and transaction validation.
- **GitHub:** Project documentation and version control.

## Repository Contents

The repository contains SQL scripts, Python data-preparation code, analysis documentation, reported results, and visualization assets.

Key files include:

- `analysis.sql` — SQL analysis queries.
- `Prepare_data.py` — Data preparation and database creation.
- `RESULTS_SUMMARY.md` — Documented project metrics.
- `BUSINESS_READOUT.md` — Business interpretation.
- `SQL_QUERY_GUIDE.md` — SQL query documentation.
- `PROJECT_VISUALIZATIONS.md` — Visualization documentation.
- `DATA_SOURCE_AND_METHODOLOGY-3.md` — Dataset and methodology documentation.
- `ANALYSIS_NOTES.md` — Additional analytical notes.

## Limitations

- The dataset covers one retailer over a historical period.
- Missing customer identifiers limit customer-level analysis.
- Revenue does not account for all business costs.
- Returns and cancellations must be distinguished from completed sales.
- Recent customer cohorts have fewer observable months.
- Customers who do not return during the observation period are not necessarily permanently lost.
- Descriptive analysis does not establish causation.
- Revenue is gross of cancellations; some large orders in the data were cancelled minutes after being placed, which inflates certain product and customer totals.
- December 2011 contains data only up to 9 December, so its monthly revenue and the most recent cohort-month cells are partial.
- Some stock codes are not merchandise (for example DOT, POST and M for postage and manual adjustments).

## Future Improvements

- Automate SQL execution and result exports.
- Expand cohort-based retention comparisons.
- Investigate changes in customer revenue concentration.
- Incorporate product costs and profit margins.
- Evaluate retention initiatives using appropriate experiments.
- Build an interactive dashboard using verified query outputs.

## Project Outcome

This project demonstrates a structured approach to retail analytics using SQL and Python, with an emphasis on data quality, revenue performance, customer purchasing behaviour, and business interpretation.

It focuses on turning transaction records into measurable findings while documenting analytical assumptions, limitations, and opportunities for further investigation.

**Author:** Jahnavi J.
