# SQL Query Guide
## Enterprise SQL Intelligence & Customer Retention Analytics

## 1. Project Overview

This guide explains the SQL queries used to analyse the UCI Online Retail dataset.

The project explores:
- Overall retail sales performance
- Monthly revenue trends
- Product and country performance
- Customer purchasing behaviour
- Repeat-purchase rate and cohort retention
- Customer revenue concentration
- Hourly and weekday demand
- Order value distribution
- Data quality and cleaning impact
- RFM customer segmentation

The queries are designed for SQLite-compatible SQL and use the `clean_sales` and `raw_transactions` tables.

**Important:** The `clean_sales` table is assumed to have already been prepared. The analysis queries do not create the table or perform the complete data-cleaning workflow.

---

## 2. Business Overview

**Business question:** What is the overall scale of the cleaned retail dataset?

### Analysis performed
- Counts cleaned transaction lines and distinct invoices.
- Counts identifiable customers, products, and countries.
- Calculates total recorded sales revenue.
- Calculates average revenue per invoice.
- Identifies the earliest and latest transaction dates.

### SQL techniques
`COUNT()`, `COUNT(DISTINCT)`, `SUM()`, `AVG()`, `MIN()`, `MAX()`, `ROUND()`, and `NULLIF()`.

### Business value
Establishes baseline metrics that can be used to understand the dataset and support subsequent analysis.

### Limitation
Revenue is calculated as quantity multiplied by unit price. It represents recorded sales value, not profit.

---

## 3. Monthly Revenue and Month-over-Month Change

**Business question:** How does recorded revenue change from month to month?

### Analysis performed
- Aggregates revenue and invoice counts by month.
- Uses `LAG()` to retrieve the previous month's revenue.
- Calculates the percentage change from the previous month.
- Orders results chronologically.

### SQL techniques
Common table expressions (CTEs), `SUM()`, `COUNT(DISTINCT)`, `GROUP BY`, `LAG()`, window functions, `NULLIF()`, and percentage calculations.

### Business value
Helps identify periods of revenue growth or decline that deserve further investigation.

### Limitation
A month-over-month change describes a historical pattern. It does not explain the cause of that change or predict future performance.

---

## 4. Top 20 Products by Revenue

**Business question:** Which products contributed the most recorded revenue?

### Analysis performed
- Groups sales by product stock code.
- Calculates units sold, revenue, and distinct invoice counts.
- Calculates each product's share of total cleaned revenue.
- Returns the top 20 products by revenue.

### SQL techniques
CTEs, `SUM()`, `COUNT(DISTINCT)`, `MAX()`, window aggregation, `OVER()`, `ORDER BY`, and `LIMIT`.

### Business value
Identifies products that may deserve closer examination in sales, pricing, and inventory analysis.

### Limitation
High revenue does not necessarily mean high profitability. Product costs, margins, stock levels, and returns would be needed for stronger commercial decisions.

**Implementation note:** The query uses `MAX(description)` to select a description for each stock code. This is a convenient way to return one description, but it does not independently verify that the description is consistent across all records for that code.

---

## 5. Country Performance

**Business question:** How does recorded sales performance vary by country?

### Analysis performed
- Counts distinct invoices and identified customers.
- Calculates units sold and total revenue.
- Calculates average revenue per invoice.
- Ranks countries by revenue.

### SQL techniques
`COUNT(DISTINCT)`, `SUM()`, `GROUP BY`, `ROUND()`, `NULLIF()`, and `ORDER BY`.

### Business value
Supports comparisons of geographic sales contribution and identifies markets for further investigation.

### Limitation
Revenue alone does not show market profitability or growth potential. Invoice volume, customer coverage, operating costs, and other contextual information would be needed.

---

## 6. Customer Observed Spend

**Business question:** Which identified customers account for the highest historical spending?

### Analysis performed
- Counts distinct purchase invoices per customer.
- Calculates total units purchased and recorded revenue.
- Calculates average revenue per invoice.
- Identifies first and last purchase dates.
- Ranks customers by recorded revenue.
- Returns up to 100 customer records.

### SQL techniques
`COUNT(DISTINCT)`, `SUM()`, `MIN()`, `MAX()`, `ROUND()`, `GROUP BY`, `DENSE_RANK()`, and window functions.

### Business value
Helps identify high-spending customers and provides a starting point for customer purchasing-behaviour analysis.

### Limitation
This is an observed historical-spend measure, not predictive customer lifetime value (CLV). It does not estimate future spending or profitability.

Customer-level analysis also excludes transactions without an identifiable customer ID.

---

## 7. Repeat-Purchase Rate

**Business question:** What proportion of identified customers placed at least two distinct invoices?

### Analysis performed
- Counts distinct invoices for each identified customer.
- Classifies customers as repeat purchasers or one-time purchasers.
- Calculates the repeat-customer rate as a percentage.

### SQL techniques
CTEs, `COUNT(DISTINCT)`, `GROUP BY`, `CASE WHEN`, `SUM()`, `COUNT(*)`, and `NULLIF()`.

### Business value
Provides a baseline measure of repeat purchasing during the observed period.

### Limitation
Customers first observed near the end of the dataset have less time to make another purchase. The result describes historical behaviour and does not guarantee future customer loyalty.

The rate applies to identifiable customers, not necessarily every buyer in the dataset.

---

## 8. Customer Cohort Retention

**Business question:** What proportion of each first-purchase cohort returned in subsequent months?

### Analysis performed
- Identifies each customer's first recorded purchase month.
- Groups customers into cohorts based on that month.
- Calculates the number of months between first purchase and later activity.
- Counts active customers in each cohort-month combination.
- Calculates retention as a percentage of the original cohort size.

Month 0 represents the customer's first purchase month.

### SQL techniques
Multiple CTEs, `SELECT DISTINCT`, `MIN()`, `COUNT(*)`, `COUNT(DISTINCT)`, `JOIN`, `SUBSTR()`, `CAST()`, date-component calculations, `GROUP BY`, and `NULLIF()`.

### Business value
Helps examine how repeat purchasing changes over time and compare historical customer cohorts.

### Limitation
Later cohorts have shorter observation windows. Cohorts should be compared at the same cohort age.

The query reports observed purchasing activity. It does not prove why customers returned or stopped purchasing.

---

## 9. Top-10 Customer Revenue Concentration

**Business question:** What percentage of identified-customer revenue came from the ten highest-spending customers?

### Analysis performed
- Calculates total recorded revenue for each identified customer.
- Ranks customers by revenue.
- Uses `ROW_NUMBER()` to assign distinct ranks.
- Calculates the combined revenue and revenue share of the top ten ranked customers.

### SQL techniques
CTEs, `SUM()`, `GROUP BY`, `ROW_NUMBER()`, window functions, conditional aggregation with `CASE WHEN`, scalar subqueries, and `NULLIF()`.

### Business value
Measures the concentration of recorded revenue among the highest-spending identified customers.

### Limitation
Revenue concentration alone does not establish customer risk, predict future spending, or show that a business depends on these customers for profit.

The query returns the top ten customers when at least ten identified customers are available.

---

## 10. Hourly Demand Analysis

**Business question:** During which recorded hours were invoices most frequent?

### Analysis performed
- Groups transactions by the prepared `invoice_hour` field.
- Counts distinct invoices.
- Calculates recorded revenue for each hour.
- Orders hours by invoice count.

### SQL techniques
`COUNT(DISTINCT)`, `SUM()`, `GROUP BY`, `ROUND()`, and `ORDER BY`.

### Business value
Provides a starting point for investigating transaction timing and possible staffing or operating-hour questions.

### Limitation
The query assumes `invoice_hour` has been prepared correctly. Timezone, timestamp quality, and the retailer's operating context should be verified before using the results operationally.

---

## 11. Weekday Demand Analysis

**Business question:** On which weekdays were invoices most frequent?

### Analysis performed
- Groups transactions by the prepared `weekday` field.
- Counts distinct invoices.
- Calculates recorded revenue.
- Orders weekdays by invoice count.

### SQL techniques
`COUNT(DISTINCT)`, `SUM()`, `GROUP BY`, `ROUND()`, and `ORDER BY`.

### Business value
Helps identify historical differences in transaction volume across weekdays.

### Limitation
The query assumes that the `weekday` field has been prepared correctly. It describes observed transaction patterns rather than proving why demand differs.

---

## 12. Order Value Distribution

**Business question:** How much did invoice values vary during the observation period?

### Analysis performed
- Calculates total revenue for each invoice.
- Counts invoices.
- Calculates mean, minimum, and maximum invoice revenue.

### SQL techniques
CTEs, `SUM()`, `COUNT(*)`, `AVG()`, `MIN()`, `MAX()`, `GROUP BY`, and `ROUND()`.

### Business value
Provides a summary of order values and helps identify the range of recorded invoice amounts.

### Limitation
The mean can be influenced by unusually large orders. Median and percentile measures would provide additional information about the distribution.

---

## 13. Cancellation and Negative-Quantity Audit

**Business question:** How many raw transaction lines have cancellation-style invoice identifiers or negative quantities?

### Analysis performed
- Counts all raw transaction lines.
- Counts invoice identifiers beginning with `C`.
- Counts records with negative quantities.
- Uses the original `raw_transactions` table rather than the cleaned sales table.

### SQL techniques
`COUNT(*)`, `SUM()`, `CASE WHEN`, `CAST()`, `UPPER()`, and `LIKE`.

### Business value
Helps identify records that may require special handling before calculating sales metrics.

### Limitation
Cancellation-style invoice identifiers and negative quantities may overlap. These counts must not be added together without checking for overlap.

Negative quantities can represent returns, and cancellation indicators are not a complete substitute for a finance-approved returns and refunds reconciliation.

---

## 14. Data-Cleaning Impact

**Business question:** How do raw transaction counts compare with the cleaned positive-sales dataset?

### Analysis performed
- Counts raw transaction lines.
- Estimates exact duplicate rows by comparing the raw row count with the count of distinct complete rows.
- Counts cleaned positive-sales records.
- Calculates total revenue in the cleaned sales table.

### SQL techniques
Scalar subqueries, `COUNT(*)`, `SELECT DISTINCT *`, `SUM()`, and `ROUND()`.

### Business value
Makes data preparation more transparent and provides useful checks on the dataset used for analysis.

### Limitation
The difference between raw and cleaned row counts may reflect several cleaning rules, not just duplicate removal. The output does not independently reconcile every exclusion reason.

The exact-duplicate calculation assumes that rows identical across all selected raw columns are considered duplicates.

---

## 15. RFM Customer Segmentation

**Business question:** How can identified customers be grouped by historical purchasing behaviour?

RFM stands for:

- **Recency:** Days since the customer's last recorded purchase.
- **Frequency:** Number of distinct purchase invoices.
- **Monetary:** Total recorded revenue attributed to the customer.

### Analysis performed
- Calculates each customer's last purchase date, invoice count, and recorded revenue.
- Uses the latest available cleaned transaction date as the snapshot date.
- Calculates recency in days.
- Assigns five-level relative scores for recency, frequency, and monetary value.
- Uses conditional logic to assign descriptive customer segments.

### SQL techniques
CTEs, `MAX()`, `COUNT(DISTINCT)`, `SUM()`, `JULIANDAY()`, `CAST()`, `CROSS JOIN`, `NTILE(5)`, window functions, and `CASE WHEN`.

### Business value
Provides a structured way to compare customer groups and identify areas for further customer analysis.

### Limitation
The scores are relative quintiles, not fixed business thresholds. Segment labels depend on the scoring rules and snapshot date.

The segments are descriptive. They are not a validated prediction of churn, future spending, or campaign success.

---

## 16. SQL Skills Demonstrated

The analysis demonstrates the following SQL techniques in the actual query file.

| Skill | Application |
|---|---|
| Aggregation | Revenue, units sold, invoices, and customer metrics |
| Filtering | Excluding unidentified customers from customer-level analyses |
| Grouping | Monthly, product, country, customer, and invoice summaries |
| Conditional logic | Repeat-customer classification and RFM segment assignment |
| Common table expressions | Breaking multi-stage analyses into readable steps |
| Window functions | `LAG()`, `DENSE_RANK()`, `ROW_NUMBER()`, and `NTILE()` |
| Date calculations | Cohort month offsets and RFM recency |
| Revenue-share calculations | Product contribution and customer concentration |
| Data-quality checks | Duplicate-row comparison and cancellation indicators |
| Null and division handling | `NULLIF()` to prevent division-by-zero errors |
| Sorting and limiting | Ranking products and retrieving high-spending customers |

---

## 17. How to Run the Queries

1. Use a SQLite-compatible database containing the required `raw_transactions` and `clean_sales` tables.
2. Open `analysis.sql` in a SQLite-compatible database client.
3. Confirm that all referenced tables and columns exist.
4. Run one query block at a time.
5. Review the results and compare them with the project's documented outputs.
6. Investigate discrepancies before publishing results.

### Required Fields

The analysis assumes that `clean_sales` includes the following fields:

- `invoice_no`
- `stock_code`
- `description`
- `quantity`
- `invoice_date`
- `customer_id`
- `country`
- `revenue`
- `invoice_month`
- `invoice_hour`
- `weekday`

The `raw_transactions` table must include at least the columns referenced by the audit and duplicate-check queries.

The cleaning and preparation process must create and populate these tables before the analysis can run successfully.

---

## 18. Technical Notes

The queries are written for SQLite-compatible SQL and use features including:

- Common table expressions (`WITH`)
- Window functions
- `LAG()`, `DENSE_RANK()`, `ROW_NUMBER()`, and `NTILE()`
- `JULIANDAY()` for date calculations
- `SUBSTR()` and `CAST()` for cohort month calculations
- `SELECT DISTINCT *` for exact-row duplicate comparison

Other database engines may require syntax changes.

## 19. Project Data Source

Chen, D. (2015). *Online Retail* [Dataset]. UCI Machine Learning Repository.

https://doi.org/10.24432/C5BW33

---

**Project focus:** SQL-based retail analytics, revenue intelligence, customer purchasing behaviour, retention measurement, RFM segmentation, and data quality.
