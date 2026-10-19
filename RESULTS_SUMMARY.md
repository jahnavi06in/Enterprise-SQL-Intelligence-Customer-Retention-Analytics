# Results Summary — Enterprise SQL Intelligence & Customer Retention Analytics

## 1. Dataset and Scope

- **Source:** UCI Machine Learning Repository — Online Retail
- **Original dataset:** 541,909 transaction lines
- **Observation period:** 1 December 2010 – 9 December 2011
- **Currency:** GBP (£)
- **Revenue definition:** Quantity × Unit Price
- **Analysis scope:** Historical positive-sales transactions

The results describe the historical dataset, not current retail market conditions. Revenue represents recorded sales, not profit.

## 2. Data Preparation

The documented preparation rules include:

- Identifying exact duplicate records.
- Checking invoice identifiers and transaction dates.
- Excluding non-positive quantities and unit prices from positive-sales analysis.
- Excluding invoices beginning with `C` from positive-sales metrics.
- Excluding records with missing customer IDs from customer-level analysis.
- Calculating revenue as quantity multiplied by unit price.

| Data preparation metric | Result |
|---|---:|
| Raw transaction rows | 541,909 |
| Exact duplicate rows detected | 5,268 |
| Clean positive-sales rows retained | 524,878 |
| Raw rows not present in cleaned sales | 17,031 |

The 17,031-row difference combines multiple exclusion reasons and should not be interpreted as a count of cancellations alone.

## 3. Key Business Results

| Metric | Result |
|---|---:|
| Clean positive-sales lines | 524,878 |
| Unique invoices | 19,960 |
| Identified customers | 4,338 |
| Unique products | 3,922 |
| Countries represented | 38 |
| Total positive-sales revenue | £10,642,110.80 |
| Average invoice value | £533.17 |
| Repeat customers | 2,845 |
| Repeat-customer rate | 65.58% |

Customer-level metrics exclude records without an identified customer ID.

## 4. Revenue Insights

### Product Performance

- **Top product by recorded revenue:** DOTCOM POSTAGE (stock code DOT)
- **Recorded revenue:** £206,248.77
- **Share of cleaned positive-sales revenue:** 1.94%

Product rankings show revenue contribution, not profitability.

### Geographic Performance

- **Top country:** United Kingdom
- **Recorded revenue:** £9,001,744.09

This indicates that the UK accounts for a substantial share of the recorded sales in this dataset.

### Monthly Performance

- **Highest-revenue month:** November 2011 — £1,503,866.78
- **Lowest-revenue month:** February 2011 — £522,545.56

Monthly movements identify periods for further investigation. They do not, by themselves, explain the reasons for changes.

## 5. Customer Retention and Concentration

### Repeat Purchasing

A repeat customer is an identified customer associated with at least two distinct invoices during the observation period.

The documented repeat-customer rate is **65.58%**, or 2,845 out of 4,338 identified customers.

This is a historical repeat-purchase measure, not a prediction of future retention.

### Customer Revenue Concentration

The ten highest-revenue identified customers account for a documented **17.30%** of identified-customer revenue.

Customer concentration can be monitored to understand revenue distribution. It does not, by itself, prove that the business faces a particular risk.

## 6. Limitations

- The dataset covers one retailer and a historical period ending in December 2011.
- Missing customer IDs limit customer-level analysis.
- Revenue does not include all costs and cannot be treated as profit.
- Returns and cancellations require separate treatment from completed sales.
- Recent customer cohorts have fewer observable months, so cohort retention should be compared at matched cohort ages.
- Customers who do not return during the observed window are not necessarily permanently lost.
- Descriptive analysis identifies patterns but does not establish causation.

## 7. Reproducibility

Reported results should be generated from the project SQL and prepared database.

If the preparation rules, source data, or analysis period change, rerun the relevant queries and update the documented figures.

**Verification note:** Confirm that all reported figures match the current database outputs before treating them as final.

## 8. Project Files

The repository documentation identifies these project components:

- SQL analysis: `sql/analysis.sql`
- SQLite database: `customer_retention_analytics.db`
- Result tables: `outputs/`
- Visualizations: `visuals/`

These paths should match the files actually present in the repository.
