# Data Source and Methodology

## Project
Enterprise SQL Intelligence & Customer Retention Analytics

## 1. Data Source

This project uses the UCI Online Retail dataset.

Source: [UCI Machine Learning Repository — Online Retail](https://archive.ics.uci.edu/dataset/352/online+retail)

The dataset contains transaction-level records from a UK-based online retailer between 1 December 2010 and 9 December 2011.

The analysis is a historical case study. Its findings should not be interpreted as a description of current retail market conditions.

## 2. Business Questions

This project investigates:

- How recorded sales revenue changes over time.
- Which products and countries contribute most to recorded revenue.
- How frequently identified customers make repeat purchases.
- How customer behaviour varies across recency, frequency, and monetary value.
- How revenue is distributed across customers.
- Which patterns deserve further business investigation.

## 3. Data Preparation and Quality Checks

The analysis distinguishes the original transaction data from the cleaned sales dataset.

The `raw_transactions` table represents the source records, while `clean_sales` represents the records used for positive-sales analysis.

The preparation process should explicitly document the following rules:

- **Missing customer identifiers:** Retain source records for appropriate transaction-level analysis where applicable, but exclude records without a customer ID from customer-level retention and RFM calculations.
- **Cancelled invoices:** Identify cancellation invoices using the source invoice identifier and assess their treatment separately from completed sales.
- **Negative quantities:** Identify negative-quantity records because they may represent returns or adjustments.
- **Invalid unit prices:** Inspect zero or negative prices and document whether these records are excluded.
- **Duplicate records:** Identify exact duplicate rows and document whether they are removed during preparation.
- **Revenue calculation:** Calculate line revenue as quantity multiplied by unit price.
- **Transaction counting:** Count distinct invoice identifiers when calculating invoice-level metrics.
- **Customer counting:** Count distinct non-null customer identifiers for identified-customer metrics.

The exact implementation must match the SQL preparation script. These checks describe the required methodology and should not be interpreted as proof that a rule was applied unless the code confirms it.

## 4. Revenue Analysis

Line revenue is calculated as:

`Revenue = Quantity × Unit Price`

Revenue is expressed in GBP.

The project analyses:

- Total recorded sales revenue.
- Monthly revenue and month-over-month movement.
- Average invoice value.
- Product revenue contribution.
- Revenue by country.
- Revenue concentration among the highest-spending customers.

Recorded revenue is not profit. The dataset does not provide all costs required to calculate profit margins.

## 5. Customer Analysis

### Repeat Purchase Rate

Customers are classified based on the number of distinct invoices associated with their customer ID.

- **Repeat customers:** Customers with at least two distinct invoices.
- **One-time customers:** Customers with exactly one distinct invoice.

The repeat purchase rate is:

`Repeat Purchase Rate = Repeat Customers / Identified Customers × 100`

This metric describes repeat purchasing within the observed dataset and analysis window.

### Cohort Retention

Customers are grouped by the month of their first recorded purchase.

Retention measures how many customers from each cohort have recorded purchasing activity in subsequent months.

Month 0 represents the cohort's first purchase month.

Customers who do not reappear during the observed period are not necessarily permanently lost.

### Customer Revenue

Customer revenue represents recorded spending attributed to an identified customer during the observation period.

It is a historical revenue measure, not a predictive customer lifetime value model.

## 6. RFM Segmentation

RFM stands for:

- **Recency:** Days since the customer's most recent purchase relative to the dataset's latest transaction date.
- **Frequency:** Number of distinct purchase invoices.
- **Monetary:** Total recorded revenue attributed to the customer.

The SQL analysis uses quintile-based scores to group customers relative to the observed population.

These segments are descriptive and depend on the observation period, data preparation rules, and scoring method. They do not establish future purchasing behaviour.

## 7. Business Interpretation

Revenue and customer metrics can help identify patterns that deserve further investigation.

Examples include:

- Investigating monthly revenue increases and decreases.
- Reviewing products with high recorded revenue.
- Examining countries with substantial sales contribution.
- Understanding the proportion of identified customers who purchase repeatedly.
- Investigating customer groups with different RFM profiles.
- Evaluating dependence on a small group of high-revenue customers.

These patterns do not establish their causes. Business recommendations should be validated with additional data and appropriate testing.

## 8. Limitations

- The dataset covers one retailer and a limited historical period.
- Missing customer identifiers limit customer-level analysis.
- Recorded revenue does not represent profit or margin.
- Returns, cancellations, discounts, and other business rules can affect interpretation.
- The observation window may end before a customer makes another purchase.
- Descriptive analysis identifies patterns but does not establish causation.
- Results depend on the implemented cleaning rules and analytical definitions.

## 9. Further Investigation

Potential next steps include:

- Comparing retention across acquisition cohorts.
- Reconciling cancellations and returns against completed sales.
- Adding product margin and marketing-cost data.
- Comparing retention patterns across countries and product categories.
- Testing retention initiatives through controlled experiments where feasible.

## 10. Reproducibility

The SQL scripts, preparation logic, analysis outputs, and reported results should remain consistent.

Whenever cleaning rules or the analysis period change, the affected queries and reported figures should be rerun.

All assumptions specific to the implementation should be documented so another analyst can reproduce and evaluate the results.
