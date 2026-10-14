# Results Summary — UCI Online Retail Dataset

## Dataset and scope
- Source: UCI Machine Learning Repository, Online Retail by Daqing Chen (CC BY 4.0).
- Raw rows loaded: **541,909** transaction lines.
- Raw date span: **2010-12-01 to 2011-12-09**.
- Positive-sales analysis uses deduplicated rows with valid invoice/date, positive quantity and positive unit price, excluding invoices beginning with `C`.
- Revenue is `quantity × unit_price`, reported in **GBP (£)**. It is sales revenue, not profit.

## Key results calculated from the public dataset
- Clean positive-sales lines: **524,878**.
- Unique invoices: **19,960**.
- Identified customers: **4,338**. Customer-level metrics exclude rows with missing customer IDs.
- Unique products: **3,922**; countries represented: **38**.
- Clean positive-sales revenue: **£10,642,110.80**.
- Average invoice value: **£533.17**.
- Repeat-customer rate: **65.58%** (2,845 of 4,338 identified customers placed at least two distinct invoices in the observed period).
- Top product by revenue: **DOTCOM POSTAGE** (stock code DOT), **£206,248.77** (1.94% of cleaned positive-sales revenue).
- Top country by revenue: **United Kingdom**, **£9,001,744.09**.
- Highest-revenue month: **2011-11** (£1,503,866.78); lowest-revenue month: **2011-02** (£522,545.56).
- Top 10 identified customers account for **17.30%** of identified-customer revenue.

## Interpretation and limitations
1. **Retention is historical and descriptive.** Repeat rate covers only customers with IDs in the 2010–2011 observation window; it is not a future churn probability.
2. **Sales revenue is not profit.** The dataset has no cost, margin, or marketing spend fields.
3. **Returns and cancellations are treated separately.** Negative quantities and invoices beginning with `C` are excluded from positive-sales metrics. The audit is not a complete accounting reconciliation.
4. **Customer concentration is a monitoring signal, not proof of risk.** Further customer context and future-period validation are needed.
5. **Cohorts are right-censored.** Recent cohorts have fewer observable months; compare retention at matched cohort ages.
6. **Historical scope matters.** The data end in December 2011 and should not be described as current market performance.

## Cleaning summary
- Raw rows: 541,909
- Exact duplicates detected: 5,268
- Clean positive-sales rows retained: 524,878
- Raw rows not present in cleaned positive-sales table: 17,031. This combines multiple exclusion reasons.

## Outputs
CSV result tables are in `outputs/`; charts are in `visuals/`; SQL logic is in `sql/analysis.sql`; SQLite tables are `raw_transactions` and `clean_sales` in `customer_retention_analytics.db`.
