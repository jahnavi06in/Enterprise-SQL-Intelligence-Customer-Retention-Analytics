# Enterprise SQL Intelligence & Customer Retention Analytics

### A SQL-Based Business Analytics Project | Retail Revenue | Customer Insights

An end-to-end retail analytics project using transaction-level sales data to investigate revenue trends, product performance, customer purchasing behaviour, repeat purchases, and customer segmentation.

The project applies SQL-based analysis to convert historical transaction records into measurable business insights and opportunities for further investigation.

---

## Project Overview

Retail transaction data can reveal how revenue is distributed across products, markets, and customers. This project explores these patterns using the UCI Online Retail dataset.

The analysis focuses on five key areas:

- Sales and revenue performance
- Monthly revenue trends
- Product and country performance
- Customer retention and repeat purchasing
- Customer revenue concentration and RFM segmentation

**Business objective:** Demonstrate how SQL can support data-driven commercial decisions through structured analysis of retail transactions.

---

## Dataset

**Source:** UCI Machine Learning Repository — Online Retail  
**Observation period:** 1 December 2010 – 9 December 2011  
**Original records:** 541,909 transaction lines  
**Currency:** GBP (£)

The dataset contains invoice-level and product-level transaction information from a UK-based online retailer.

Dataset source: https://archive.ics.uci.edu/dataset/352/online+retail

This is a historical case study. The findings should not be interpreted as current market performance.

---

## Key Results

The following figures are documented in the project's results summary and should be reproducible from the underlying data and SQL.

| Metric | Reported Result |
|---|---:|
| Raw transaction lines | 541,909 |
| Clean positive-sales lines | 524,878 |
| Unique invoices | 19,960 |
| Identified customers | 4,338 |
| Unique products | 3,922 |
| Countries represented | 38 |
| Recorded sales revenue | £10,642,110.80 |
| Average invoice value | £533.17 |
| Repeat-customer rate | 65.58% |
| Repeat customers | 2,845 |

**Revenue definition:** Quantity × Unit Price.

Revenue is reported sales revenue, not profit.

---

## Business Insights

### 1. Revenue Performance

Monthly revenue analysis identifies periods of relatively high and low recorded sales.

- Highest-revenue month in the documented results: November 2011 — £1,503,866.78.
- Lowest-revenue month in the documented results: February 2011 — £522,545.56.

These movements identify periods worth investigating but do not explain the underlying causes.

### 2. Product Performance

The documented results identify **DOTCOM POSTAGE** as the highest-revenue product.

- Recorded revenue: £206,248.77.
- Share of cleaned positive-sales revenue: 1.94%.

Product revenue contribution should be considered alongside costs and margins before making profitability decisions.

### 3. Geographic Performance

The United Kingdom generated £9,001,744.09 in documented recorded revenue, making it the leading country by revenue in this dataset.

Further analysis could examine geographic differences in purchasing frequency, invoice value, and retention.

### 4. Customer Retention

The documented repeat-customer rate is **65.58%**, with 2,845 of 4,338 identified customers making at least two distinct purchases during the observation period.

This is a historical repeat-purchase measure, not a prediction of future customer behaviour.

### 5. Customer Revenue Concentration

The results summary reports that the ten highest-revenue identified customers account for 17.30% of identified-customer revenue.

This concentration can be monitored as part of customer and revenue analysis. It does not independently establish business risk.

---

## SQL Analysis

The SQL analysis covers:

| Analysis | Purpose |
|---|---|
| Business overview | Summarise transactions, customers, products, and revenue |
| Monthly revenue | Examine monthly performance and month-over-month change |
| Product performance | Rank products by revenue contribution |
| Country performance | Compare revenue and invoice activity by country |
| Customer revenue | Summarise observed customer spending |
| Repeat purchasing | Calculate the historical repeat-customer rate |
| Cohort retention | Track customer activity after the first purchase month |
| Revenue concentration | Measure the contribution of the top ten identified customers |
| Hourly and weekday demand | Explore transaction timing patterns |
| Order value distribution | Examine invoice-level revenue |
| Data-quality audit | Inspect cancellations, negative quantities, and duplicate records |
| RFM segmentation | Group customers by recency, frequency, and monetary value |

The SQL script assumes the prepared `clean_sales` and source `raw_transactions` tables are available.

---

## RFM Customer Segmentation

RFM analysis evaluates customers across three dimensions:

- **Recency:** How recently a customer purchased.
- **Frequency:** How many distinct invoices are associated with the customer.
- **Monetary:** Total observed customer revenue.

The project uses relative scoring to explore groups such as Champions, Loyal / Active, At Risk, New / Promising, and Needs Nurture.

These are descriptive segments based on historical activity, not predictive customer labels.

---

## Data Preparation

The documented preparation approach includes:

- Inspecting missing customer identifiers.
- Checking cancelled invoices and negative quantities.
- Reviewing non-positive unit prices and quantities.
- Identifying exact duplicate records.
- Using distinct invoice identifiers for invoice-level metrics.
- Calculating line revenue as quantity multiplied by unit price.
- Excluding unidentified customers from customer-level calculations.

The exact cleaning implementation should be verified against the project's preparation code. Cleaning rules must be consistent with the reported results.

---

## Tools and Skills

- **SQL:** Aggregations, filtering, common table expressions (CTEs), window functions, ranking, and customer analytics.
- **Data analytics:** Revenue analysis, customer retention, cohort analysis, and RFM segmentation.
- **Data quality:** Duplicate detection, missing identifiers, and transaction validation.
- **Business intelligence:** KPI interpretation, business reporting, and evidence-based recommendations.
- **GitHub:** Project documentation and version control.

---

## Repository Structure

The repository includes SQL analysis, project documentation, and visualization images.

Key files currently documented in the repository include:

- `analysis.sql` — SQL analysis queries.
- `ANALYSIS_NOTES.md` — Analytical notes.
- `BUSINESS_READOUT.md` — Business interpretation.
- `RESULTS_SUMMARY.md` — Reported results.
- `SQL_QUERY_GUIDE.md` — SQL query documentation.
- `DATA_SOURCE_AND_METHODOLOGY-3.md` — Dataset and methodology.
- `PROJECT_VISUALIZATIONS.md` — Visualization documentation.

Visualization images in the repository include:

- `country_revenue-1.png`
- `customer_retention_cohort.png`
- `monthly_revenue.png`
- `rfm_customer_segments.png`
- `top_products_revenue-1.png`

File names and paths should be updated if the repository structure changes.

---

## Limitations

- The dataset covers one retailer over a historical period.
- Missing customer IDs limit customer-level analysis.
- Recorded revenue does not account for all business costs.
- Returns and cancellations require separate treatment from completed sales.
- Recent cohorts have fewer observable months.
- Customers who do not return within the observation period are not necessarily permanently lost.
- Descriptive patterns do not establish causation.
- Reported figures must be checked against the actual query outputs.

---

## Future Improvements

Potential extensions include:

- Automating data preparation and SQL execution.
- Exporting reproducible query-result tables.
- Comparing retention across customer cohorts.
- Investigating customer revenue concentration.
- Adding product cost, margin, and marketing data.
- Testing customer-retention initiatives with suitable experiments.
- Building an interactive dashboard from verified query outputs.

---

## Project Outcome

This project demonstrates a structured approach to retail transaction analysis using SQL, with an emphasis on data quality, revenue performance, customer behaviour, and business interpretation.

The focus is not only on calculating metrics, but also on explaining what those metrics reveal, acknowledging analytical limitations, and identifying questions that warrant further investigation.

**Author:** Jahnavi J.
