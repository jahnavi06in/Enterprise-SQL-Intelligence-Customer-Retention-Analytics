here# Results Summary — Enterprise SQL Intelligence & Customer Retention Analytics

## 1. Dataset and Scope

- **Dataset:** Online Retail
- **Source:** UCI Machine Learning Repository
- **Original records:** 541,909 transaction lines
- **Observation period:** 1 December 2010 – 9 December 2011
- **Currency:** GBP (£)
- **Revenue definition:** Quantity × Unit Price
- **Analysis scope:** Historical positive-sales transactions

This project analyses historical retail transaction data to investigate revenue performance, product contribution, geographic distribution, customer purchasing behaviour, repeat purchasing, and customer segmentation.

The results describe the historical dataset and should not be interpreted as current retail market performance.

**Important:** Recorded revenue is not profit because product costs, operating expenses, and other business costs are not included.

### Dataset References

- **UCI dataset:** https://archive.ics.uci.edu/dataset/352/online+retail
- **Dataset DOI:** https://doi.org/10.24432/C5BW33

---

## 2. Data Preparation and Cleaning

The Python preparation pipeline processes the source dataset and creates two SQLite tables:

- `raw_transactions` — preserves the original transaction rows for auditing.
- `clean_sales` — contains transactions retained for positive-sales analysis.

The documented preparation approach includes:

1. Loading the original transaction dataset.
2. Inspecting transaction fields and data types.
3. Identifying and removing exact duplicate records.
4. Identifying cancellation invoices using invoice identifiers beginning with `C`.
5. Excluding non-positive quantities and unit prices from positive-sales analysis.
6. Handling missing customer identifiers.
7. Calculating line revenue as quantity multiplied by unit price.
8. Creating the SQLite database and validating the resulting tables.

### Data Preparation Results

| Metric | Result |
|---|---:|
| Original transaction rows | 541,909 |
| Exact duplicate rows documented | 5,268 |
| Clean positive-sales rows | 524,878 |
| Difference between original and cleaned rows | 17,031 |

The difference between the original and cleaned row counts reflects the combined effects of duplicate removal, cancellation handling, and positive-sales filtering.

These exclusion categories may overlap. Therefore, the difference of 17,031 rows must not be interpreted as the number of cancellations or as the number of unique invalid transactions.

The preparation pipeline's cleaning rules and the actual database outputs should be treated as the authoritative basis for the reported figures.

---

## 3. Key Business Metrics

The following metrics are documented in the project's preparation output and analysis results.

| Metric | Reported Result |
|---|---:|
| Clean positive-sales transaction lines | 524,878 |
| Unique invoices | 19,960 |
| Identified customers | 4,338 |
| Unique products | 3,922 |
| Countries represented | 38 |
| Total recorded sales revenue | £10,642,110.80 |
| Average invoice value | £533.17 |
| Repeat customers | 2,845 |
| Repeat-customer rate | 65.58% |

### Metric Definitions

- **Clean transaction lines:** Transaction rows retained in `clean_sales`.
- **Unique invoices:** Distinct invoice identifiers in the cleaned dataset.
- **Identified customers:** Distinct non-missing customer identifiers.
- **Unique products:** Distinct stock codes represented in the cleaned dataset.
- **Recorded sales revenue:** Sum of quantity multiplied by unit price.
- **Average invoice value:** Recorded sales revenue divided by the number of unique invoices, subject to the project's invoice-level calculation.
- **Repeat customers:** Identified customers associated with at least two distinct invoices during the observation period.
- **Repeat-customer rate:** Repeat customers divided by identified customers, multiplied by 100.

Customer-level calculations exclude records without an identified customer ID.

The average invoice value and customer concentration figures should be checked against their corresponding SQL outputs before being treated as independently verified.

---

## 4. Revenue and Sales Performance

### 4.1 Monthly Revenue

The documented monthly analysis identifies the following periods:

| Metric | Month | Recorded Revenue |
|---|---|---:|
| Highest-revenue month | November 2011 | £1,503,866.78 |
| Lowest-revenue month | February 2011 | £522,545.56 |

The monthly revenue analysis groups cleaned transactions by invoice month and calculates total recorded revenue.

These results identify periods of relatively high and low recorded sales. They do not establish the causes of the changes.

Further investigation could examine order volumes, product mix, customer purchasing patterns, and seasonal effects.

### 4.2 Product Performance

The documented results identify **DOTCOM POSTAGE** as the highest-revenue product.

| Metric | Result |
|---|---:|
| Product | DOTCOM POSTAGE |
| Stock code | DOT |
| Recorded revenue | £206,248.77 |
| Share of cleaned positive-sales revenue | 1.94% |

Product rankings help identify products contributing substantially to recorded sales.

However, revenue contribution alone does not establish profitability. Product costs, margins, and the nature of postage-related transactions would need to be examined before making profitability decisions.

### 4.3 Geographic Performance

The United Kingdom is the leading country by recorded revenue in the documented results.

| Metric | Result |
|---|---:|
| Leading country | United Kingdom |
| Recorded revenue | £9,001,744.09 |

The geographic analysis can be extended to compare invoice activity, customer counts, average invoice values, and repeat purchasing across countries.

The results represent this retailer's historical transactions and should not be generalized to the wider retail market.

---

## 5. Customer Purchasing and Retention

### 5.1 Repeat Purchasing

A repeat customer is defined as an identified customer associated with at least two distinct invoices during the observation period.

| Metric | Result |
|---|---:|
| Identified customers | 4,338 |
| Repeat customers | 2,845 |
| Repeat-customer rate | 65.58% |

The repeat-customer rate measures observed purchasing activity within the available historical data.

It does not predict whether customers will purchase again in the future.

### 5.2 Cohort Retention

Cohort analysis groups identified customers by the month of their first recorded purchase and examines their activity in subsequent months.

The analysis helps explore how customer activity changes over time.

Cohort comparisons should account for differences in observation windows. Recent cohorts have fewer subsequent months available than earlier cohorts, so retention should be compared at equivalent cohort ages.

A customer not observed purchasing in a later month should not automatically be classified as permanently lost.

### 5.3 Customer Revenue Concentration

The documented results report that the ten highest-revenue identified customers account for **17.30% of identified-customer revenue**.

This measure describes how recorded customer revenue is distributed among identified customers.

Monitoring customer concentration can help investigate revenue dependence on high-spending customers. However, concentration alone does not establish that the business faces a specific financial or operational risk.

The reported percentage should be reproduced from the corresponding SQL query before being treated as independently verified.

---

## 6. RFM Customer Segmentation

The project uses Recency, Frequency, and Monetary (RFM) analysis to explore differences in historical customer purchasing behaviour.

### Recency

Measures how recently a customer made a purchase relative to the analysis reference date.

### Frequency

Measures the number of distinct invoices associated with a customer.

### Monetary Value

Measures the customer's total recorded revenue.

The SQL analysis assigns relative scores to customers across these three dimensions using ranking and window functions.

These scores help compare customers based on their observed purchasing patterns.

Potential business applications include:

- Identifying customers with recent purchasing activity.
- Exploring groups with frequent transactions.
- Comparing customers by recorded spending.
- Investigating customers whose purchasing activity has declined.
- Developing hypotheses for future customer engagement initiatives.

RFM scores are descriptive measures based on historical data. They do not predict future customer behaviour.

Business labels such as *Champions*, *Loyal*, *At Risk*, or *Needs Nurture* should only be applied when explicit scoring thresholds and classification rules have been defined and implemented.

---

## 7. Data Quality and Auditability

The project retains the raw transaction table separately from the cleaned sales table to support data-quality investigation.

The audit examines:

- Cancellation invoice identifiers.
- Negative quantities.
- Non-positive unit prices.
- Missing customer identifiers.
- Duplicate transaction records.
- Differences between original and cleaned row counts.

The reported raw table contains 541,909 rows, while the cleaned positive-sales table contains 524,878 rows.

### Audit Considerations

1. Cancellation records should be examined separately from positive-sales transactions.
2. Missing customer identifiers limit customer-level analysis but do not necessarily make a transaction unusable for all sales analysis.
3. Exact duplicate detection should compare the original field values rather than rely solely on concatenated strings.
4. Invoice-level metrics should use distinct invoice identifiers where appropriate.
5. Cleaning rules should be documented consistently across the Python pipeline, SQL queries, and project documentation.

The documented duplicate count is 5,268. The concatenation-based SQL audit provides a preliminary check, while the Python cleaning implementation should be used to validate exact duplicate removal.

---

## 8. Tools and Technical Methods

### Python

Used for loading, preparing, cleaning, and validating the transaction dataset.

### SQL and SQLite

Used for structured querying and analysis, including:

- Filtering and aggregation.
- Common table expressions (CTEs).
- Conditional calculations.
- Ranking and window functions.
- Monthly revenue analysis.
- Product and country performance.
- Repeat-purchase analysis.
- Cohort retention.
- Customer revenue concentration.
- RFM scoring.
- Data-quality auditing.

### Pandas

Used to inspect the dataset and display SQL query results.

### GitHub

Used to maintain project code, SQL scripts, documentation, and visualization assets.

---

## 9. Limitations

The analysis has several limitations:

- The dataset covers a single retailer over a historical period ending in December 2011.
- The findings do not represent current retail market conditions.
- Missing customer identifiers restrict customer-level analysis.
- Recorded revenue does not account for all business costs and is not equivalent to profit.
- Returns and cancellations require separate treatment from completed sales.
- Recent customer cohorts have shorter observation windows.
- Historical repeat purchasing does not guarantee future retention.
- RFM scores describe observed customer behaviour rather than predicting future outcomes.
- Descriptive relationships do not establish causation.
- Reported figures depend on the preparation rules and query definitions used.

These limitations should be considered when interpreting the results or proposing business actions.

---

## 10. Reproducibility

The project uses a Python preparation pipeline and SQL analysis against a SQLite database.

To reproduce the results:

1. Obtain the Online Retail dataset from the UCI Machine Learning Repository.
2. Run the Python preparation script in an environment with its required dependencies.
3. Confirm that `raw_transactions` and `clean_sales` are created.
4. Verify the row counts and revenue totals.
5. Run the relevant queries in `analysis.sql`.
6. Compare the query outputs with the figures documented in this summary.

If the dataset, preparation rules, reference dates, or query definitions change, rerun the affected analyses and update the reported results.

The database is generated by the preparation pipeline. It does not need to be committed to GitHub if it is large or reproducible from the source dataset and code.

---

## 11. Project Repository

The repository includes the SQL analysis, Python preparation script, documentation, and visualization images.

Key project files include:

- `README.md` — Project overview and navigation.
- `Prepare_data.py` — Python data preparation and SQLite database creation.
- `analysis.sql` — SQL analytics queries.
- `ANALYSIS_NOTES.md` — Analytical notes.
- `BUSINESS_READOUT.md` — Business interpretation of findings.
- `BUSINESS_RECOMMENDATIONS.md` — Business recommendations.
- `DATA_SOURCE_AND_METHODOLOGY-3.md` — Dataset source and methodology.
- `PROJECT_VISUALIZATIONS.md` — Visualization documentation.
- `RESULTS_SUMMARY.md` — Reported metrics and results.
- `SQL_QUERY_GUIDE.md` — SQL query guide.

The repository also contains visualization images, including monthly revenue, country revenue, product performance, customer retention, and RFM segmentation.

**Note:** File names in this document should match the actual repository. GitHub file paths are case-sensitive.

---

## 12. Project Outcome

This project demonstrates a structured approach to retail transaction analysis using Python, SQL, SQLite, and Pandas.

It brings together data preparation, transaction validation, revenue analysis, customer purchasing metrics, cohort analysis, and RFM scoring.

The objective is to show how transaction-level data can be transformed into interpretable business metrics while documenting analytical assumptions, limitations, and opportunities for further investigation.

The project emphasizes reproducible analysis and responsible interpretation rather than unsupported predictions or profitability claims.

**Author:** Jahnavi J.
